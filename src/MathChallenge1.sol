// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title MathChallenge
 * @notice A smart contract that presents mathematical problems for students to solve
 * @dev This contract allows deployment of individual math problems with tracking of student attempts and solutions
 * @custom:version 1.0.0
 */
contract MathChallenge1 {
    string public problem;
    uint256 public immutable correctAnswer;
    string public hint;
    uint256 public difficulty; // 1-5 scale

    mapping(address => uint256) public attempts;
    mapping(address => bool) public solved;

    event Attempt(address indexed student, uint256 answer, bool correct, uint256 attemptCount);
    event ProblemSolved(address indexed student, uint256 finalAttempts);

    constructor(string memory _problem, uint256 _answer, string memory _hint, uint256 _difficulty) {
        problem = _problem;
        correctAnswer = _answer;
        hint = _hint;
        difficulty = _difficulty;
    }
}
