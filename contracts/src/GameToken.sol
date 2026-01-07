// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

/// @title GameToken - Collectible Token for GPS Runner Game
/// @notice ERC-20 token that users earn by collecting coins while walking
/// @dev Deploy as gMNT (Mantle), gPOL (Polygon), or gBNB (BNB Chain)
contract GameToken is ERC20, ERC20Burnable, Ownable, ReentrancyGuard {
    using ECDSA for bytes32;
    using MessageHashUtils for bytes32;

    // ============ Constants ============
    uint256 public constant MAX_SUPPLY = 1_000_000_000 * 1e18; // 1B tokens max
    uint256 public constant MAX_CLAIM_PER_TX = 10_000 * 1e18; // 10k max per claim
    uint256 public constant CLAIM_COOLDOWN = 1 hours;

    // ============ State ============
    // Claim tracking
    mapping(address => uint256) public lastClaimTime;
    mapping(address => uint256) public totalClaimed;
    mapping(bytes32 => bool) public usedSignatures;

    // Authorized signers (backend servers)
    mapping(address => bool) public authorizedSigners;

    // Stats
    uint256 public totalClaimedGlobal;
    uint256 public totalClaimCount;

    // Paused state
    bool public claimsPaused;

    // ============ Events ============
    event TokensClaimed(
        address indexed player,
        uint256 amount,
        uint256 timestamp,
        bytes32 claimId
    );
    event SignerAdded(address indexed signer);
    event SignerRemoved(address indexed signer);
    event ClaimsPausedChanged(bool paused);

    // ============ Errors ============
    error InvalidSignature();
    error SignatureAlreadyUsed();
    error ClaimCooldownActive();
    error ExceedsMaxClaimAmount();
    error ExceedsMaxSupply();
    error ClaimsPaused();
    error InvalidAmount();

    // ============ Constructor ============
    constructor(
        string memory name_,
        string memory symbol_,
        address initialSigner
    ) ERC20(name_, symbol_) Ownable(msg.sender) {
        if (initialSigner != address(0)) {
            authorizedSigners[initialSigner] = true;
            emit SignerAdded(initialSigner);
        }
    }

    // ============ Claim System ============

    /// @notice Claim collected tokens with a signed message from the backend
    /// @param amount Amount of tokens to claim (in wei)
    /// @param claimId Unique identifier for this claim
    /// @param expiry Timestamp when the signature expires
    /// @param signature Backend signature authorizing the claim
    function claimTokens(
        uint256 amount,
        bytes32 claimId,
        uint256 expiry,
        bytes calldata signature
    ) external nonReentrant {
        if (claimsPaused) revert ClaimsPaused();
        if (amount == 0) revert InvalidAmount();
        if (amount > MAX_CLAIM_PER_TX) revert ExceedsMaxClaimAmount();
        if (totalSupply() + amount > MAX_SUPPLY) revert ExceedsMaxSupply();
        if (block.timestamp > expiry) revert InvalidSignature();
        if (usedSignatures[claimId]) revert SignatureAlreadyUsed();

        // Verify cooldown
        if (block.timestamp < lastClaimTime[msg.sender] + CLAIM_COOLDOWN) {
            revert ClaimCooldownActive();
        }

        // Verify signature
        bytes32 messageHash = keccak256(
            abi.encodePacked(
                msg.sender,
                amount,
                claimId,
                expiry,
                block.chainid,
                address(this)
            )
        );
        bytes32 ethSignedHash = messageHash.toEthSignedMessageHash();
        address signer = ethSignedHash.recover(signature);

        if (!authorizedSigners[signer]) revert InvalidSignature();

        // Mark signature as used
        usedSignatures[claimId] = true;

        // Update state
        lastClaimTime[msg.sender] = block.timestamp;
        totalClaimed[msg.sender] += amount;
        totalClaimedGlobal += amount;
        totalClaimCount++;

        // Mint tokens
        _mint(msg.sender, amount);

        emit TokensClaimed(msg.sender, amount, block.timestamp, claimId);
    }

    /// @notice Check if a claim is valid (for frontend verification)
    /// @param player Player address
    /// @param amount Amount to claim
    /// @param claimId Unique claim identifier
    /// @param expiry Signature expiry
    /// @param signature Backend signature
    function isClaimValid(
        address player,
        uint256 amount,
        bytes32 claimId,
        uint256 expiry,
        bytes calldata signature
    ) external view returns (bool valid, string memory reason) {
        if (claimsPaused) return (false, "Claims paused");
        if (amount == 0) return (false, "Invalid amount");
        if (amount > MAX_CLAIM_PER_TX) return (false, "Exceeds max claim");
        if (totalSupply() + amount > MAX_SUPPLY) return (false, "Exceeds max supply");
        if (block.timestamp > expiry) return (false, "Signature expired");
        if (usedSignatures[claimId]) return (false, "Already claimed");
        if (block.timestamp < lastClaimTime[player] + CLAIM_COOLDOWN) {
            return (false, "Cooldown active");
        }

        bytes32 messageHash = keccak256(
            abi.encodePacked(
                player,
                amount,
                claimId,
                expiry,
                block.chainid,
                address(this)
            )
        );
        bytes32 ethSignedHash = messageHash.toEthSignedMessageHash();
        address signer = ethSignedHash.recover(signature);

        if (!authorizedSigners[signer]) return (false, "Invalid signer");

        return (true, "Valid");
    }

    /// @notice Get time until next claim is available
    /// @param player Player address
    function timeUntilNextClaim(address player) external view returns (uint256) {
        uint256 nextClaimTime = lastClaimTime[player] + CLAIM_COOLDOWN;
        if (block.timestamp >= nextClaimTime) return 0;
        return nextClaimTime - block.timestamp;
    }

    /// @notice Get player stats
    /// @param player Player address
    function getPlayerStats(address player) external view returns (
        uint256 balance,
        uint256 claimed,
        uint256 lastClaim,
        uint256 nextClaimIn
    ) {
        balance = balanceOf(player);
        claimed = totalClaimed[player];
        lastClaim = lastClaimTime[player];

        uint256 nextClaimTime = lastClaimTime[player] + CLAIM_COOLDOWN;
        nextClaimIn = block.timestamp >= nextClaimTime ? 0 : nextClaimTime - block.timestamp;
    }

    // ============ Admin Functions ============

    /// @notice Add an authorized signer
    function addSigner(address signer) external onlyOwner {
        require(signer != address(0), "Invalid address");
        authorizedSigners[signer] = true;
        emit SignerAdded(signer);
    }

    /// @notice Remove an authorized signer
    function removeSigner(address signer) external onlyOwner {
        authorizedSigners[signer] = false;
        emit SignerRemoved(signer);
    }

    /// @notice Pause/unpause claims
    function setClaimsPaused(bool paused) external onlyOwner {
        claimsPaused = paused;
        emit ClaimsPausedChanged(paused);
    }

    /// @notice Emergency mint (only owner, for initial distribution)
    function emergencyMint(address to, uint256 amount) external onlyOwner {
        require(totalSupply() + amount <= MAX_SUPPLY, "Exceeds max supply");
        _mint(to, amount);
    }

    // ============ View Functions ============

    /// @notice Get global stats
    function getGlobalStats() external view returns (
        uint256 supply,
        uint256 maxSupply,
        uint256 claimed,
        uint256 claimCount
    ) {
        supply = totalSupply();
        maxSupply = MAX_SUPPLY;
        claimed = totalClaimedGlobal;
        claimCount = totalClaimCount;
    }
}
