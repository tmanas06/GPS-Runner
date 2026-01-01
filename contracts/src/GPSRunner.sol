// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";

/**
 * @title GPSRunner
 * @dev Main contract for GPS Runner game - handles markers, players, and GPS proofs
 * @notice Efficient storage using packed structs and mappings
 */
contract GPSRunner is Ownable, ReentrancyGuard, Pausable {
    // ============ Constants ============
    uint256 public constant MAX_MARKERS_PER_LOCATION = 100;
    uint256 public constant MARKER_COOLDOWN = 30 seconds;
    uint256 public constant MAX_SPEED_KMH = 150; // Anti-cheat: max realistic speed
    int256 public constant COORDINATE_PRECISION = 1e6; // 6 decimal places

    // ============ Structs ============

    /// @dev Packed struct for efficient storage (fits in 2 slots)
    struct Player {
        address wallet;
        uint64 registeredAt;
        uint32 totalMarkers;
        uint32 totalDistance; // in meters
        bytes3 color; // RGB color (3 bytes)
        bool isActive;
    }

    /// @dev GPS Marker with proof data (fits in 3 slots)
    struct Marker {
        bytes32 playerId;
        int32 latitude; // scaled by 1e6
        int32 longitude; // scaled by 1e6
        uint64 timestamp;
        uint16 speedKmh;
        bytes32 cityHash;
        bytes32 landmarkHash;
        bool verified;
    }

    /// @dev City statistics
    struct CityStats {
        uint32 totalMarkers;
        uint32 totalPlayers;
        uint64 lastActivity;
    }

    /// @dev Location proof for verification
    struct LocationProof {
        int32 latitude;
        int32 longitude;
        uint64 timestamp;
        uint16 speedKmh;
        bytes32 deviceHash;
        bytes signature;
    }

    // ============ State Variables ============

    // Player mappings
    mapping(bytes32 => Player) public players;
    mapping(address => bytes32) public walletToPlayerId;
    mapping(bytes32 => uint256) public playerMarkerCount;
    mapping(bytes32 => mapping(bytes32 => uint256)) public playerCityMarkers; // playerId => cityHash => count

    // Marker storage
    mapping(bytes32 => Marker) public markers; // markerId => Marker
    mapping(bytes32 => bytes32[]) public cityMarkers; // cityHash => markerIds
    mapping(bytes32 => uint64) public playerLastMarkerTime;

    // City mappings
    mapping(bytes32 => CityStats) public cityStats;
    mapping(bytes32 => bytes32[]) public cityPlayers; // cityHash => playerIds

    // Leaderboards (top 100 per city)
    mapping(bytes32 => bytes32[]) public cityLeaderboard; // cityHash => sorted playerIds

    // Anti-cheat
    mapping(bytes32 => int32) public playerLastLat;
    mapping(bytes32 => int32) public playerLastLon;
    mapping(bytes32 => uint64) public playerLastTime;

    // Global stats
    uint256 public totalPlayers;
    uint256 public totalMarkers;

    // Trusted verifiers for GPS proofs
    mapping(address => bool) public trustedVerifiers;

    // ============ Events ============

    event PlayerRegistered(bytes32 indexed playerId, address indexed wallet, bytes3 color);
    event PlayerUpdated(bytes32 indexed playerId, bytes3 newColor);
    event MarkerPlaced(
        bytes32 indexed markerId,
        bytes32 indexed playerId,
        bytes32 indexed cityHash,
        int32 latitude,
        int32 longitude,
        uint64 timestamp
    );
    event MarkerVerified(bytes32 indexed markerId, address verifier);
    event CityJoined(bytes32 indexed playerId, bytes32 indexed cityHash);
    event LeaderboardUpdated(bytes32 indexed cityHash, bytes32 indexed playerId, uint256 newRank);
    event VerifierAdded(address indexed verifier);
    event VerifierRemoved(address indexed verifier);

    // ============ Errors ============

    error PlayerAlreadyExists();
    error PlayerNotFound();
    error InvalidCoordinates();
    error CooldownNotMet();
    error SpeedTooHigh();
    error InvalidProof();
    error NotAuthorized();
    error MarkerNotFound();
    error CityFull();

    // ============ Constructor ============

    constructor() Ownable(msg.sender) {
        trustedVerifiers[msg.sender] = true;
    }

    // ============ Modifiers ============

    modifier onlyVerifier() {
        if (!trustedVerifiers[msg.sender] && msg.sender != owner()) {
            revert NotAuthorized();
        }
        _;
    }

    modifier playerExists(bytes32 playerId) {
        if (players[playerId].wallet == address(0)) {
            revert PlayerNotFound();
        }
        _;
    }

    // ============ Player Functions ============

    /**
     * @notice Register a new player
     * @param playerId Unique player identifier (hash of name + wallet)
     * @param color RGB color for the player (3 bytes)
     */
    function registerPlayer(bytes32 playerId, bytes3 color) external whenNotPaused {
        if (players[playerId].wallet != address(0)) {
            revert PlayerAlreadyExists();
        }
        if (walletToPlayerId[msg.sender] != bytes32(0)) {
            revert PlayerAlreadyExists();
        }

        players[playerId] = Player({
            wallet: msg.sender,
            registeredAt: uint64(block.timestamp),
            totalMarkers: 0,
            totalDistance: 0,
            color: color,
            isActive: true
        });

        walletToPlayerId[msg.sender] = playerId;
        totalPlayers++;

        emit PlayerRegistered(playerId, msg.sender, color);
    }

    /**
     * @notice Update player color
     * @param playerId Player identifier
     * @param newColor New RGB color
     */
    function updatePlayerColor(bytes32 playerId, bytes3 newColor)
        external
        playerExists(playerId)
    {
        if (players[playerId].wallet != msg.sender) {
            revert NotAuthorized();
        }

        players[playerId].color = newColor;
        emit PlayerUpdated(playerId, newColor);
    }

    /**
     * @notice Get player info
     */
    function getPlayer(bytes32 playerId) external view returns (
        address wallet,
        uint64 registeredAt,
        uint32 totalMarkersCount,
        uint32 totalDistance,
        bytes3 color,
        bool isActive
    ) {
        Player memory p = players[playerId];
        return (p.wallet, p.registeredAt, p.totalMarkers, p.totalDistance, p.color, p.isActive);
    }

    // ============ Marker Functions ============

    /**
     * @notice Place a new GPS marker
     * @param playerId Player placing the marker
     * @param latitude Latitude scaled by 1e6
     * @param longitude Longitude scaled by 1e6
     * @param cityHash Hash of the city name
     * @param landmarkHash Hash of the landmark name
     * @param speedKmh Speed in km/h
     */
    function placeMarker(
        bytes32 playerId,
        int32 latitude,
        int32 longitude,
        bytes32 cityHash,
        bytes32 landmarkHash,
        uint16 speedKmh
    ) external whenNotPaused nonReentrant playerExists(playerId) returns (bytes32 markerId) {
        // Verify caller owns the player
        if (players[playerId].wallet != msg.sender) {
            revert NotAuthorized();
        }

        // Validate coordinates
        if (latitude < -90000000 || latitude > 90000000 ||
            longitude < -180000000 || longitude > 180000000) {
            revert InvalidCoordinates();
        }

        // Check cooldown
        if (block.timestamp < playerLastMarkerTime[playerId] + MARKER_COOLDOWN) {
            revert CooldownNotMet();
        }

        // Anti-cheat: Check speed between markers
        if (playerLastTime[playerId] > 0) {
            uint256 calculatedSpeed = _calculateSpeed(
                playerLastLat[playerId],
                playerLastLon[playerId],
                latitude,
                longitude,
                playerLastTime[playerId],
                uint64(block.timestamp)
            );
            if (calculatedSpeed > MAX_SPEED_KMH) {
                revert SpeedTooHigh();
            }
        }

        // Generate marker ID
        markerId = keccak256(abi.encodePacked(
            playerId,
            latitude,
            longitude,
            block.timestamp,
            block.prevrandao
        ));

        // Store marker
        markers[markerId] = Marker({
            playerId: playerId,
            latitude: latitude,
            longitude: longitude,
            timestamp: uint64(block.timestamp),
            speedKmh: speedKmh,
            cityHash: cityHash,
            landmarkHash: landmarkHash,
            verified: false
        });

        // Update mappings
        cityMarkers[cityHash].push(markerId);
        playerMarkerCount[playerId]++;
        playerCityMarkers[playerId][cityHash]++;

        // Update player stats
        players[playerId].totalMarkers++;
        if (playerLastTime[playerId] > 0) {
            uint32 distance = uint32(_calculateDistance(
                playerLastLat[playerId],
                playerLastLon[playerId],
                latitude,
                longitude
            ));
            players[playerId].totalDistance += distance;
        }

        // Update city stats
        if (cityStats[cityHash].totalMarkers == 0) {
            // First marker in city
            cityStats[cityHash].totalPlayers = 1;
        } else if (playerCityMarkers[playerId][cityHash] == 1) {
            // Player's first marker in this city
            cityStats[cityHash].totalPlayers++;
            cityPlayers[cityHash].push(playerId);
            emit CityJoined(playerId, cityHash);
        }
        cityStats[cityHash].totalMarkers++;
        cityStats[cityHash].lastActivity = uint64(block.timestamp);

        // Update anti-cheat tracking
        playerLastLat[playerId] = latitude;
        playerLastLon[playerId] = longitude;
        playerLastTime[playerId] = uint64(block.timestamp);
        playerLastMarkerTime[playerId] = uint64(block.timestamp);

        // Update global stats
        totalMarkers++;

        // Update leaderboard
        _updateLeaderboard(cityHash, playerId);

        emit MarkerPlaced(markerId, playerId, cityHash, latitude, longitude, uint64(block.timestamp));

        return markerId;
    }

    /**
     * @notice Verify a marker (by trusted verifier)
     */
    function verifyMarker(bytes32 markerId) external onlyVerifier {
        if (markers[markerId].timestamp == 0) {
            revert MarkerNotFound();
        }
        markers[markerId].verified = true;
        emit MarkerVerified(markerId, msg.sender);
    }

    /**
     * @notice Batch verify markers
     */
    function batchVerifyMarkers(bytes32[] calldata markerIds) external onlyVerifier {
        for (uint256 i = 0; i < markerIds.length; i++) {
            if (markers[markerIds[i]].timestamp != 0) {
                markers[markerIds[i]].verified = true;
                emit MarkerVerified(markerIds[i], msg.sender);
            }
        }
    }

    /**
     * @notice Get marker info
     */
    function getMarker(bytes32 markerId) external view returns (
        bytes32 playerId,
        int32 latitude,
        int32 longitude,
        uint64 timestamp,
        uint16 speedKmh,
        bytes32 cityHash,
        bytes32 landmarkHash,
        bool verified
    ) {
        Marker memory m = markers[markerId];
        return (m.playerId, m.latitude, m.longitude, m.timestamp, m.speedKmh, m.cityHash, m.landmarkHash, m.verified);
    }

    /**
     * @notice Get markers for a city (paginated)
     */
    function getCityMarkers(bytes32 cityHash, uint256 offset, uint256 limit)
        external
        view
        returns (bytes32[] memory)
    {
        bytes32[] storage allMarkers = cityMarkers[cityHash];
        uint256 total = allMarkers.length;

        if (offset >= total) {
            return new bytes32[](0);
        }

        uint256 end = offset + limit;
        if (end > total) {
            end = total;
        }

        bytes32[] memory result = new bytes32[](end - offset);
        for (uint256 i = offset; i < end; i++) {
            result[i - offset] = allMarkers[i];
        }

        return result;
    }

    // ============ Leaderboard Functions ============

    /**
     * @notice Get city leaderboard
     */
    function getCityLeaderboard(bytes32 cityHash, uint256 limit)
        external
        view
        returns (bytes32[] memory playerIds, uint256[] memory markerCounts)
    {
        bytes32[] storage leaderboard = cityLeaderboard[cityHash];
        uint256 count = leaderboard.length < limit ? leaderboard.length : limit;

        playerIds = new bytes32[](count);
        markerCounts = new uint256[](count);

        for (uint256 i = 0; i < count; i++) {
            playerIds[i] = leaderboard[i];
            markerCounts[i] = playerCityMarkers[leaderboard[i]][cityHash];
        }

        return (playerIds, markerCounts);
    }

    /**
     * @notice Internal function to update leaderboard
     */
    function _updateLeaderboard(bytes32 cityHash, bytes32 playerId) internal {
        bytes32[] storage leaderboard = cityLeaderboard[cityHash];
        uint256 playerMarkers = playerCityMarkers[playerId][cityHash];

        // Find player position or insert position
        int256 existingIndex = -1;
        uint256 insertIndex = leaderboard.length;

        for (uint256 i = 0; i < leaderboard.length; i++) {
            if (leaderboard[i] == playerId) {
                existingIndex = int256(i);
            }
            if (insertIndex == leaderboard.length &&
                playerCityMarkers[leaderboard[i]][cityHash] < playerMarkers) {
                insertIndex = i;
            }
        }

        // Remove from old position if exists
        if (existingIndex >= 0) {
            for (uint256 i = uint256(existingIndex); i < leaderboard.length - 1; i++) {
                leaderboard[i] = leaderboard[i + 1];
            }
            leaderboard.pop();
            if (uint256(existingIndex) < insertIndex) {
                insertIndex--;
            }
        }

        // Insert at new position (max 100 entries)
        if (insertIndex < 100) {
            if (leaderboard.length < 100) {
                leaderboard.push(bytes32(0));
            }

            // Shift elements
            for (uint256 i = leaderboard.length - 1; i > insertIndex; i--) {
                leaderboard[i] = leaderboard[i - 1];
            }
            leaderboard[insertIndex] = playerId;

            emit LeaderboardUpdated(cityHash, playerId, insertIndex + 1);
        }
    }

    // ============ Utility Functions ============

    /**
     * @notice Calculate distance between two coordinates (Haversine formula simplified)
     * @return Distance in meters
     */
    function _calculateDistance(
        int32 lat1,
        int32 lon1,
        int32 lat2,
        int32 lon2
    ) internal pure returns (uint256) {
        // Simplified distance calculation (not exact Haversine but gas efficient)
        int256 dLat = int256(lat2) - int256(lat1);
        int256 dLon = int256(lon2) - int256(lon1);

        // Approximate: 1 degree ≈ 111km at equator
        // We're working with 1e6 scaled values
        uint256 latDist = uint256(dLat > 0 ? dLat : -dLat) * 111 / 1000; // meters per 1e-6 degree
        uint256 lonDist = uint256(dLon > 0 ? dLon : -dLon) * 111 / 1000; // simplified

        // Pythagorean approximation
        return _sqrt(latDist * latDist + lonDist * lonDist);
    }

    /**
     * @notice Calculate speed between two points
     * @return Speed in km/h
     */
    function _calculateSpeed(
        int32 lat1,
        int32 lon1,
        int32 lat2,
        int32 lon2,
        uint64 time1,
        uint64 time2
    ) internal pure returns (uint256) {
        if (time2 <= time1) return 0;

        uint256 distance = _calculateDistance(lat1, lon1, lat2, lon2);
        uint256 timeSeconds = time2 - time1;

        // Convert m/s to km/h: (distance / time) * 3.6
        return (distance * 36) / (timeSeconds * 10);
    }

    /**
     * @notice Integer square root (Babylonian method)
     */
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

    function addVerifier(address verifier) external onlyOwner {
        trustedVerifiers[verifier] = true;
        emit VerifierAdded(verifier);
    }

    function removeVerifier(address verifier) external onlyOwner {
        trustedVerifiers[verifier] = false;
        emit VerifierRemoved(verifier);
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    // ============ View Functions ============

    function getCityStats(bytes32 cityHash) external view returns (
        uint32 totalMarkersCount,
        uint32 totalPlayersCount,
        uint64 lastActivity
    ) {
        CityStats memory stats = cityStats[cityHash];
        return (stats.totalMarkers, stats.totalPlayers, stats.lastActivity);
    }

    function getPlayerCityMarkerCount(bytes32 playerId, bytes32 cityHash)
        external
        view
        returns (uint256)
    {
        return playerCityMarkers[playerId][cityHash];
    }

    function getTotalCityMarkers(bytes32 cityHash) external view returns (uint256) {
        return cityMarkers[cityHash].length;
    }
}
