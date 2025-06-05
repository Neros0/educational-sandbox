// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TimeLock {
    mapping(address => uint256) public lockTime;
    mapping(address => uint256) public lockedAmount;
}
