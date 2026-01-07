// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "./interfaces/IIndiaRunner.sol";
import "./interfaces/IMarkerStaking.sol";

/// @title MarkerStakingPool - Stake GPS Markers for Yield
/// @notice Stake markers to earn yield from new runners and seasonal pools
/// @dev Leaderboard multipliers reward top players with higher APY
contract MarkerStakingPool is Ownable, ReentrancyGuard, Pausable, IMarkerStaking {
    // ============ Constants ============
    uint256 public constant PRECISION = 1e18;
    uint256 public constant NEW_RUNNER_FEE_PERCENT = 5; // 5% fee from new runners
    uint256 public constant BASE_APY_BPS = 800; // 8% base APY (basis points)
    uint256 public constant LEADERBOARD_TOP_10_MULTIPLIER = 200; // 2x for top 10
    uint256 public constant LEADERBOARD_TOP_50_MULTIPLIER = 150; // 1.5x for top 50
    uint256 public constant SEASON_DURATION = 90 days;
    uint256 public constant UNSTAKE_COOLDOWN = 7 days;

    // ============ State ============
    IIndiaRunner public immutable indiaRunner;

    // Staked markers
    mapping(uint256 => StakedMarker) public stakedMarkers;
    mapping(address => uint256[]) public userStakedMarkers;
    mapping(bytes32 => uint256[]) public landmarkStakedMarkers; // landmarkHash => markerIds

    // Yield pool
    uint256 public totalYieldPool;
    uint256 public accYieldPerStake;
    uint256 public totalStakedMarkers;

    // User yield tracking
    mapping(address => uint256) public userYieldDebt;
    mapping(address => uint256) public userPendingYield;
    mapping(address => uint256) public userTotalStaked;

    // Season tracking
    uint256 public currentSeason;
    uint256 public seasonStartTime;
    mapping(uint256 => uint256) public seasonPools; // season => pool amount
    mapping(uint256 => bool) public seasonDistributed;

    // Leaderboard cache (updated by backend)
    mapping(address => uint256) public leaderboardRank; // 0 = not ranked
    uint256 public lastLeaderboardUpdate;

    // Authorized callers
    mapping(address => bool) public authorizedCallers;

    // City-specific pools
    mapping(bytes32 => uint256) public cityPools; // cityHash => pool balance
    mapping(bytes32 => uint256) public cityAccYieldPerStake;
    mapping(bytes32 => uint256) public cityTotalStaked;
    mapping(address => mapping(bytes32 => uint256)) public userCityStaked;
    mapping(address => mapping(bytes32 => uint256)) public userCityYieldDebt;

    // ============ Events ============
    event SeasonPoolDeposited(uint256 indexed season, uint256 amount);
    event SeasonDistributed(uint256 indexed season, uint256 amount, uint256 stakerCount);
    event LeaderboardUpdated(uint256 timestamp, uint256 playerCount);
    event CityPoolDeposited(bytes32 indexed cityHash, uint256 amount);

    // ============ Constructor ============
    constructor(address _indiaRunner) Ownable(msg.sender) {
        indiaRunner = IIndiaRunner(_indiaRunner);
        seasonStartTime = block.timestamp;
        currentSeason = 1;
    }

    // ============ Staking ============

    /// @inheritdoc IMarkerStaking
    function stakeMarker(uint256 markerId) external override nonReentrant whenNotPaused {
        // Verify ownership through IndiaRunner
        (address player, , , ,
         bytes32 cityHash,
         string memory landmark,
         , , , ) = indiaRunner.markers(markerId);

        require(player == msg.sender, "Not marker owner");
        require(stakedMarkers[markerId].owner == address(0), "Already staked");
        require(bytes(landmark).length > 0, "Not a landmark marker");

        _updateYield(msg.sender);

        bytes32 landmarkHash = keccak256(abi.encodePacked(landmark));

        stakedMarkers[markerId] = StakedMarker({
            owner: msg.sender,
            landmarkHash: landmarkHash,
            cityHash: cityHash,
            stakedAt: block.timestamp,
            accumulatedYield: 0,
            lastClaimTime: block.timestamp
        });

        userStakedMarkers[msg.sender].push(markerId);
        landmarkStakedMarkers[landmarkHash].push(markerId);
        totalStakedMarkers++;
        userTotalStaked[msg.sender]++;

        // Track city-level staking
        cityTotalStaked[cityHash]++;
        userCityStaked[msg.sender][cityHash]++;
        _updateCityYield(msg.sender, cityHash);

        emit MarkerStaked(msg.sender, markerId, landmarkHash);
    }

    /// @notice Batch stake multiple markers
    function batchStakeMarkers(uint256[] calldata markerIds) external nonReentrant whenNotPaused {
        _updateYield(msg.sender);

        for (uint256 i = 0; i < markerIds.length; i++) {
            uint256 markerId = markerIds[i];

            (address player, , , ,
             bytes32 cityHash,
             string memory landmark,
             , , , ) = indiaRunner.markers(markerId);

            require(player == msg.sender, "Not marker owner");
            require(stakedMarkers[markerId].owner == address(0), "Already staked");

            if (bytes(landmark).length > 0) {
                bytes32 landmarkHash = keccak256(abi.encodePacked(landmark));

                stakedMarkers[markerId] = StakedMarker({
                    owner: msg.sender,
                    landmarkHash: landmarkHash,
                    cityHash: cityHash,
                    stakedAt: block.timestamp,
                    accumulatedYield: 0,
                    lastClaimTime: block.timestamp
                });

                userStakedMarkers[msg.sender].push(markerId);
                landmarkStakedMarkers[landmarkHash].push(markerId);
                totalStakedMarkers++;
                userTotalStaked[msg.sender]++;

                cityTotalStaked[cityHash]++;
                userCityStaked[msg.sender][cityHash]++;

                emit MarkerStaked(msg.sender, markerId, landmarkHash);
            }
        }

        userYieldDebt[msg.sender] = (userTotalStaked[msg.sender] * accYieldPerStake) / PRECISION;
    }

    /// @inheritdoc IMarkerStaking
    function unstakeMarker(uint256 markerId) external override nonReentrant {
        StakedMarker storage marker = stakedMarkers[markerId];
        require(marker.owner == msg.sender, "Not stake owner");
        require(
            block.timestamp >= marker.stakedAt + UNSTAKE_COOLDOWN,
            "Cooldown not met"
        );

        _updateYield(msg.sender);

        // Add accumulated yield to user's pending
        userPendingYield[msg.sender] += marker.accumulatedYield;

        // Update city tracking
        bytes32 cityHash = marker.cityHash;
        _updateCityYield(msg.sender, cityHash);
        cityTotalStaked[cityHash]--;
        userCityStaked[msg.sender][cityHash]--;

        // Remove from arrays
        _removeFromArray(userStakedMarkers[msg.sender], markerId);
        _removeFromArray(landmarkStakedMarkers[marker.landmarkHash], markerId);

        totalStakedMarkers--;
        userTotalStaked[msg.sender]--;

        userYieldDebt[msg.sender] = (userTotalStaked[msg.sender] * accYieldPerStake) / PRECISION;

        emit MarkerUnstaked(msg.sender, markerId);

        delete stakedMarkers[markerId];
    }

    // ============ Fee Collection ============

    /// @inheritdoc IMarkerStaking
    function recordNewRunnerFee(
        bytes32 landmarkHash,
        uint256 feeAmount
    ) external override {
        require(authorizedCallers[msg.sender], "Not authorized");

        uint256[] storage stakedAtLandmark = landmarkStakedMarkers[landmarkHash];
        if (stakedAtLandmark.length == 0) return;

        // Distribute fee to all stakers at this landmark
        uint256 feePerStaker = feeAmount / stakedAtLandmark.length;

        for (uint256 i = 0; i < stakedAtLandmark.length; i++) {
            StakedMarker storage marker = stakedMarkers[stakedAtLandmark[i]];
            marker.accumulatedYield += feePerStaker;

            emit FeeCollected(stakedAtLandmark[i], msg.sender, feePerStaker);
        }
    }

    /// @notice Record fees for multiple landmarks
    function batchRecordNewRunnerFees(
        bytes32[] calldata landmarkHashes,
        uint256[] calldata feeAmounts
    ) external {
        require(authorizedCallers[msg.sender], "Not authorized");
        require(landmarkHashes.length == feeAmounts.length, "Length mismatch");

        for (uint256 i = 0; i < landmarkHashes.length; i++) {
            uint256[] storage stakedAtLandmark = landmarkStakedMarkers[landmarkHashes[i]];
            if (stakedAtLandmark.length > 0) {
                uint256 feePerStaker = feeAmounts[i] / stakedAtLandmark.length;
                for (uint256 j = 0; j < stakedAtLandmark.length; j++) {
                    stakedMarkers[stakedAtLandmark[j]].accumulatedYield += feePerStaker;
                }
            }
        }
    }

    // ============ Yield ============

    /// @inheritdoc IMarkerStaking
    function claimStakingYield() external override nonReentrant returns (uint256) {
        _updateYield(msg.sender);

        uint256 amount = userPendingYield[msg.sender];

        // Add accumulated yield from individual markers
        uint256[] storage markers = userStakedMarkers[msg.sender];
        for (uint256 i = 0; i < markers.length; i++) {
            amount += stakedMarkers[markers[i]].accumulatedYield;
            stakedMarkers[markers[i]].accumulatedYield = 0;
            stakedMarkers[markers[i]].lastClaimTime = block.timestamp;
        }

        require(amount > 0, "No yield");

        userPendingYield[msg.sender] = 0;

        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");

        emit YieldClaimed(msg.sender, amount);
        return amount;
    }

    /// @inheritdoc IMarkerStaking
    function getPendingYield(address staker) external view override returns (uint256) {
        uint256 pending = userPendingYield[staker];

        if (userTotalStaked[staker] > 0 && totalStakedMarkers > 0) {
            uint256 multiplier = getLeaderboardMultiplier(staker);
            uint256 baseYield = (userTotalStaked[staker] * accYieldPerStake) / PRECISION;
            pending += (baseYield * multiplier) / 100 - userYieldDebt[staker];
        }

        // Add individual marker yields
        uint256[] storage markers = userStakedMarkers[staker];
        for (uint256 i = 0; i < markers.length; i++) {
            pending += stakedMarkers[markers[i]].accumulatedYield;
        }

        return pending;
    }

    /// @inheritdoc IMarkerStaking
    function getLeaderboardMultiplier(address player) public view override returns (uint256) {
        uint256 rank = leaderboardRank[player];
        if (rank == 0) return 100; // Not ranked = 1x
        if (rank <= 10) return LEADERBOARD_TOP_10_MULTIPLIER; // 2x
        if (rank <= 50) return LEADERBOARD_TOP_50_MULTIPLIER; // 1.5x
        return 100; // 1x
    }

    // ============ Internal ============

    function _updateYield(address user) internal {
        if (userTotalStaked[user] > 0 && totalStakedMarkers > 0) {
            uint256 multiplier = getLeaderboardMultiplier(user);
            uint256 baseYield = (userTotalStaked[user] * accYieldPerStake) / PRECISION;
            uint256 pending = (baseYield * multiplier) / 100 - userYieldDebt[user];
            userPendingYield[user] += pending;
        }
        userYieldDebt[user] = (userTotalStaked[user] * accYieldPerStake) / PRECISION;
    }

    function _updateCityYield(address user, bytes32 cityHash) internal {
        if (userCityStaked[user][cityHash] > 0 && cityTotalStaked[cityHash] > 0) {
            uint256 pending = (userCityStaked[user][cityHash] * cityAccYieldPerStake[cityHash]) / PRECISION
                              - userCityYieldDebt[user][cityHash];
            userPendingYield[user] += pending;
        }
        userCityYieldDebt[user][cityHash] = (userCityStaked[user][cityHash] * cityAccYieldPerStake[cityHash]) / PRECISION;
    }

    function _removeFromArray(uint256[] storage arr, uint256 value) internal {
        for (uint256 i = 0; i < arr.length; i++) {
            if (arr[i] == value) {
                arr[i] = arr[arr.length - 1];
                arr.pop();
                break;
            }
        }
    }

    // ============ Season Management ============

    /// @notice Distribute season pool to stakers
    function distributeSeasonPool() external {
        require(block.timestamp >= seasonStartTime + SEASON_DURATION, "Season not ended");
        require(!seasonDistributed[currentSeason], "Already distributed");

        uint256 poolAmount = seasonPools[currentSeason];

        if (totalStakedMarkers > 0 && poolAmount > 0) {
            accYieldPerStake += (poolAmount * PRECISION) / totalStakedMarkers;
            seasonDistributed[currentSeason] = true;

            emit SeasonDistributed(currentSeason, poolAmount, totalStakedMarkers);
        }

        currentSeason++;
        seasonStartTime = block.timestamp;
    }

    /// @notice Deposit to current season pool
    function depositToSeasonPool() external payable {
        require(msg.value > 0, "Zero deposit");
        seasonPools[currentSeason] += msg.value;
        totalYieldPool += msg.value;

        emit SeasonPoolDeposited(currentSeason, msg.value);
    }

    /// @notice Deposit to city-specific pool
    function depositToCityPool(bytes32 cityHash) external payable {
        require(msg.value > 0, "Zero deposit");
        cityPools[cityHash] += msg.value;

        if (cityTotalStaked[cityHash] > 0) {
            cityAccYieldPerStake[cityHash] += (msg.value * PRECISION) / cityTotalStaked[cityHash];
        }

        emit CityPoolDeposited(cityHash, msg.value);
    }

    // ============ View Functions ============

    /// @notice Get user's staked marker IDs
    function getUserStakedMarkers(address user) external view returns (uint256[] memory) {
        return userStakedMarkers[user];
    }

    /// @notice Get staked marker count at a landmark
    function getLandmarkStakedCount(bytes32 landmarkHash) external view returns (uint256) {
        return landmarkStakedMarkers[landmarkHash].length;
    }

    /// @notice Get staking info for a user
    function getStakingInfo(address user) external view returns (
        uint256 stakedCount,
        uint256 pendingYield,
        uint256 multiplier,
        uint256 rank
    ) {
        stakedCount = userTotalStaked[user];
        pendingYield = this.getPendingYield(user);
        multiplier = getLeaderboardMultiplier(user);
        rank = leaderboardRank[user];
    }

    /// @notice Get season info
    function getSeasonInfo() external view returns (
        uint256 season,
        uint256 startTime,
        uint256 poolAmount,
        uint256 timeRemaining,
        bool distributed
    ) {
        season = currentSeason;
        startTime = seasonStartTime;
        poolAmount = seasonPools[currentSeason];
        distributed = seasonDistributed[currentSeason];

        uint256 endTime = seasonStartTime + SEASON_DURATION;
        timeRemaining = block.timestamp < endTime ? endTime - block.timestamp : 0;
    }

    /// @notice Calculate estimated APY for a user
    function getEstimatedAPY(address user) external view returns (uint256) {
        uint256 multiplier = getLeaderboardMultiplier(user);
        return (BASE_APY_BPS * multiplier) / 100; // Returns APY in basis points
    }

    // ============ Admin ============

    function updateLeaderboardRank(address player, uint256 rank) external {
        require(authorizedCallers[msg.sender] || msg.sender == owner(), "Not authorized");
        leaderboardRank[player] = rank;
    }

    function batchUpdateLeaderboard(
        address[] calldata players,
        uint256[] calldata ranks
    ) external {
        require(authorizedCallers[msg.sender] || msg.sender == owner(), "Not authorized");
        require(players.length == ranks.length, "Length mismatch");

        for (uint256 i = 0; i < players.length; i++) {
            leaderboardRank[players[i]] = ranks[i];
        }

        lastLeaderboardUpdate = block.timestamp;
        emit LeaderboardUpdated(block.timestamp, players.length);
    }

    function setAuthorizedCaller(address caller, bool authorized) external onlyOwner {
        authorizedCallers[caller] = authorized;
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    /// @notice Emergency withdraw for owner
    function emergencyWithdraw() external onlyOwner {
        (bool success, ) = owner().call{value: address(this).balance}("");
        require(success, "Transfer failed");
    }

    receive() external payable {
        seasonPools[currentSeason] += msg.value;
        totalYieldPool += msg.value;
        emit SeasonPoolDeposited(currentSeason, msg.value);
    }
}
