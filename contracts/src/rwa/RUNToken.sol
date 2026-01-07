// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "./interfaces/IRUNToken.sol";

/// @title RUNToken - Governance and Utility Token for GPS Runner Game
/// @notice ERC-20 token with boost mechanism, fee processing, and voting
/// @dev Anti-ponzi: boost burns tokens, 80% fees to buyback/burn
contract RUNToken is ERC20, ERC20Burnable, ERC20Permit, ERC20Votes, Ownable, ReentrancyGuard, IRUNToken {
    // ============ Constants ============
    uint256 public constant MAX_SUPPLY = 1_000_000_000 * 1e18; // 1B tokens
    uint256 public constant INITIAL_SUPPLY = 100_000_000 * 1e18; // 100M initial

    uint256 public constant BOOST_10_PERCENT_MULTIPLIER = 120; // 1.2x
    uint256 public constant BOOST_DURATION = 24 hours;
    uint256 public constant BOOST_COST_PERCENT = 10; // 10% of holdings

    uint256 public constant BUYBACK_PERCENT = 80; // 80% of fees
    uint256 public constant YIELD_POOL_PERCENT = 20; // 20% of fees

    // ============ State ============
    // Boost tracking
    struct Boost {
        uint256 multiplier;
        uint256 expiresAt;
    }
    mapping(address => Boost) public activeBoosts;

    // Fee distribution
    uint256 public totalFeesCollected;
    uint256 public totalBurned;
    uint256 public yieldPoolBalance;

    // Authorized contracts
    mapping(address => bool) public authorizedMinters;
    mapping(address => uint256) public minterLimits;
    mapping(address => uint256) public minterMinted;

    // DEX for buyback (for mainnet - mock for testnet)
    address public dexRouter;

    // Staking for LP yield
    mapping(address => uint256) public stakedRUN;
    uint256 public totalStakedRUN;
    uint256 public accLPYieldPerStake;
    uint256 public constant LP_PRECISION = 1e18;
    mapping(address => uint256) public userLPYieldDebt;
    mapping(address => uint256) public userPendingLPYield;

    // ============ Events ============
    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);
    event LPYieldClaimed(address indexed user, uint256 amount);
    event MinterSet(address indexed minter, uint256 limit);
    event MinterRemoved(address indexed minter);

    // ============ Constructor ============
    constructor(address initialHolder)
        ERC20("RUN Token", "RUN")
        ERC20Permit("RUN Token")
        Ownable(msg.sender)
    {
        _mint(initialHolder, INITIAL_SUPPLY);
    }

    // ============ Boost System ============

    /// @inheritdoc IRUNToken
    function activateBoost(uint256 runAmount) external override nonReentrant {
        require(balanceOf(msg.sender) >= runAmount, "Insufficient balance");

        // Require 10% of holdings minimum
        uint256 minRequired = (balanceOf(msg.sender) * BOOST_COST_PERCENT) / 100;
        require(runAmount >= minRequired, "Must stake at least 10% of holdings");

        // Burn the tokens (anti-ponzi mechanism)
        _burn(msg.sender, runAmount);
        totalBurned += runAmount;

        activeBoosts[msg.sender] = Boost({
            multiplier: BOOST_10_PERCENT_MULTIPLIER,
            expiresAt: block.timestamp + BOOST_DURATION
        });

        emit BoostActivated(msg.sender, runAmount, BOOST_10_PERCENT_MULTIPLIER, block.timestamp + BOOST_DURATION);
    }

    /// @inheritdoc IRUNToken
    function getActiveBoost(address player) external view override returns (uint256 multiplier, uint256 expiresAt) {
        Boost memory boost = activeBoosts[player];
        if (boost.expiresAt > block.timestamp) {
            return (boost.multiplier, boost.expiresAt);
        }
        return (100, 0); // No active boost = 1x
    }

    /// @notice Check if player has active boost
    function hasActiveBoost(address player) external view returns (bool) {
        return activeBoosts[player].expiresAt > block.timestamp;
    }

    // ============ Fee Distribution ============

    /// @notice Process fees with 80/20 split (buyback/burn vs yield pool)
    function processFees() external payable nonReentrant {
        require(msg.value > 0, "No fees");

        totalFeesCollected += msg.value;

        // 80% buyback and burn
        uint256 buybackAmount = (msg.value * BUYBACK_PERCENT) / 100;

        // 20% to yield pool
        uint256 yieldAmount = msg.value - buybackAmount;
        yieldPoolBalance += yieldAmount;

        // Distribute yield to stakers
        if (totalStakedRUN > 0) {
            accLPYieldPerStake += (yieldAmount * LP_PRECISION) / totalStakedRUN;
        }

        // Execute buyback (simplified for testnet)
        if (buybackAmount > 0) {
            _executeBuyback(buybackAmount);
        }

        emit YieldPoolDeposit(yieldAmount);
    }

    /// @inheritdoc IRUNToken
    function executeBuybackBurn(uint256 ethAmount) external override onlyOwner {
        require(address(this).balance >= ethAmount, "Insufficient balance");
        _executeBuyback(ethAmount);
    }

    function _executeBuyback(uint256 ethAmount) internal {
        // In production, this would swap ETH for RUN on DEX and burn
        // For testnet, we just track the amount and emit event
        // The actual buyback would use a DEX like Uniswap/SushiSwap

        if (dexRouter != address(0)) {
            // Production: Call DEX router to swap ETH -> RUN and burn
            // IUniswapV2Router(dexRouter).swapExactETHForTokens{value: ethAmount}(...)
            // _burn(address(this), purchasedAmount);
        }

        emit BuybackBurn(ethAmount, 0); // 0 for testnet, actual amount in production
    }

    /// @inheritdoc IRUNToken
    function depositToYieldPool() external payable override {
        require(msg.value > 0, "Zero deposit");
        yieldPoolBalance += msg.value;

        if (totalStakedRUN > 0) {
            accLPYieldPerStake += (msg.value * LP_PRECISION) / totalStakedRUN;
        }

        emit YieldPoolDeposit(msg.value);
    }

    // ============ RUN Staking for LP Yield ============

    /// @notice Stake RUN tokens to earn LP yield from game fees
    function stakeRUN(uint256 amount) external nonReentrant {
        require(amount > 0, "Zero amount");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");

        _updateLPYield(msg.sender);

        _transfer(msg.sender, address(this), amount);
        stakedRUN[msg.sender] += amount;
        totalStakedRUN += amount;

        userLPYieldDebt[msg.sender] = (stakedRUN[msg.sender] * accLPYieldPerStake) / LP_PRECISION;

        emit Staked(msg.sender, amount);
    }

    /// @notice Unstake RUN tokens
    function unstakeRUN(uint256 amount) external nonReentrant {
        require(amount > 0, "Zero amount");
        require(stakedRUN[msg.sender] >= amount, "Insufficient staked");

        _updateLPYield(msg.sender);

        stakedRUN[msg.sender] -= amount;
        totalStakedRUN -= amount;
        _transfer(address(this), msg.sender, amount);

        userLPYieldDebt[msg.sender] = (stakedRUN[msg.sender] * accLPYieldPerStake) / LP_PRECISION;

        emit Unstaked(msg.sender, amount);
    }

    /// @notice Claim LP yield from staked RUN
    function claimLPYield() external nonReentrant returns (uint256) {
        _updateLPYield(msg.sender);

        uint256 amount = userPendingLPYield[msg.sender];
        require(amount > 0, "No yield");

        userPendingLPYield[msg.sender] = 0;

        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");

        emit LPYieldClaimed(msg.sender, amount);
        return amount;
    }

    /// @notice Get pending LP yield for a user
    function getPendingLPYield(address user) external view returns (uint256) {
        uint256 pending = userPendingLPYield[user];

        if (stakedRUN[user] > 0) {
            pending += (stakedRUN[user] * accLPYieldPerStake) / LP_PRECISION - userLPYieldDebt[user];
        }

        return pending;
    }

    function _updateLPYield(address user) internal {
        if (stakedRUN[user] > 0) {
            uint256 pending = (stakedRUN[user] * accLPYieldPerStake) / LP_PRECISION - userLPYieldDebt[user];
            userPendingLPYield[user] += pending;
        }
        userLPYieldDebt[user] = (stakedRUN[user] * accLPYieldPerStake) / LP_PRECISION;
    }

    // ============ Minting ============

    /// @notice Mint new tokens (only authorized minters)
    function mint(address to, uint256 amount) external {
        require(authorizedMinters[msg.sender], "Not authorized");
        require(minterMinted[msg.sender] + amount <= minterLimits[msg.sender], "Exceeds limit");
        require(totalSupply() + amount <= MAX_SUPPLY, "Exceeds max supply");

        minterMinted[msg.sender] += amount;
        _mint(to, amount);
    }

    // ============ View Functions ============

    /// @notice Get token info
    function getTokenInfo() external view returns (
        uint256 supply,
        uint256 maxSupply,
        uint256 burned,
        uint256 yieldPool,
        uint256 feesCollected
    ) {
        return (
            totalSupply(),
            MAX_SUPPLY,
            totalBurned,
            yieldPoolBalance,
            totalFeesCollected
        );
    }

    /// @notice Get staking info for a user
    function getStakingInfo(address user) external view returns (
        uint256 staked,
        uint256 pendingYield,
        uint256 totalStaked
    ) {
        staked = stakedRUN[user];
        pendingYield = this.getPendingLPYield(user);
        totalStaked = totalStakedRUN;
    }

    // ============ Admin ============

    function setMinter(address minter, uint256 limit) external onlyOwner {
        authorizedMinters[minter] = true;
        minterLimits[minter] = limit;
        emit MinterSet(minter, limit);
    }

    function removeMinter(address minter) external onlyOwner {
        authorizedMinters[minter] = false;
        emit MinterRemoved(minter);
    }

    function setDexRouter(address _dexRouter) external onlyOwner {
        dexRouter = _dexRouter;
    }

    /// @notice Withdraw from yield pool (for distribution)
    function withdrawYieldPool(address recipient, uint256 amount) external onlyOwner {
        require(amount <= yieldPoolBalance, "Insufficient pool");
        yieldPoolBalance -= amount;
        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Transfer failed");
    }

    // ============ Overrides ============

    function _update(address from, address to, uint256 value)
        internal
        override(ERC20, ERC20Votes)
    {
        super._update(from, to, value);
    }

    function nonces(address owner)
        public
        view
        override(ERC20Permit, Nonces)
        returns (uint256)
    {
        return super.nonces(owner);
    }

    receive() external payable {
        // Auto-process as fees
        if (msg.value > 0) {
            totalFeesCollected += msg.value;
            uint256 yieldAmount = (msg.value * YIELD_POOL_PERCENT) / 100;
            yieldPoolBalance += yieldAmount;

            if (totalStakedRUN > 0) {
                accLPYieldPerStake += (yieldAmount * LP_PRECISION) / totalStakedRUN;
            }
        }
    }
}
