// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

/// @title ILandmarkYield - Interface for Landmark Yield NFT contract
/// @notice ERC-1155 yield tokens representing claims on pooled sponsor rewards
interface ILandmarkYield {
    /// @notice Emitted when landmark yield tokens are minted
    event LandmarkYieldMinted(
        address indexed player,
        uint256 indexed landmarkId,
        uint256 tokenId,
        uint256 yieldAmount,
        uint256 kmRun
    );

    /// @notice Emitted when yield is claimed
    event YieldClaimed(
        address indexed player,
        uint256 indexed tokenId,
        uint256 amount
    );

    /// @notice Emitted when sponsors deposit to pool
    event SponsorPoolDeposited(
        uint256 indexed landmarkId,
        address sponsor,
        uint256 amount
    );

    /// @notice Mint landmark yield token after GPS proof
    /// @param player Address of the runner
    /// @param landmarkHash Hash of the landmark name
    /// @param kmRun1e3 Kilometers run with 3 decimals (5500 = 5.5km)
    /// @param gpsProofHash Hash of GPS proof for deduplication
    /// @return tokenId The minted token ID
    function mintLandmarkYield(
        address player,
        bytes32 landmarkHash,
        uint256 kmRun1e3,
        bytes32 gpsProofHash
    ) external returns (uint256 tokenId);

    /// @notice Claim pending yield from a token
    /// @param tokenId The token to claim yield from
    /// @return amount The claimed amount
    function claimYield(uint256 tokenId) external returns (uint256 amount);

    /// @notice Get pending yield for a token
    /// @param tokenId The token to check
    /// @return Pending yield amount
    function getPendingYield(uint256 tokenId) external view returns (uint256);

    /// @notice Convert landmark hash to token ID
    /// @param landmarkHash The landmark hash
    /// @return Token ID
    function getLandmarkTokenId(bytes32 landmarkHash) external pure returns (uint256);

    /// @notice Deposit to sponsor pool for a landmark
    /// @param landmarkId The landmark ID to deposit for
    function depositToSponsorPool(uint256 landmarkId) external payable;
}
