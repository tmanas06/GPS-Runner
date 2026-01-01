// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title IndiaRunner
 * @dev Unified GPS Runner contract for all of India
 * Supports dynamic city/state detection, leaderboards, and distance tracking
 * Deploy on Polygon Amoy Testnet
 */
contract IndiaRunner {
    // ============ Constants ============

    // India bounds (multiplied by 1e6 for precision)
    uint256 public constant MIN_LAT = 6000000;   // 6.0°N (Kanyakumari)
    uint256 public constant MAX_LAT = 35500000;  // 35.5°N (Kashmir)
    uint256 public constant MIN_LNG = 68000000;  // 68.0°E (Gujarat)
    uint256 public constant MAX_LNG = 97500000;  // 97.5°E (Arunachal)

    // Anti-cheat limits
    uint16 public constant MAX_SPEED_KMH = 29;
    uint16 public constant MIN_STEPS_PER_MIN = 40;

    // Grid cell size for duplicate prevention (approx 100m)
    uint256 public constant GRID_PRECISION = 1000;

    // Rate limit between markers (seconds)
    uint256 public constant MARKER_COOLDOWN = 30;

    // ============ Structs ============

    struct Marker {
        address player;
        uint256 lat1e6;
        uint256 lng1e6;
        bytes32 stateHash;      // Hash of state name
        bytes32 cityHash;       // Hash of city name
        string landmark;
        uint8 activityType;
        uint16 speedKmh;
        uint16 stepsPerMin;
        uint256 timestamp;
    }

    struct PlayerStats {
        uint256 totalMarkers;
        uint256 totalDistanceMeters;
        uint256 lastMarkerTime;
        uint256 lastLat1e6;
        uint256 lastLng1e6;
        bytes32 homeState;      // Player's home state (first location)
        bytes32 homeCity;       // Player's home city
        bool isRegistered;
    }

    struct CityStats {
        uint256 totalMarkers;
        uint256 totalPlayers;
        uint256 lastActivity;
    }

    struct LeaderboardEntry {
        address player;
        uint256 markerCount;
        uint256 totalDistance;
    }

    // ============ State ============

    Marker[] public markers;

    // Player data
    mapping(address => PlayerStats) public playerStats;
    mapping(address => uint256[]) public playerMarkerIds;
    mapping(address => mapping(bytes32 => uint256)) public playerCityMarkers; // player => cityHash => count

    // City/State data
    mapping(bytes32 => CityStats) public cityStats;
    mapping(bytes32 => CityStats) public stateStats;
    mapping(bytes32 => address[]) public cityPlayers;  // cityHash => players
    mapping(bytes32 => address[]) public statePlayers; // stateHash => players

    // Leaderboards (stored as arrays for gas efficiency)
    address[] public globalLeaderboard;
    mapping(bytes32 => address[]) public cityLeaderboards;  // cityHash => sorted players
    mapping(bytes32 => address[]) public stateLeaderboards; // stateHash => sorted players

    // Duplicate prevention
    mapping(bytes32 => bool) public gridCellUsed;

    // Global stats
    uint256 public totalPlayersCount;
    uint256 public totalMarkersCount;
    uint256 public totalDistanceMeters;

    address public owner;
    bool public paused;

    // ============ Events ============

    event PlayerRegistered(
        address indexed player,
        bytes32 indexed stateHash,
        bytes32 indexed cityHash,
        uint256 timestamp
    );

    event MarkerAdded(
        address indexed player,
        bytes32 indexed cityHash,
        uint256 lat1e6,
        uint256 lng1e6,
        string landmark,
        uint256 distanceMeters,
        uint256 timestamp
    );

    event LeaderboardUpdated(
        bytes32 indexed cityHash,
        address indexed player,
        uint256 newRank
    );

    event DistanceRecorded(
        address indexed player,
        uint256 distanceMeters,
        uint256 totalDistance
    );

    // ============ Modifiers ============

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier whenNotPaused() {
        require(!paused, "Contract paused");
        _;
    }

    modifier validIndiaCoordinates(uint256 _lat1e6, uint256 _lng1e6) {
        require(
            _lat1e6 >= MIN_LAT && _lat1e6 <= MAX_LAT,
            "Latitude out of India bounds"
        );
        require(
            _lng1e6 >= MIN_LNG && _lng1e6 <= MAX_LNG,
            "Longitude out of India bounds"
        );
        _;
    }

    modifier validActivity(uint8 _activityType, uint16 _speedKmh, uint16 _stepsPerMin) {
        require(_activityType <= 2, "Invalid activity type");
        require(_speedKmh <= MAX_SPEED_KMH, "Speed too high - vehicle detected");
        require(
            _stepsPerMin >= MIN_STEPS_PER_MIN || _speedKmh == 0,
            "Steps too low for movement"
        );
        _;
    }

    // ============ Constructor ============

    constructor() {
        owner = msg.sender;
    }

    // ============ Main Functions ============

    /**
     * @dev Submit a new GPS marker with auto-registration
     * If player is new, they are automatically registered with their location
     */
    function submitMarker(
        uint256 _lat1e6,
        uint256 _lng1e6,
        bytes32 _stateHash,
        bytes32 _cityHash,
        string calldata _landmark,
        uint8 _activityType,
        uint16 _speedKmh,
        uint16 _stepsPerMin
    )
        external
        whenNotPaused
        validIndiaCoordinates(_lat1e6, _lng1e6)
        validActivity(_activityType, _speedKmh, _stepsPerMin)
    {
        PlayerStats storage player = playerStats[msg.sender];

        // Auto-register new player
        if (!player.isRegistered) {
            _registerPlayer(msg.sender, _stateHash, _cityHash);
        }

        // Check for duplicate in same grid cell
        bytes32 gridHash = _getGridHash(msg.sender, _lat1e6, _lng1e6);
        require(!gridCellUsed[gridHash], "Already marked this location");

        // Rate limit: 1 marker per MARKER_COOLDOWN seconds
        require(
            block.timestamp >= player.lastMarkerTime + MARKER_COOLDOWN,
            "Too soon - wait 30 seconds"
        );

        // Calculate distance from last position
        uint256 distanceMeters = 0;
        if (player.lastLat1e6 > 0 && player.lastLng1e6 > 0) {
            distanceMeters = _calculateDistance(
                player.lastLat1e6,
                player.lastLng1e6,
                _lat1e6,
                _lng1e6
            );
        }

        // Create marker
        Marker memory newMarker = Marker({
            player: msg.sender,
            lat1e6: _lat1e6,
            lng1e6: _lng1e6,
            stateHash: _stateHash,
            cityHash: _cityHash,
            landmark: _landmark,
            activityType: _activityType,
            speedKmh: _speedKmh,
            stepsPerMin: _stepsPerMin,
            timestamp: block.timestamp
        });

        // Store marker
        uint256 markerId = markers.length;
        markers.push(newMarker);
        playerMarkerIds[msg.sender].push(markerId);
        gridCellUsed[gridHash] = true;

        // Update player stats
        player.totalMarkers++;
        player.totalDistanceMeters += distanceMeters;
        player.lastMarkerTime = block.timestamp;
        player.lastLat1e6 = _lat1e6;
        player.lastLng1e6 = _lng1e6;

        // Update city markers for this player
        uint256 prevCityCount = playerCityMarkers[msg.sender][_cityHash];
        playerCityMarkers[msg.sender][_cityHash]++;

        // Update city stats
        if (prevCityCount == 0) {
            // First marker in this city for this player
            cityStats[_cityHash].totalPlayers++;
            cityPlayers[_cityHash].push(msg.sender);
        }
        cityStats[_cityHash].totalMarkers++;
        cityStats[_cityHash].lastActivity = block.timestamp;

        // Update state stats
        stateStats[_stateHash].totalMarkers++;
        stateStats[_stateHash].lastActivity = block.timestamp;

        // Update global stats
        totalMarkersCount++;
        totalDistanceMeters += distanceMeters;

        // Update leaderboards
        _updateCityLeaderboard(_cityHash, msg.sender);
        _updateGlobalLeaderboard(msg.sender);

        emit MarkerAdded(
            msg.sender,
            _cityHash,
            _lat1e6,
            _lng1e6,
            _landmark,
            distanceMeters,
            block.timestamp
        );

        if (distanceMeters > 0) {
            emit DistanceRecorded(msg.sender, distanceMeters, player.totalDistanceMeters);
        }
    }

    /**
     * @dev Register a new player with their home location
     */
    function _registerPlayer(
        address _player,
        bytes32 _stateHash,
        bytes32 _cityHash
    ) internal {
        PlayerStats storage player = playerStats[_player];
        player.isRegistered = true;
        player.homeState = _stateHash;
        player.homeCity = _cityHash;

        // Add to state players
        statePlayers[_stateHash].push(_player);
        stateStats[_stateHash].totalPlayers++;

        totalPlayersCount++;

        emit PlayerRegistered(_player, _stateHash, _cityHash, block.timestamp);
    }

    // ============ Leaderboard Functions ============

    function _updateCityLeaderboard(bytes32 _cityHash, address _player) internal {
        address[] storage leaderboard = cityLeaderboards[_cityHash];
        uint256 playerMarkers = playerCityMarkers[_player][_cityHash];

        // Find current position
        int256 currentPos = -1;
        for (uint256 i = 0; i < leaderboard.length; i++) {
            if (leaderboard[i] == _player) {
                currentPos = int256(i);
                break;
            }
        }

        // Find new position
        uint256 newPos = leaderboard.length;
        for (uint256 i = 0; i < leaderboard.length; i++) {
            if (playerCityMarkers[leaderboard[i]][_cityHash] < playerMarkers) {
                newPos = i;
                break;
            }
        }

        // Remove from current position if exists
        if (currentPos >= 0) {
            for (uint256 i = uint256(currentPos); i < leaderboard.length - 1; i++) {
                leaderboard[i] = leaderboard[i + 1];
            }
            leaderboard.pop();
            if (uint256(currentPos) < newPos) {
                newPos--;
            }
        }

        // Insert at new position (max 100)
        if (newPos < 100) {
            if (leaderboard.length < 100) {
                leaderboard.push(address(0));
            }
            for (uint256 i = leaderboard.length - 1; i > newPos; i--) {
                leaderboard[i] = leaderboard[i - 1];
            }
            leaderboard[newPos] = _player;

            emit LeaderboardUpdated(_cityHash, _player, newPos + 1);
        }
    }

    function _updateGlobalLeaderboard(address _player) internal {
        uint256 playerMarkers = playerStats[_player].totalMarkers;

        int256 currentPos = -1;
        for (uint256 i = 0; i < globalLeaderboard.length; i++) {
            if (globalLeaderboard[i] == _player) {
                currentPos = int256(i);
                break;
            }
        }

        uint256 newPos = globalLeaderboard.length;
        for (uint256 i = 0; i < globalLeaderboard.length; i++) {
            if (playerStats[globalLeaderboard[i]].totalMarkers < playerMarkers) {
                newPos = i;
                break;
            }
        }

        if (currentPos >= 0) {
            for (uint256 i = uint256(currentPos); i < globalLeaderboard.length - 1; i++) {
                globalLeaderboard[i] = globalLeaderboard[i + 1];
            }
            globalLeaderboard.pop();
            if (uint256(currentPos) < newPos) {
                newPos--;
            }
        }

        if (newPos < 100) {
            if (globalLeaderboard.length < 100) {
                globalLeaderboard.push(address(0));
            }
            for (uint256 i = globalLeaderboard.length - 1; i > newPos; i--) {
                globalLeaderboard[i] = globalLeaderboard[i - 1];
            }
            globalLeaderboard[newPos] = _player;
        }
    }

    // ============ View Functions ============

    function getTotalMarkers() external view returns (uint256) {
        return markers.length;
    }

    function getMarkerByIndex(uint256 _index) external view returns (
        address player,
        uint256 lat1e6,
        uint256 lng1e6,
        bytes32 cityHash,
        string memory landmark,
        uint256 timestamp
    ) {
        require(_index < markers.length, "Index out of bounds");
        Marker storage m = markers[_index];
        return (m.player, m.lat1e6, m.lng1e6, m.cityHash, m.landmark, m.timestamp);
    }

    function getPlayerStats(address _player) external view returns (
        uint256 markers,
        uint256 distanceMeters,
        bytes32 homeState,
        bytes32 homeCity,
        bool isRegistered
    ) {
        PlayerStats storage p = playerStats[_player];
        return (p.totalMarkers, p.totalDistanceMeters, p.homeState, p.homeCity, p.isRegistered);
    }

    function getPlayerMarkerCount(address _player) external view returns (uint256) {
        return playerStats[_player].totalMarkers;
    }

    function getPlayerDistance(address _player) external view returns (uint256) {
        return playerStats[_player].totalDistanceMeters;
    }

    function getPlayerCityMarkerCount(address _player, bytes32 _cityHash) external view returns (uint256) {
        return playerCityMarkers[_player][_cityHash];
    }

    function getCityStats(bytes32 _cityHash) external view returns (
        uint256 totalMarkers,
        uint256 totalPlayers,
        uint256 lastActivity
    ) {
        CityStats storage c = cityStats[_cityHash];
        return (c.totalMarkers, c.totalPlayers, c.lastActivity);
    }

    function getStateStats(bytes32 _stateHash) external view returns (
        uint256 totalMarkers,
        uint256 totalPlayers,
        uint256 lastActivity
    ) {
        CityStats storage s = stateStats[_stateHash];
        return (s.totalMarkers, s.totalPlayers, s.lastActivity);
    }

    function getGlobalLeaderboard(uint256 _limit) external view returns (
        address[] memory players,
        uint256[] memory markerCounts,
        uint256[] memory distances
    ) {
        uint256 count = _limit > globalLeaderboard.length ? globalLeaderboard.length : _limit;
        players = new address[](count);
        markerCounts = new uint256[](count);
        distances = new uint256[](count);

        for (uint256 i = 0; i < count; i++) {
            players[i] = globalLeaderboard[i];
            markerCounts[i] = playerStats[globalLeaderboard[i]].totalMarkers;
            distances[i] = playerStats[globalLeaderboard[i]].totalDistanceMeters;
        }
    }

    function getCityLeaderboard(bytes32 _cityHash, uint256 _limit) external view returns (
        address[] memory players,
        uint256[] memory markerCounts
    ) {
        address[] storage leaderboard = cityLeaderboards[_cityHash];
        uint256 count = _limit > leaderboard.length ? leaderboard.length : _limit;

        players = new address[](count);
        markerCounts = new uint256[](count);

        for (uint256 i = 0; i < count; i++) {
            players[i] = leaderboard[i];
            markerCounts[i] = playerCityMarkers[leaderboard[i]][_cityHash];
        }
    }

    function getRecentMarkers(uint256 _count) external view returns (Marker[] memory) {
        uint256 total = markers.length;
        uint256 count = _count > total ? total : _count;

        Marker[] memory recent = new Marker[](count);
        for (uint256 i = 0; i < count; i++) {
            recent[i] = markers[total - 1 - i];
        }
        return recent;
    }

    // ============ Utility Functions ============

    function _getGridHash(
        address _player,
        uint256 _lat1e6,
        uint256 _lng1e6
    ) internal pure returns (bytes32) {
        uint256 gridLat = _lat1e6 / GRID_PRECISION;
        uint256 gridLng = _lng1e6 / GRID_PRECISION;
        return keccak256(abi.encodePacked(_player, gridLat, gridLng));
    }

    /**
     * @dev Calculate distance between two points using Haversine approximation
     * Returns distance in meters
     */
    function _calculateDistance(
        uint256 lat1,
        uint256 lng1,
        uint256 lat2,
        uint256 lng2
    ) internal pure returns (uint256) {
        // Simplified distance calculation
        // 1 degree latitude ≈ 111km
        // We're working with 1e6 scaled values

        int256 dLat = int256(lat2) - int256(lat1);
        int256 dLng = int256(lng2) - int256(lng1);

        // Convert to absolute values
        uint256 absLatDiff = dLat >= 0 ? uint256(dLat) : uint256(-dLat);
        uint256 absLngDiff = dLng >= 0 ? uint256(dLng) : uint256(-dLng);

        // Distance in meters (111m per 0.001 degree, we have 1e6 precision)
        // 111000m per degree, our values are in 1e-6 degrees
        // So: distance_m = diff_1e6 * 111000 / 1000000 = diff_1e6 * 0.111
        uint256 latDistMeters = (absLatDiff * 111) / 1000;
        uint256 lngDistMeters = (absLngDiff * 111) / 1000; // Simplified, ignores lat adjustment

        // Pythagorean approximation
        return _sqrt(latDistMeters * latDistMeters + lngDistMeters * lngDistMeters);
    }

    function _sqrt(uint256 x) internal pure returns (uint256) {
        if (x == 0) return 0;
        uint256 z = (x + 1) / 2;
        uint256 y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
        return y;
    }

    // ============ Admin Functions ============

    function pause() external onlyOwner {
        paused = true;
    }

    function unpause() external onlyOwner {
        paused = false;
    }

    function transferOwnership(address _newOwner) external onlyOwner {
        require(_newOwner != address(0), "Invalid address");
        owner = _newOwner;
    }
}
