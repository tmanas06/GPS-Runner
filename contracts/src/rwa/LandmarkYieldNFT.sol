// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "./interfaces/IIndiaRunner.sol";
import "./interfaces/ILandmarkYield.sol";

/// @title LandmarkYieldNFT - ERC-1155 Yield Tokens for GPS Runner Game
/// @notice Mint yield tokens when runners complete GPS proofs at landmarks
/// @dev Each landmark type is a token ID, yield distributed from sponsor pools
contract LandmarkYieldNFT is ERC1155, ERC1155Supply, Ownable, ReentrancyGuard, Pausable, ILandmarkYield {
    // ============ Constants ============
    uint256 public constant YIELD_PRECISION = 1e18;
    uint256 public constant YIELD_PER_KM = 100; // 100 yield units per km
    uint256 public constant MINT_COOLDOWN = 1 hours;

    // ============ State ============
    IIndiaRunner public immutable indiaRunner;

    // Token holder yield tracking (MasterChef-style)
    mapping(uint256 => uint256) public accYieldPerShare; // tokenId => accumulated yield per share
    mapping(address => mapping(uint256 => uint256)) public userYieldDebt; // user => tokenId => debt
    mapping(address => mapping(uint256 => uint256)) public userPendingYield; // user => tokenId => pending

    // Sponsor pools per landmark
    mapping(uint256 => uint256) public sponsorPools; // landmarkId => pool balance
    mapping(uint256 => uint256) public totalYieldDistributed; // landmarkId => total distributed

    // Mint tracking
    mapping(address => mapping(bytes32 => uint256)) public lastMintTime; // player => landmarkHash => timestamp
    mapping(bytes32 => bool) public usedProofHashes; // GPS proof deduplication

    // Landmark metadata
    mapping(uint256 => string) public landmarkNames;
    mapping(uint256 => bytes32) public landmarkCities;

    // Authorized minters (game backend or other contracts)
    mapping(address => bool) public authorizedMinters;

    // ============ Constructor ============
    constructor(
        address _indiaRunner,
        string memory _uri
    ) ERC1155(_uri) Ownable(msg.sender) {
        indiaRunner = IIndiaRunner(_indiaRunner);
    }

    // ============ Minting ============

    /// @inheritdoc ILandmarkYield
    function mintLandmarkYield(
        address player,
        bytes32 landmarkHash,
        uint256 kmRun1e3,
        bytes32 gpsProofHash
    ) external override nonReentrant whenNotPaused returns (uint256 tokenId) {
        require(authorizedMinters[msg.sender] || msg.sender == owner(), "Not authorized");
        require(!usedProofHashes[gpsProofHash], "Proof already used");
        require(
            block.timestamp >= lastMintTime[player][landmarkHash] + MINT_COOLDOWN,
            "Cooldown not met"
        );

        // Verify player is registered in IndiaRunner
        (,,,, bool isRegistered) = indiaRunner.getPlayerStats(player);
        require(isRegistered, "Player not registered");

        usedProofHashes[gpsProofHash] = true;
        lastMintTime[player][landmarkHash] = block.timestamp;

        tokenId = getLandmarkTokenId(landmarkHash);

        // Calculate yield amount: kmRun * YIELD_PER_KM
        uint256 yieldAmount = (kmRun1e3 * YIELD_PER_KM) / 1000;
        require(yieldAmount > 0, "Zero yield");

        // Update yield tracking before minting
        _updateYield(player, tokenId);

        // Mint yield tokens representing the claim
        _mint(player, tokenId, yieldAmount, "");

        emit LandmarkYieldMinted(player, tokenId, tokenId, yieldAmount, kmRun1e3);
    }

    /// @notice Batch mint for multiple landmarks in one transaction
    function batchMintLandmarkYield(
        address player,
        bytes32[] calldata landmarkHashes,
        uint256[] calldata kmRuns1e3,
        bytes32[] calldata gpsProofHashes
    ) external nonReentrant whenNotPaused returns (uint256[] memory tokenIds) {
        require(authorizedMinters[msg.sender] || msg.sender == owner(), "Not authorized");
        require(
            landmarkHashes.length == kmRuns1e3.length &&
            landmarkHashes.length == gpsProofHashes.length,
            "Length mismatch"
        );

        tokenIds = new uint256[](landmarkHashes.length);

        for (uint256 i = 0; i < landmarkHashes.length; i++) {
            require(!usedProofHashes[gpsProofHashes[i]], "Proof already used");
            require(
                block.timestamp >= lastMintTime[player][landmarkHashes[i]] + MINT_COOLDOWN,
                "Cooldown not met"
            );

            usedProofHashes[gpsProofHashes[i]] = true;
            lastMintTime[player][landmarkHashes[i]] = block.timestamp;

            uint256 tokenId = getLandmarkTokenId(landmarkHashes[i]);
            tokenIds[i] = tokenId;

            uint256 yieldAmount = (kmRuns1e3[i] * YIELD_PER_KM) / 1000;
            if (yieldAmount > 0) {
                _updateYield(player, tokenId);
                _mint(player, tokenId, yieldAmount, "");
                emit LandmarkYieldMinted(player, tokenId, tokenId, yieldAmount, kmRuns1e3[i]);
            }
        }
    }

    // ============ Yield Distribution ============

    /// @inheritdoc ILandmarkYield
    function depositToSponsorPool(uint256 landmarkId) external payable override {
        require(msg.value > 0, "Zero deposit");
        sponsorPools[landmarkId] += msg.value;

        // Distribute to token holders
        uint256 supply = totalSupply(landmarkId);
        if (supply > 0) {
            accYieldPerShare[landmarkId] += (msg.value * YIELD_PRECISION) / supply;
        }

        emit SponsorPoolDeposited(landmarkId, msg.sender, msg.value);
    }

    /// @notice Deposit to multiple sponsor pools
    function batchDepositToSponsorPools(
        uint256[] calldata landmarkIds,
        uint256[] calldata amounts
    ) external payable {
        require(landmarkIds.length == amounts.length, "Length mismatch");

        uint256 totalAmount;
        for (uint256 i = 0; i < amounts.length; i++) {
            totalAmount += amounts[i];
        }
        require(msg.value == totalAmount, "Incorrect ETH amount");

        for (uint256 i = 0; i < landmarkIds.length; i++) {
            if (amounts[i] > 0) {
                sponsorPools[landmarkIds[i]] += amounts[i];

                uint256 supply = totalSupply(landmarkIds[i]);
                if (supply > 0) {
                    accYieldPerShare[landmarkIds[i]] += (amounts[i] * YIELD_PRECISION) / supply;
                }

                emit SponsorPoolDeposited(landmarkIds[i], msg.sender, amounts[i]);
            }
        }
    }

    /// @inheritdoc ILandmarkYield
    function claimYield(uint256 tokenId) external override nonReentrant returns (uint256 amount) {
        _updateYield(msg.sender, tokenId);

        amount = userPendingYield[msg.sender][tokenId];
        require(amount > 0, "No yield to claim");

        userPendingYield[msg.sender][tokenId] = 0;
        totalYieldDistributed[tokenId] += amount;

        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");

        emit YieldClaimed(msg.sender, tokenId, amount);
    }

    /// @notice Claim yield from multiple tokens
    function batchClaimYield(uint256[] calldata tokenIds) external nonReentrant returns (uint256 totalAmount) {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            _updateYield(msg.sender, tokenIds[i]);

            uint256 amount = userPendingYield[msg.sender][tokenIds[i]];
            if (amount > 0) {
                userPendingYield[msg.sender][tokenIds[i]] = 0;
                totalYieldDistributed[tokenIds[i]] += amount;
                totalAmount += amount;

                emit YieldClaimed(msg.sender, tokenIds[i], amount);
            }
        }

        require(totalAmount > 0, "No yield to claim");

        (bool success, ) = msg.sender.call{value: totalAmount}("");
        require(success, "Transfer failed");
    }

    /// @inheritdoc ILandmarkYield
    function getPendingYield(uint256 tokenId) external view override returns (uint256) {
        uint256 balance = balanceOf(msg.sender, tokenId);
        if (balance == 0) return userPendingYield[msg.sender][tokenId];

        uint256 accYield = accYieldPerShare[tokenId];
        uint256 pending = (balance * accYield) / YIELD_PRECISION - userYieldDebt[msg.sender][tokenId];

        return userPendingYield[msg.sender][tokenId] + pending;
    }

    /// @notice Get pending yield for a specific user
    function getPendingYieldFor(address user, uint256 tokenId) external view returns (uint256) {
        uint256 balance = balanceOf(user, tokenId);
        if (balance == 0) return userPendingYield[user][tokenId];

        uint256 accYield = accYieldPerShare[tokenId];
        uint256 pending = (balance * accYield) / YIELD_PRECISION - userYieldDebt[user][tokenId];

        return userPendingYield[user][tokenId] + pending;
    }

    /// @notice Get total pending yield across all tokens for a user
    function getTotalPendingYield(address user, uint256[] calldata tokenIds) external view returns (uint256 total) {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            uint256 balance = balanceOf(user, tokenIds[i]);
            if (balance > 0) {
                uint256 accYield = accYieldPerShare[tokenIds[i]];
                uint256 pending = (balance * accYield) / YIELD_PRECISION - userYieldDebt[user][tokenIds[i]];
                total += userPendingYield[user][tokenIds[i]] + pending;
            } else {
                total += userPendingYield[user][tokenIds[i]];
            }
        }
    }

    // ============ Internal ============

    function _updateYield(address user, uint256 tokenId) internal {
        uint256 balance = balanceOf(user, tokenId);
        if (balance > 0) {
            uint256 pending = (balance * accYieldPerShare[tokenId]) / YIELD_PRECISION
                              - userYieldDebt[user][tokenId];
            userPendingYield[user][tokenId] += pending;
        }
        userYieldDebt[user][tokenId] = (balance * accYieldPerShare[tokenId]) / YIELD_PRECISION;
    }

    /// @inheritdoc ILandmarkYield
    function getLandmarkTokenId(bytes32 landmarkHash) public pure override returns (uint256) {
        return uint256(landmarkHash);
    }

    // ============ Overrides ============

    function _update(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory values
    ) internal override(ERC1155, ERC1155Supply) {
        // Update yield before transfer
        for (uint256 i = 0; i < ids.length; i++) {
            if (from != address(0)) _updateYield(from, ids[i]);
            if (to != address(0)) _updateYield(to, ids[i]);
        }

        super._update(from, to, ids, values);

        // Update debt after transfer
        for (uint256 i = 0; i < ids.length; i++) {
            if (from != address(0)) {
                userYieldDebt[from][ids[i]] = (balanceOf(from, ids[i]) * accYieldPerShare[ids[i]]) / YIELD_PRECISION;
            }
            if (to != address(0)) {
                userYieldDebt[to][ids[i]] = (balanceOf(to, ids[i]) * accYieldPerShare[ids[i]]) / YIELD_PRECISION;
            }
        }
    }

    // ============ View Functions ============

    /// @notice Get landmark info
    function getLandmarkInfo(uint256 tokenId) external view returns (
        string memory name,
        bytes32 cityHash,
        uint256 totalSupplyAmount,
        uint256 sponsorPoolBalance,
        uint256 accumulatedYield
    ) {
        return (
            landmarkNames[tokenId],
            landmarkCities[tokenId],
            totalSupply(tokenId),
            sponsorPools[tokenId],
            accYieldPerShare[tokenId]
        );
    }

    /// @notice Check if can mint for a landmark
    function canMint(address player, bytes32 landmarkHash) external view returns (bool, string memory reason) {
        if (block.timestamp < lastMintTime[player][landmarkHash] + MINT_COOLDOWN) {
            return (false, "Cooldown not met");
        }

        (,,,, bool isRegistered) = indiaRunner.getPlayerStats(player);
        if (!isRegistered) {
            return (false, "Player not registered");
        }

        return (true, "");
    }

    // ============ Admin ============

    function setAuthorizedMinter(address minter, bool authorized) external onlyOwner {
        authorizedMinters[minter] = authorized;
    }

    function setLandmarkMetadata(
        uint256 tokenId,
        string memory name,
        bytes32 cityHash
    ) external onlyOwner {
        landmarkNames[tokenId] = name;
        landmarkCities[tokenId] = cityHash;
    }

    function batchSetLandmarkMetadata(
        uint256[] calldata tokenIds,
        string[] calldata names,
        bytes32[] calldata cityHashes
    ) external onlyOwner {
        require(
            tokenIds.length == names.length && tokenIds.length == cityHashes.length,
            "Length mismatch"
        );

        for (uint256 i = 0; i < tokenIds.length; i++) {
            landmarkNames[tokenIds[i]] = names[i];
            landmarkCities[tokenIds[i]] = cityHashes[i];
        }
    }

    function setURI(string memory newuri) external onlyOwner {
        _setURI(newuri);
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

    receive() external payable {}
}
