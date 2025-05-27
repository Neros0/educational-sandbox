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

    event MessagePosted(address indexed author, uint256 indexed messageId, string content, uint256 timestamp);

    /**
     * @dev Post a new message to the guestbook
     * @param _content The message content
     */
    function postMessage(string memory _content) external {
        require(bytes(_content).length > 0, "Message cannot be empty");
        require(bytes(_content).length <= MAX_MESSAGE_LENGTH, "Message too long");
        require(
            block.timestamp >= lastMessageTime[msg.sender] + COOLDOWN_PERIOD, "Must wait before posting another message"
        );

        uint256 messageId = nextMessageId;
        nextMessageId++;

        Message memory newMessage =
            Message({author: msg.sender, content: _content, timestamp: block.timestamp, id: messageId});

        messages.push(newMessage);
        userMessages[msg.sender].push(messageId);
        userMessageCount[msg.sender]++;
        totalMessages++;
        lastMessageTime[msg.sender] = block.timestamp;

        emit MessagePosted(msg.sender, messageId, _content, block.timestamp);
    }

    /**
     * @dev Get a message by its index in the messages array
     * @param _index Index of the message
     * @return Message struct
     */
    function getMessage(uint256 _index) external view returns (Message memory) {
        require(_index < messages.length, "Message index out of bounds");
        return messages[_index];
    }

    /**
     * @dev Get the latest N messages
     * @param _count Number of recent messages to retrieve
     * @return Array of Message structs
     */
    function getLatestMessages(uint256 _count) external view returns (Message[] memory) {
        require(_count > 0, "Count must be greater than 0");

        uint256 startIndex = messages.length > _count ? messages.length - _count : 0;
        uint256 resultLength = messages.length - startIndex;

        Message[] memory result = new Message[](resultLength);

        for (uint256 i = 0; i < resultLength; i++) {
            result[i] = messages[startIndex + i];
        }

        return result;
    }
}
