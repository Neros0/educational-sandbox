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
}
