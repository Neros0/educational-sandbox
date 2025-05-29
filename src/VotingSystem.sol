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

    // Storage
    Proposal[] public proposals;
    mapping(uint256 => mapping(address => bool)) public hasVoted;
    mapping(uint256 => mapping(address => VoteOption)) public userVotes;
    mapping(uint256 => Vote[]) public proposalVotes;
    mapping(address => uint256[]) public userProposals;
    mapping(address => uint256) public userVoteCount;

    uint256 public totalProposals;
    uint256 private nextProposalId;

    // Configuration
    uint256 public constant MIN_VOTING_PERIOD = 1 days;
    uint256 public constant MAX_VOTING_PERIOD = 30 days;
    uint256 public constant PROPOSAL_COOLDOWN = 1 hours; // Time between proposals from same user

    mapping(address => uint256) public lastProposalTime;

    // Admin settings
    address public admin;
    bool public proposalCreationOpen; // If false, only admin can create proposals

    event ProposalCreated(
        uint256 indexed proposalId, address indexed proposer, string title, uint256 startTime, uint256 endTime
    );

    event VoteCast(uint256 indexed proposalId, address indexed voter, VoteOption choice, string comment);

    event ProposalStatusChanged(uint256 indexed proposalId, ProposalStatus newStatus);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    modifier validProposal(uint256 _proposalId) {
        require(_proposalId < proposals.length, "Proposal does not exist");
        _;
    }
}
