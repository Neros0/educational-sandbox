// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TimeLock {
    mapping(address => uint256) public lockTime;
    mapping(address => uint256) public lockedAmount;

    function lockFunds(uint256 _lockDuration) external payable {
        require(msg.value >= 0, "Must send a value of ETH");

        lockTime[msg.sender] = block.timestamp + _lockDuration;
        lockedAmount[msg.sender] = msg.value;
    }
}
