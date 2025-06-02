// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SimplePoll {
    bytes32 public question;
    mapping(address => bool) public votes; // true = yes, false = no
    mapping(address => bool) public hasVoted;
    uint256 public yesCount;
    uint256 public noCount;

    constructor(bytes32 _question) {
        question = _question;
    }

    function vote(bool _vote) external {
        votes[msg.sender] = _vote;
        hasVoted[msg.sender] = true;

        if (_vote) {
            yesCount++;
        } else {
            noCount++;
        }
    }

    function getResults() external view returns (uint256 yes, uint256 no) {
        return (yesCount, noCount);
    }
}
