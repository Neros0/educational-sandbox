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

    /**
     * @dev Get messages by a specific user
     * @param _user Address of the user
     * @return Array of Message structs
     */
    function getUserMessages(address _user) external view returns (Message[] memory) {
        uint256[] memory messageIds = userMessages[_user];
        Message[] memory result = new Message[](messageIds.length);

        for (uint256 i = 0; i < messageIds.length; i++) {
            // Find message by ID
            for (uint256 j = 0; j < messages.length; j++) {
                if (messages[j].id == messageIds[i]) {
                    result[i] = messages[j];
                    break;
                }
            }
        }

        return result;
    }

    /**
     * @dev Get messages in a specific range
     * @param _start Start index (inclusive)
     * @param _end End index (exclusive)
     * @return Array of Message structs
     */
    function getMessagesInRange(uint256 _start, uint256 _end) external view returns (Message[] memory) {
        require(_start < messages.length, "Start index out of bounds");
        require(_end <= messages.length, "End index out of bounds");
        require(_start < _end, "Invalid range");

        uint256 length = _end - _start;
        Message[] memory result = new Message[](length);

        for (uint256 i = 0; i < length; i++) {
            result[i] = messages[_start + i];
        }

        return result;
    }

    /**
     * @dev Get total number of messages
     * @return Total message count
     */
    function getTotalMessages() external view returns (uint256) {
        return totalMessages;
    }
}
