// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title GPSToken
 * @dev Reward token for GPS Runner game
 * @notice ERC20 token with minting, burning, and permit functionality
 */
contract GPSToken is ERC20, ERC20Burnable, ERC20Permit, Ownable {
    // ============ Constants ============
    uint256 public constant MAX_SUPPLY = 1_000_000_000 * 1e18; // 1 billion tokens
    uint256 public constant INITIAL_SUPPLY = 100_000_000 * 1e18; // 100 million initial

    // ============ State Variables ============

    // Minters (staking contract, game contract)
    mapping(address => bool) public minters;

    // Mint limits per minter
    mapping(address => uint256) public minterLimits;
    mapping(address => uint256) public minterMinted;

    // Total minted by minters (excluding initial supply)
    uint256 public totalMinterMinted;

    // ============ Events ============

    event MinterAdded(address indexed minter, uint256 limit);
    event MinterRemoved(address indexed minter);
    event MinterLimitUpdated(address indexed minter, uint256 newLimit);

    // ============ Errors ============

    error NotMinter();
    error ExceedsMinterLimit();
    error ExceedsMaxSupply();
    error ZeroAddress();

    // ============ Constructor ============

    constructor(address initialHolder)
        ERC20("GPS Runner Token", "GPSR")
        ERC20Permit("GPS Runner Token")
        Ownable(msg.sender)
    {
        if (initialHolder == address(0)) revert ZeroAddress();
        _mint(initialHolder, INITIAL_SUPPLY);
    }

    // ============ Minting Functions ============

    /**
     * @notice Mint tokens (only for authorized minters)
     * @param to Recipient address
     * @param amount Amount to mint
     */
    function mint(address to, uint256 amount) external {
        if (!minters[msg.sender]) revert NotMinter();
        if (minterMinted[msg.sender] + amount > minterLimits[msg.sender]) {
            revert ExceedsMinterLimit();
        }
        if (totalSupply() + amount > MAX_SUPPLY) {
            revert ExceedsMaxSupply();
        }

        minterMinted[msg.sender] += amount;
        totalMinterMinted += amount;
        _mint(to, amount);
    }

    /**
     * @notice Mint tokens as reward (convenience function)
     * @param to Recipient address
     * @param amount Amount to mint
     */
    function mintReward(address to, uint256 amount) external {
        if (!minters[msg.sender]) revert NotMinter();
        if (minterMinted[msg.sender] + amount > minterLimits[msg.sender]) {
            revert ExceedsMinterLimit();
        }
        if (totalSupply() + amount > MAX_SUPPLY) {
            revert ExceedsMaxSupply();
        }

        minterMinted[msg.sender] += amount;
        totalMinterMinted += amount;
        _mint(to, amount);
    }

    // ============ Admin Functions ============

    /**
     * @notice Add a minter with limit
     * @param minter Address to add as minter
     * @param limit Maximum amount this minter can mint
     */
    function addMinter(address minter, uint256 limit) external onlyOwner {
        if (minter == address(0)) revert ZeroAddress();
        minters[minter] = true;
        minterLimits[minter] = limit;
        emit MinterAdded(minter, limit);
    }

    /**
     * @notice Remove a minter
     * @param minter Address to remove
     */
    function removeMinter(address minter) external onlyOwner {
        minters[minter] = false;
        emit MinterRemoved(minter);
    }

    /**
     * @notice Update minter limit
     * @param minter Minter address
     * @param newLimit New limit
     */
    function updateMinterLimit(address minter, uint256 newLimit) external onlyOwner {
        minterLimits[minter] = newLimit;
        emit MinterLimitUpdated(minter, newLimit);
    }

    /**
     * @notice Owner mint (for treasury, partnerships, etc.)
     * @param to Recipient
     * @param amount Amount
     */
    function ownerMint(address to, uint256 amount) external onlyOwner {
        if (totalSupply() + amount > MAX_SUPPLY) {
            revert ExceedsMaxSupply();
        }
        _mint(to, amount);
    }

    // ============ View Functions ============

    /**
     * @notice Get minter info
     */
    function getMinterInfo(address minter) external view returns (
        bool isMinter,
        uint256 limit,
        uint256 minted,
        uint256 remaining
    ) {
        return (
            minters[minter],
            minterLimits[minter],
            minterMinted[minter],
            minterLimits[minter] > minterMinted[minter] ?
                minterLimits[minter] - minterMinted[minter] : 0
        );
    }

    /**
     * @notice Get remaining mintable supply
     */
    function remainingMintableSupply() external view returns (uint256) {
        return MAX_SUPPLY - totalSupply();
    }
}
