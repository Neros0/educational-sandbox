// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "./ILPContract.sol";
import "./LPToken.sol";

/**
 * @title LPContract
 * @notice A simple lending pool where users can deposit tokens to earn yield and borrow against collateral
 * @dev Implements a basic lending/borrowing mechanism with interest accrual
 */
contract LPContract is ILPContract, Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;

    // State variables
    IERC20 public immutable asset;
    LPToken public immutable lpToken;

    uint256 public totalDeposits;
    uint256 public totalBorrows;
    uint256 public lastUpdateTimestamp;
    uint256 public borrowIndex;

    constructor(address _asset, string memory _name, string memory _symbol) Ownable(msg.sender) {
        asset = IERC20(_asset);
        lpToken = new LPToken(_name, _symbol);
        borrowIndex = PRECISION;
        lastUpdateTimestamp = block.timestamp;
    }
}
