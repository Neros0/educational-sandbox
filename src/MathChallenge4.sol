// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title MathChallenge
 * @notice A smart contract that presents mathematical problems for students to solve
 * @dev This contract allows deployment of individual math problems with tracking of student attempts and solutions
 * @custom:version 1.0.0
 */
contract MathChallenge4 {
    /*//////////////////////////////////////////////////////////////
                                STORAGE
    //////////////////////////////////////////////////////////////*/

    /// @notice The mathematical problem statement presented to students
    /// @dev Stored as a string to allow complex mathematical expressions and formatting
    string public problem = "What is 2^8 + 5^1 - 2^1?";

    /// @notice The correct numerical answer to the mathematical problem
    /// @dev Immutable to prevent tampering after deployment, ensuring problem integrity
    uint256 public immutable correctAnswer = 259; // 256 + 5 - 2 = 259

    /// @notice A hint to help students solve the problem
    /// @dev Can be updated by adding a setter function if needed for dynamic hints
    string public hint = "Break it down: calculate each exponent separately, then add and subtract";

    /// @notice Difficulty rating of the problem on a 1-5 scale
    /// @dev 1 = Very Easy, 2 = Easy, 3 = Medium, 4 = Hard, 5 = Very Hard
    uint256 public difficulty = 2;
}
