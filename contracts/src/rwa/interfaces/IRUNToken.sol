// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @title IRUNToken - Interface for RUN governance/utility token
/// @notice ERC-20 token with boost mechanism and fee processing
interface IRUNToken is IERC20 {
    /// @notice Emitted when boost is activated
    event BoostActivated(
        address indexed player,
        uint256 runAmount,
        uint256 multiplier,
        uint256 expiresAt
    );

    /// @notice Emitted when buyback and burn occurs
    event BuybackBurn(
        uint256 ethAmount,
        uint256 burnedTokens
    );

    /// @notice Emitted when deposit to yield pool
    event YieldPoolDeposit(uint256 amount);

    /// @notice Activate run multiplier boost by burning tokens
    /// @param runAmount Amount of RUN to burn (must be >= 10% of holdings)
    function activateBoost(uint256 runAmount) external;

    /// @notice Get active boost info for a player
    /// @param player The player address
    /// @return multiplier Current multiplier (100 = 1x)
    /// @return expiresAt Boost expiration timestamp
    function getActiveBoost(address player) external view returns (
        uint256 multiplier,
        uint256 expiresAt
    );

    /// @notice Execute buyback and burn with ETH
    /// @param ethAmount Amount of ETH to use for buyback
    function executeBuybackBurn(uint256 ethAmount) external;

    /// @notice Deposit ETH to yield pool
    function depositToYieldPool() external payable;
}
