// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title VotingSystem
 * @dev A simple voting system for community decisions (no tokens needed)
 */
contract VotingSystem {
    enum VoteOption {
        ABSTAIN,
        YES,
        NO
    }
    enum ProposalStatus {
        PENDING,
        ACTIVE,
        PASSED,
        REJECTED,
        CANCELLED
    }

    struct Proposal {
        uint256 id;
        address proposer;
        string title;
        string description;
        uint256 createdAt;
        uint256 startTime;
        uint256 endTime;
        uint256 yesVotes;
        uint256 noVotes;
        uint256 abstainVotes;
        uint256 totalVotes;
        ProposalStatus status;
        bool executed;
    }

    struct Vote {
        address voter;
        uint256 proposalId;
        VoteOption choice;
        uint256 timestamp;
        string comment;
    }
}
