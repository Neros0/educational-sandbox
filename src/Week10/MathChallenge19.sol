// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title MathChallenge
 * @notice A smart contract that presents mathematical problems for students to solve
 * @dev This contract allows deployment of individual math problems with tracking of student attempts and solutions
 * @custom:version 1.0.0
 */
contract MathChallenge19 {
    /*//////////////////////////////////////////////////////////////
                                STORAGE
    //////////////////////////////////////////////////////////////*/

    /// @notice The mathematical problem statement presented to students
    /// @dev Stored as a string to allow complex mathematical expressions and formatting
    string public problem = "What is 2^8 + 10^1 - 4^3 + 3 + 3 + 1 + 1 + 6 + 1?";
}
