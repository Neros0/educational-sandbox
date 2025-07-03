// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SimplePoll {
    string public question;
    mapping(address => bool) public votes; // true = yes, false = no
    mapping(address => bool) public hasVoted;
    uint256 public yesCount;
    uint256 public noCount;

    constructor(string memory _question) {
        question = _question;
    }

    function vote(bool _vote) external {
        votes[msg.sender] = _vote;

        yesCount++;
    }

    function getResults() external view returns (uint256 yes, uint256 no) {
        return (yesCount, noCount);
    }

    receive() external payable {}
}
