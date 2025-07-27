// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract MathChallenge1 {
    string public problem;
    uint256 public immutable correctAnswer;
    string public hint;
    uint256 public difficulty; // 1-5 scale

    mapping(address => uint256) public attempts;
    mapping(address => bool) public solved;

    event Attempt(address indexed student, uint256 answer, bool correct, uint256 attemptCount);
    event ProblemSolved(address indexed student, uint256 finalAttempts);
}
