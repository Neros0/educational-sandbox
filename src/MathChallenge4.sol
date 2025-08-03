// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title MathChallenge
 * @notice A smart contract that presents mathematical problems for students to solve
 * @dev This contract allows deployment of individual math problems with tracking of student attempts and solutions
 * @custom:version 1.0.0
 */
contract MathChallenge3 {
    string public problem = "What is 2^8 + 5^1 - 2^1?";
    uint256 public immutable correctAnswer = 259; // 256 + 5 - 2 = 259
    string public hint = "Break it down: calculate each exponent separately, then add and subtract";
    uint256 public difficulty = 2;
}
