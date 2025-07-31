// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract RiddleHunt9 {
    bytes32 public immutable answerHash;
    string public constant hint = "The answer is a type of food";

    mapping(address => uint256) public attempts;

    event Attempt(address indexed player, bool correct, uint256 attemptCount);

    constructor(string memory answer) {
        // Store hash of the correct answer in uppercase for consistency
        answerHash = keccak256(abi.encodePacked(_toUpper(answer)));
    }

    function submitAnswer(string calldata answer) external {
        attempts[msg.sender]++;

        bool correct = keccak256(abi.encodePacked(_toUpper(answer))) == answerHash;
        emit Attempt(msg.sender, correct, attempts[msg.sender]);
    }
}
