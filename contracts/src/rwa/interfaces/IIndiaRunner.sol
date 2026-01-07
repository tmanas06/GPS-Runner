// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

/// @title IIndiaRunner - Interface for existing IndiaRunner contract
/// @notice Interface to read player stats and marker data from IndiaRunner
interface IIndiaRunner {
    struct PlayerStats {
        uint256 totalMarkers;
        uint256 totalDistanceMeters;
        uint256 lastMarkerTime;
        uint256 lastLat1e6;
        uint256 lastLng1e6;
        bytes32 homeState;
        bytes32 homeCity;
        bool isRegistered;
    }

    /// @notice Get player statistics
    function getPlayerStats(address player) external view returns (
        uint256 markers,
        uint256 distanceMeters,
        bytes32 homeState,
        bytes32 homeCity,
        bool isRegistered
    );

    /// @notice Get total markers for a player
    function getPlayerMarkerCount(address player) external view returns (uint256);

    /// @notice Get player's marker count in a specific city
    function getPlayerCityMarkerCount(address player, bytes32 cityHash) external view returns (uint256);

    /// @notice Get city leaderboard
    function getCityLeaderboard(bytes32 cityHash, uint256 limit) external view returns (
        address[] memory players,
        uint256[] memory markerCounts
    );

    /// @notice Get global leaderboard
    function getGlobalLeaderboard(uint256 limit) external view returns (
        address[] memory players,
        uint256[] memory markerCounts,
        uint256[] memory distances
    );

    /// @notice Get marker by index
    function markers(uint256 index) external view returns (
        address player,
        uint256 lat1e6,
        uint256 lng1e6,
        bytes32 stateHash,
        bytes32 cityHash,
        string memory landmark,
        uint8 activityType,
        uint16 speedKmh,
        uint16 stepsPerMin,
        uint256 timestamp
    );

    /// @notice Get total number of markers
    function getTotalMarkers() external view returns (uint256);

    /// @notice Get total player count
    function totalPlayersCount() external view returns (uint256);
}
