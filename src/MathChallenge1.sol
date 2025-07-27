// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract MathChallenge1 {
    string public problem;
    uint256 public immutable correctAnswer;
    string public hint;
    uint256 public difficulty; // 1-5 scale

    mapping(address => uint256) public attempts;
    mapping(address => bool) public solved;
}
