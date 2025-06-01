// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SimplePoll {
    bytes32 public question;
    mapping(address => bool) public votes; // true = yes, false = no
    mapping(address => bool) public hasVoted;
    uint256 public yesCount;
    uint256 public noCount;
}
