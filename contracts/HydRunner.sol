// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title HydRunner
 * @dev GPS Runner contract for Hyderabad region
 * Stores GPS markers with anti-cheat validation
 * Deploy on Polygon Amoy Testnet
 */
contract HydRunner {
    // ============ Constants ============

    // Hyderabad bounds (multiplied by 1e6 for precision)
    uint256 public constant MIN_LAT = 17300000;  // 17.3°N
    uint256 public constant MAX_LAT = 17500000;  // 17.5°N
    uint256 public constant MIN_LNG = 78300000;  // 78.3°E
    uint256 public constant MAX_LNG = 78600000;  // 78.6°E

    // Anti-cheat limits
    uint16 public constant MAX_SPEED_KMH = 29;  // Max running speed
    uint16 public constant MIN_STEPS_PER_MIN = 40;  // Minimum steps for walking

    // Grid cell size for duplicate prevention (approx 100m)
    uint256 public constant GRID_PRECISION = 1000;  // 0.001 degrees

    // ============ Structs ============

    struct Marker {
        address player;
        uint256 lat1e6;
        uint256 lng1e6;
        string landmark;
        uint8 activityType;  // 0=ON_FOOT, 1=WALKING, 2=RUNNING
        uint16 speedKmh;
        uint16 stepsPerMin;
        uint256 timestamp;
    }

    struct PlayerStats {
        uint256 totalMarkers;
        uint256 totalDistance;
        uint256 lastMarkerTime;
    }

    // ============ State ============

    Marker[] public markers;
    mapping(address => PlayerStats) public playerStats;
    mapping(address => uint256[]) public playerMarkerIds;
    mapping(bytes32 => bool) public gridCellUsed;  // Prevent duplicate markers

    address public owner;
    bool public paused;

    // ============ Events ============

    event MarkerAdded(
        address indexed player,
        uint256 lat1e6,
        uint256 lng1e6,
        string landmark,
        uint256 timestamp
    );

    event PlayerStatsUpdated(
        address indexed player,
        uint256 totalMarkers,
        uint256 lastMarkerTime
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

    modifier validCoordinates(uint256 _lat1e6, uint256 _lng1e6) {
        require(
            _lat1e6 >= MIN_LAT && _lat1e6 <= MAX_LAT,
            "Latitude out of Hyderabad bounds"
        );
        require(
            _lng1e6 >= MIN_LNG && _lng1e6 <= MAX_LNG,
            "Longitude out of Hyderabad bounds"
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
     * @dev Submit a new GPS marker with anti-cheat validation
     */
    function submitMarker(
        uint256 _lat1e6,
        uint256 _lng1e6,
        string calldata _landmark,
        uint8 _activityType,
        uint16 _speedKmh,
        uint16 _stepsPerMin
    )
        external
        whenNotPaused
        validCoordinates(_lat1e6, _lng1e6)
        validActivity(_activityType, _speedKmh, _stepsPerMin)
    {
        // Check for duplicate in same grid cell
        bytes32 gridHash = _getGridHash(msg.sender, _lat1e6, _lng1e6);
        require(!gridCellUsed[gridHash], "Already marked this location");

        // Rate limit: 1 marker per 30 seconds
        require(
            block.timestamp >= playerStats[msg.sender].lastMarkerTime + 30,
            "Too soon - wait 30 seconds"
        );

        // Create marker
        Marker memory newMarker = Marker({
            player: msg.sender,
            lat1e6: _lat1e6,
            lng1e6: _lng1e6,
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
        playerStats[msg.sender].totalMarkers++;
        playerStats[msg.sender].lastMarkerTime = block.timestamp;

        // Emit events
        emit MarkerAdded(msg.sender, _lat1e6, _lng1e6, _landmark, block.timestamp);
        emit PlayerStatsUpdated(
            msg.sender,
            playerStats[msg.sender].totalMarkers,
            block.timestamp
        );
    }

    // ============ View Functions ============

    function getTotalMarkers() external view returns (uint256) {
        return markers.length;
    }

    function getMarkerByIndex(uint256 _index) external view returns (
        address player,
        uint256 lat1e6,
        uint256 lng1e6,
        string memory landmark,
        uint256 timestamp
    ) {
        require(_index < markers.length, "Index out of bounds");
        Marker storage m = markers[_index];
        return (m.player, m.lat1e6, m.lng1e6, m.landmark, m.timestamp);
    }

    function getPlayerMarkerCount(address _player) external view returns (uint256) {
        return playerStats[_player].totalMarkers;
    }

    function getPlayerMarkerIds(address _player) external view returns (uint256[] memory) {
        return playerMarkerIds[_player];
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

    function getLeaderboard(uint256 _limit) external view returns (
        address[] memory players,
        uint256[] memory counts
    ) {
        uint256 limit = _limit > 100 ? 100 : _limit;
        players = new address[](limit);
        counts = new uint256[](limit);

        return (players, counts);
    }

    // ============ Internal Functions ============

    function _getGridHash(
        address _player,
        uint256 _lat1e6,
        uint256 _lng1e6
    ) internal pure returns (bytes32) {
        uint256 gridLat = _lat1e6 / GRID_PRECISION;
        uint256 gridLng = _lng1e6 / GRID_PRECISION;
        return keccak256(abi.encodePacked(_player, gridLat, gridLng));
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
