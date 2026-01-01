// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/**
 * @title GPSStaking
 * @dev Staking contract for GPS Runner - stake to earn rewards based on activity
 * @notice Supports both native token and ERC20 staking with activity-based rewards
 */
contract GPSStaking is Ownable, ReentrancyGuard, Pausable {
    using SafeERC20 for IERC20;

    // ============ Constants ============
    uint256 public constant PRECISION = 1e18;
    uint256 public constant MIN_STAKE_AMOUNT = 0.01 ether;
    uint256 public constant MAX_STAKE_AMOUNT = 1000 ether;
    uint256 public constant UNSTAKE_COOLDOWN = 7 days;
    uint256 public constant REWARD_DURATION = 30 days;

    // ============ Structs ============

    /// @dev Stake info for each player
    struct StakeInfo {
        address owner; // Wallet that owns this stake
        uint256 stakedAmount;
        uint256 rewardDebt;
        uint256 pendingRewards;
        uint64 stakeTime;
        uint64 lastClaimTime;
        uint64 unstakeRequestTime;
        uint32 activityMultiplier; // 100 = 1x, 200 = 2x, etc.
        bool hasUnstakeRequest;
    }

    /// @dev Pool info for reward distribution
    struct PoolInfo {
        uint256 totalStaked;
        uint256 accRewardPerShare;
        uint256 rewardRate; // rewards per second
        uint64 lastRewardTime;
        uint64 endTime;
    }

    /// @dev City-specific staking pool
    struct CityPool {
        uint256 totalStaked;
        uint256 accRewardPerShare;
        uint256 bonusRate; // Extra rewards for city stakers
        uint64 lastUpdateTime;
    }

    // ============ State Variables ============

    // Main pool
    PoolInfo public pool;

    // Player stakes
    mapping(bytes32 => StakeInfo) public stakes; // playerId => StakeInfo
    mapping(bytes32 => mapping(bytes32 => uint256)) public cityStakes; // playerId => cityHash => amount

    // City pools for bonus rewards
    mapping(bytes32 => CityPool) public cityPools;

    // Reward token (address(0) for native token)
    IERC20 public rewardToken;

    // Activity tracking (from GPSRunner contract)
    address public gpsRunnerContract;

    // Activity thresholds for multiplier boosts
    uint32[] public activityThresholds; // marker counts
    uint32[] public activityMultipliers; // corresponding multipliers (100 = 1x)

    // Total rewards distributed
    uint256 public totalRewardsDistributed;

    // Treasury for rewards
    address public treasury;

    // ============ Events ============

    event Staked(bytes32 indexed playerId, uint256 amount);
    event StakedToCity(bytes32 indexed playerId, bytes32 indexed cityHash, uint256 amount);
    event UnstakeRequested(bytes32 indexed playerId, uint256 amount);
    event Unstaked(bytes32 indexed playerId, uint256 amount);
    event RewardsClaimed(bytes32 indexed playerId, uint256 amount);
    event ActivityMultiplierUpdated(bytes32 indexed playerId, uint32 newMultiplier);
    event PoolUpdated(uint256 rewardRate, uint64 endTime);
    event CityBonusUpdated(bytes32 indexed cityHash, uint256 bonusRate);

    // ============ Errors ============

    error InvalidAmount();
    error InsufficientStake();
    error CooldownNotMet();
    error NoUnstakeRequest();
    error NotAuthorized();
    error NotStakeOwner();
    error NoRewards();
    error TransferFailed();

    // ============ Constructor ============

    constructor(address _rewardToken, address _treasury) Ownable(msg.sender) {
        rewardToken = IERC20(_rewardToken);
        treasury = _treasury;

        // Default activity thresholds and multipliers
        activityThresholds = [10, 50, 100, 500, 1000];
        activityMultipliers = [100, 125, 150, 200, 300]; // 1x, 1.25x, 1.5x, 2x, 3x

        pool.lastRewardTime = uint64(block.timestamp);
    }

    // ============ Staking Functions ============

    /**
     * @notice Stake tokens to earn rewards
     * @param playerId Player identifier
     */
    function stake(bytes32 playerId) external payable nonReentrant whenNotPaused {
        if (msg.value < MIN_STAKE_AMOUNT || msg.value > MAX_STAKE_AMOUNT) {
            revert InvalidAmount();
        }

        _updatePool();

        StakeInfo storage stakeInfo = stakes[playerId];

        // First stake sets the owner, subsequent stakes must be from same owner
        if (stakeInfo.owner == address(0)) {
            stakeInfo.owner = msg.sender;
        } else if (stakeInfo.owner != msg.sender) {
            revert NotStakeOwner();
        }

        // Calculate pending rewards before updating
        if (stakeInfo.stakedAmount > 0) {
            uint256 pending = _calculatePendingRewards(playerId);
            stakeInfo.pendingRewards += pending;
        }

        // Update stake
        stakeInfo.stakedAmount += msg.value;
        stakeInfo.rewardDebt = (stakeInfo.stakedAmount * pool.accRewardPerShare) / PRECISION;
        stakeInfo.stakeTime = uint64(block.timestamp);
        stakeInfo.lastClaimTime = uint64(block.timestamp);

        if (stakeInfo.activityMultiplier == 0) {
            stakeInfo.activityMultiplier = 100; // Default 1x
        }

        pool.totalStaked += msg.value;

        emit Staked(playerId, msg.value);
    }

    /**
     * @notice Stake additional amount to a specific city pool
     * @param playerId Player identifier
     * @param cityHash City hash
     */
    function stakeToCity(bytes32 playerId, bytes32 cityHash)
        external
        payable
        nonReentrant
        whenNotPaused
    {
        if (msg.value < MIN_STAKE_AMOUNT) {
            revert InvalidAmount();
        }

        StakeInfo storage stakeInfo = stakes[playerId];
        if (stakeInfo.owner != msg.sender) {
            revert NotStakeOwner();
        }
        if (stakeInfo.stakedAmount == 0) {
            revert InsufficientStake(); // Must stake to main pool first
        }

        _updateCityPool(cityHash);

        cityStakes[playerId][cityHash] += msg.value;
        cityPools[cityHash].totalStaked += msg.value;

        emit StakedToCity(playerId, cityHash, msg.value);
    }

    /**
     * @notice Request to unstake (starts cooldown)
     * @param playerId Player identifier
     */
    function requestUnstake(bytes32 playerId) external nonReentrant {
        StakeInfo storage stakeInfo = stakes[playerId];
        if (stakeInfo.owner != msg.sender) {
            revert NotStakeOwner();
        }
        if (stakeInfo.stakedAmount == 0) {
            revert InsufficientStake();
        }

        stakeInfo.hasUnstakeRequest = true;
        stakeInfo.unstakeRequestTime = uint64(block.timestamp);

        emit UnstakeRequested(playerId, stakeInfo.stakedAmount);
    }

    /**
     * @notice Complete unstake after cooldown
     * @param playerId Player identifier
     */
    function unstake(bytes32 playerId) external nonReentrant {
        StakeInfo storage stakeInfo = stakes[playerId];

        if (stakeInfo.owner != msg.sender) {
            revert NotStakeOwner();
        }
        if (!stakeInfo.hasUnstakeRequest) {
            revert NoUnstakeRequest();
        }
        if (block.timestamp < stakeInfo.unstakeRequestTime + UNSTAKE_COOLDOWN) {
            revert CooldownNotMet();
        }

        _updatePool();

        // Claim any pending rewards first
        uint256 pending = _calculatePendingRewards(playerId) + stakeInfo.pendingRewards;
        if (pending > 0) {
            _transferRewards(msg.sender, pending);
            stakeInfo.pendingRewards = 0;
            totalRewardsDistributed += pending;
            emit RewardsClaimed(playerId, pending);
        }

        uint256 amount = stakeInfo.stakedAmount;

        // Reset stake info (keep owner for re-staking)
        stakeInfo.stakedAmount = 0;
        stakeInfo.rewardDebt = 0;
        stakeInfo.hasUnstakeRequest = false;
        stakeInfo.unstakeRequestTime = 0;

        pool.totalStaked -= amount;

        // Transfer staked amount back to owner
        (bool success, ) = stakeInfo.owner.call{value: amount}("");
        if (!success) {
            revert TransferFailed();
        }

        emit Unstaked(playerId, amount);
    }

    /**
     * @notice Claim pending rewards
     * @param playerId Player identifier
     */
    function claimRewards(bytes32 playerId) external nonReentrant {
        StakeInfo storage stakeInfo = stakes[playerId];

        if (stakeInfo.owner != msg.sender) {
            revert NotStakeOwner();
        }

        _updatePool();

        uint256 pending = _calculatePendingRewards(playerId) + stakeInfo.pendingRewards;

        if (pending == 0) {
            revert NoRewards();
        }

        stakeInfo.pendingRewards = 0;
        stakeInfo.rewardDebt = (stakeInfo.stakedAmount * pool.accRewardPerShare) / PRECISION;
        stakeInfo.lastClaimTime = uint64(block.timestamp);

        _transferRewards(stakeInfo.owner, pending);
        totalRewardsDistributed += pending;

        emit RewardsClaimed(playerId, pending);
    }

    // ============ Activity Functions ============

    /**
     * @notice Update activity multiplier based on marker count
     * @param playerId Player identifier
     * @param markerCount Current marker count from GPSRunner
     */
    function updateActivityMultiplier(bytes32 playerId, uint32 markerCount)
        external
    {
        if (msg.sender != gpsRunnerContract && msg.sender != owner()) {
            revert NotAuthorized();
        }

        uint32 newMultiplier = 100; // Default 1x

        for (uint256 i = activityThresholds.length; i > 0; i--) {
            if (markerCount >= activityThresholds[i - 1]) {
                newMultiplier = activityMultipliers[i - 1];
                break;
            }
        }

        stakes[playerId].activityMultiplier = newMultiplier;
        emit ActivityMultiplierUpdated(playerId, newMultiplier);
    }

    // ============ Internal Functions ============

    function _updatePool() internal {
        if (block.timestamp <= pool.lastRewardTime) {
            return;
        }

        if (pool.totalStaked == 0) {
            pool.lastRewardTime = uint64(block.timestamp);
            return;
        }

        uint256 timeElapsed;
        if (pool.endTime > 0 && block.timestamp > pool.endTime) {
            timeElapsed = pool.endTime - pool.lastRewardTime;
        } else {
            timeElapsed = block.timestamp - pool.lastRewardTime;
        }

        uint256 rewards = timeElapsed * pool.rewardRate;
        pool.accRewardPerShare += (rewards * PRECISION) / pool.totalStaked;
        pool.lastRewardTime = uint64(block.timestamp);
    }

    function _updateCityPool(bytes32 cityHash) internal {
        CityPool storage cityPool = cityPools[cityHash];

        if (block.timestamp <= cityPool.lastUpdateTime) {
            return;
        }

        if (cityPool.totalStaked > 0) {
            uint256 timeElapsed = block.timestamp - cityPool.lastUpdateTime;
            uint256 rewards = timeElapsed * cityPool.bonusRate;
            cityPool.accRewardPerShare += (rewards * PRECISION) / cityPool.totalStaked;
        }

        cityPool.lastUpdateTime = uint64(block.timestamp);
    }

    function _calculatePendingRewards(bytes32 playerId) internal view returns (uint256) {
        StakeInfo storage stakeInfo = stakes[playerId];

        if (stakeInfo.stakedAmount == 0) {
            return 0;
        }

        uint256 accReward = pool.accRewardPerShare;

        // Calculate updated accRewardPerShare
        if (block.timestamp > pool.lastRewardTime && pool.totalStaked > 0) {
            uint256 timeElapsed;
            if (pool.endTime > 0 && block.timestamp > pool.endTime) {
                timeElapsed = pool.endTime - pool.lastRewardTime;
            } else {
                timeElapsed = block.timestamp - pool.lastRewardTime;
            }
            uint256 rewards = timeElapsed * pool.rewardRate;
            accReward += (rewards * PRECISION) / pool.totalStaked;
        }

        uint256 baseReward = (stakeInfo.stakedAmount * accReward) / PRECISION - stakeInfo.rewardDebt;

        // Apply activity multiplier
        uint256 finalReward = (baseReward * stakeInfo.activityMultiplier) / 100;

        return finalReward;
    }

    function _transferRewards(address to, uint256 amount) internal {
        if (address(rewardToken) == address(0)) {
            // Native token rewards
            (bool success, ) = to.call{value: amount}("");
            if (!success) {
                revert TransferFailed();
            }
        } else {
            // ERC20 rewards
            rewardToken.safeTransferFrom(treasury, to, amount);
        }
    }

    // ============ View Functions ============

    /**
     * @notice Get pending rewards for a player
     */
    function pendingRewards(bytes32 playerId) external view returns (uint256) {
        return _calculatePendingRewards(playerId) + stakes[playerId].pendingRewards;
    }

    /**
     * @notice Get stake info for a player
     */
    function getStakeInfo(bytes32 playerId) external view returns (
        uint256 stakedAmount,
        uint256 pending,
        uint64 stakeTime,
        uint64 lastClaimTime,
        uint32 activityMultiplier,
        bool hasUnstakeRequest,
        uint64 unstakeAvailableAt
    ) {
        StakeInfo storage info = stakes[playerId];
        uint256 pendingAmount = _calculatePendingRewards(playerId) + info.pendingRewards;
        uint64 unstakeAt = info.hasUnstakeRequest ?
            info.unstakeRequestTime + uint64(UNSTAKE_COOLDOWN) : 0;

        return (
            info.stakedAmount,
            pendingAmount,
            info.stakeTime,
            info.lastClaimTime,
            info.activityMultiplier,
            info.hasUnstakeRequest,
            unstakeAt
        );
    }

    /**
     * @notice Get pool info
     */
    function getPoolInfo() external view returns (
        uint256 totalStaked,
        uint256 rewardRate,
        uint64 lastRewardTime,
        uint64 endTime
    ) {
        return (pool.totalStaked, pool.rewardRate, pool.lastRewardTime, pool.endTime);
    }

    // ============ Admin Functions ============

    /**
     * @notice Set reward rate and duration
     */
    function setRewardRate(uint256 _rewardRate, uint256 duration) external onlyOwner {
        _updatePool();
        pool.rewardRate = _rewardRate;
        pool.endTime = uint64(block.timestamp + duration);
        emit PoolUpdated(_rewardRate, pool.endTime);
    }

    /**
     * @notice Set city bonus rate
     */
    function setCityBonusRate(bytes32 cityHash, uint256 bonusRate) external onlyOwner {
        _updateCityPool(cityHash);
        cityPools[cityHash].bonusRate = bonusRate;
        emit CityBonusUpdated(cityHash, bonusRate);
    }

    /**
     * @notice Set GPSRunner contract address
     */
    function setGPSRunnerContract(address _gpsRunner) external onlyOwner {
        gpsRunnerContract = _gpsRunner;
    }

    /**
     * @notice Set activity thresholds and multipliers
     */
    function setActivityMultipliers(
        uint32[] calldata thresholds,
        uint32[] calldata multipliers
    ) external onlyOwner {
        require(thresholds.length == multipliers.length, "Length mismatch");
        activityThresholds = thresholds;
        activityMultipliers = multipliers;
    }

    /**
     * @notice Deposit rewards to the contract
     */
    function depositRewards() external payable onlyOwner {
        require(msg.value > 0, "Zero amount");
    }

    /**
     * @notice Emergency withdraw (owner only)
     */
    function emergencyWithdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        (bool success, ) = owner().call{value: balance}("");
        require(success, "Transfer failed");
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    // ============ Receive ============

    receive() external payable {}
}
