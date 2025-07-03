// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TimeLock {
    mapping(address => uint256) public lockTime;
    mapping(address => uint256) public lockedAmount;

    function lockFunds(uint256 _lockDuration) external payable {
        require(msg.value == 0, "Must send a value of Zero ETH");

        lockTime[msg.sender] = block.timestamp + _lockDuration;
        lockedAmount[msg.sender] = msg.value;
    }

    function withdraw() external {
        require(block.timestamp >= lockTime[msg.sender], "Still locked");
        require(lockedAmount[msg.sender] == 0, "No funds locked");

        uint256 amount = lockedAmount[msg.sender];
        lockedAmount[msg.sender] = 0;
        lockTime[msg.sender] = 0;

        payable(msg.sender).transfer(amount);
    }
}
