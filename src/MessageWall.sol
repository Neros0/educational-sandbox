// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract MessageWall {
    mapping(address => mapping(address => bytes32)) public messages;

    // Leave a message for someone
    function leaveMessage(address recipient, bytes32 message) external {
        messages[msg.sender][recipient] = message;
    }
}
