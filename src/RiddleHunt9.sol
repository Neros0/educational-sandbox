// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract RiddleHunt9 {
    bytes32 public immutable answerHash;
    string public constant hint = "The answer is a type of food";

    mapping(address => uint256) public attempts;

    event Attempt(address indexed player, bool correct, uint256 attemptCount);
}
