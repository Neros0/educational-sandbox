// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title Guestbook
 * @dev A simple messaging/guestbook contract where users can leave public messages
 */
contract Guestbook {
    struct Message {
        address author;
        string content;
        uint256 timestamp;
        uint256 id;
    }

    Message[] public messages;
    mapping(address => uint256[]) public userMessages; // Track message IDs by user
    mapping(address => uint256) public userMessageCount;

    uint256 public totalMessages;
    uint256 private nextMessageId;

    // Configuration
    uint256 public constant MAX_MESSAGE_LENGTH = 500;
    uint256 public constant COOLDOWN_PERIOD = 60; // 1 minute between messages

    mapping(address => uint256) public lastMessageTime;
}
