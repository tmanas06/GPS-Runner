// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

/// @title IMarkerStaking - Interface for Marker Staking Pool contract
/// @notice Stake markers to earn yield from new runners and seasonal pools
interface IMarkerStaking {
    /// @notice Staked marker data
    struct StakedMarker {
        address owner;
        bytes32 landmarkHash;
        bytes32 cityHash;
        uint256 stakedAt;
        uint256 accumulatedYield;
        uint256 lastClaimTime;
    }

    /// @notice Emitted when marker is staked
    event MarkerStaked(
        address indexed owner,
        uint256 indexed markerId,
        bytes32 landmarkHash
    );

    /// @notice Emitted when marker is unstaked
    event MarkerUnstaked(
        address indexed owner,
        uint256 indexed markerId
    );

    /// @notice Emitted when fee is collected from new runner
    event FeeCollected(
        uint256 indexed markerId,
        address indexed newRunner,
        uint256 feeAmount
    );

    /// @notice Emitted when yield is claimed
    event YieldClaimed(
        address indexed owner,
        uint256 amount
    );

    /// @notice Stake a marker to earn yield
    /// @param markerId The marker index from IndiaRunner
    function stakeMarker(uint256 markerId) external;

    /// @notice Unstake a marker
    /// @param markerId The marker to unstake
    function unstakeMarker(uint256 markerId) external;

    /// @notice Claim all accumulated staking yield
    /// @return Total claimed amount
    function claimStakingYield() external returns (uint256);

    /// @notice Record fee from new runner hitting a landmark
    /// @param landmarkHash The landmark hash
    /// @param feeAmount The fee amount to distribute
    function recordNewRunnerFee(bytes32 landmarkHash, uint256 feeAmount) external;

    /// @notice Get pending yield for a staker
    /// @param staker The staker address
    /// @return Pending yield amount
    function getPendingYield(address staker) external view returns (uint256);

    /// @notice Get leaderboard multiplier for a player
    /// @param player The player address
    /// @return Multiplier in basis points (100 = 1x, 200 = 2x)
    function getLeaderboardMultiplier(address player) external view returns (uint256);
}
