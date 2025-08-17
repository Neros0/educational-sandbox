// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title MathChallenge
 * @notice A smart contract that presents mathematical problems for students to solve
 * @dev This contract allows deployment of individual math problems with tracking of student attempts and solutions
 * @custom:version 1.0.0
 */
contract MathChallenge16 {
    /*//////////////////////////////////////////////////////////////
                                STORAGE
    //////////////////////////////////////////////////////////////*/

    /// @notice The mathematical problem statement presented to students
    /// @dev Stored as a string to allow complex mathematical expressions and formatting
    string public problem = "What is 2^8 + 10^1 - 4^3 + 3 + 3 + 1?";

    /// @notice The correct numerical answer to the mathematical problem
    /// @dev Immutable to prevent tampering after deployment, ensuring problem integrity
    uint256 public immutable correctAnswer = 210; // 256 + 10 - 64 + 3 + 3 + 1 = 210

    /// @notice A hint to help students solve the problem
    /// @dev Can be updated by adding a setter function if needed for dynamic hints
    string public hint = "Break it down: calculate each exponent separately, then add and subtract";

    /// @notice Difficulty rating of the problem on a 1-5 scale
    /// @dev 1 = Very Easy, 2 = Easy, 3 = Medium, 4 = Hard, 5 = Very Hard
    uint256 public difficulty = 2;

    /*//////////////////////////////////////////////////////////////
                                MAPPINGS
    //////////////////////////////////////////////////////////////*/

    /// @notice Tracks the number of attempts each student has made
    /// @dev Maps student address to their attempt count for this specific problem
    mapping(address => uint256) public attempts;

    /// @notice Tracks whether each student has successfully solved the problem
    /// @dev Maps student address to boolean indicating if they've found the correct answer
    mapping(address => bool) public solved;
}
