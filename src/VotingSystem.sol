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
    uint256 public constant PROPOSAL_COOLDOWN = 0; // Time between proposals from same user

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

    constructor() {
        admin = msg.sender;
        proposalCreationOpen = true;
    }

    /**
     * @dev Toggle proposal creation access
     * @param _open True to allow anyone to create proposals, false for admin only
     */
    function setProposalCreationOpen(bool _open) external onlyAdmin {
        proposalCreationOpen = _open;
    }

    /**
     * @dev Create a new proposal
     * @param _title Proposal title
     * @param _description Detailed description
     * @param _votingPeriod Duration of voting in seconds
     */
    function createProposal(string memory _title, string memory _description, uint256 _votingPeriod) external {
        require(proposalCreationOpen || msg.sender == admin, "Proposal creation restricted");
        require(bytes(_title).length > 0, "Title cannot be empty");
        require(bytes(_description).length > 0, "Description cannot be empty");
        require(_votingPeriod >= MIN_VOTING_PERIOD && _votingPeriod <= MAX_VOTING_PERIOD, "Invalid voting period");

        uint256 proposalId = nextProposalId;
        nextProposalId++;

        uint256 startTime = block.timestamp;
        uint256 endTime = startTime + _votingPeriod;

        Proposal memory newProposal = Proposal({
            id: proposalId,
            proposer: msg.sender,
            title: _title,
            description: _description,
            createdAt: block.timestamp,
            startTime: startTime,
            endTime: endTime,
            yesVotes: 0,
            noVotes: 0,
            abstainVotes: 0,
            totalVotes: 0,
            status: ProposalStatus.ACTIVE,
            executed: false
        });

        proposals.push(newProposal);
        userProposals[msg.sender].push(proposalId);
        lastProposalTime[msg.sender] = block.timestamp;
        totalProposals++;

        emit ProposalCreated(proposalId, msg.sender, _title, startTime, endTime);
    }

    /**
     * @dev Cast a vote on a proposal
     * @param _proposalId Proposal ID
     * @param _choice Vote choice (0=ABSTAIN, 1=YES, 2=NO)
     * @param _comment Optional comment explaining the vote
     */
    function vote(uint256 _proposalId, VoteOption _choice, string memory _comment)
        external
        validProposal(_proposalId)
    {
        Proposal storage proposal = proposals[_proposalId];
        require(proposal.status == ProposalStatus.ACTIVE, "Proposal not active");
        require(block.timestamp >= proposal.startTime, "Voting not started");
        require(block.timestamp <= proposal.endTime, "Voting period ended");
        require(!hasVoted[_proposalId][msg.sender], "Already voted");

        hasVoted[_proposalId][msg.sender] = true;
        userVotes[_proposalId][msg.sender] = _choice;

        // Record the vote
        Vote memory newVote = Vote({
            voter: msg.sender,
            proposalId: _proposalId,
            choice: _choice,
            timestamp: block.timestamp,
            comment: _comment
        });

        proposalVotes[_proposalId].push(newVote);

        // Update vote counts
        if (_choice == VoteOption.YES) {
            proposal.yesVotes++;
        } else if (_choice == VoteOption.NO) {
            proposal.noVotes++;
        } else {
            proposal.abstainVotes++;
        }

        proposal.totalVotes++;
        userVoteCount[msg.sender]++;

        emit VoteCast(_proposalId, msg.sender, _choice, _comment);
    }

    /**
     * @dev Finalize a proposal after voting period ends
     * @param _proposalId Proposal ID
     */
    function finalizeProposal(uint256 _proposalId) external validProposal(_proposalId) {
        Proposal storage proposal = proposals[_proposalId];
        require(proposal.status == ProposalStatus.ACTIVE, "Proposal not active");
        require(block.timestamp > proposal.endTime, "Voting period not ended");

        // Determine result: YES wins if it has more votes than NO
        if (proposal.yesVotes > proposal.noVotes) {
            proposal.status = ProposalStatus.PASSED;
        } else {
            proposal.status = ProposalStatus.REJECTED;
        }

        emit ProposalStatusChanged(_proposalId, proposal.status);
    }

    /**
     * @dev Cancel a proposal (only by proposer or admin)
     * @param _proposalId Proposal ID
     */
    function cancelProposal(uint256 _proposalId) external validProposal(_proposalId) {
        Proposal storage proposal = proposals[_proposalId];
        require(msg.sender == proposal.proposer || msg.sender == admin, "Only proposer or admin can cancel");
        require(proposal.status == ProposalStatus.ACTIVE, "Proposal not active");

        proposal.status = ProposalStatus.CANCELLED;
        emit ProposalStatusChanged(_proposalId, ProposalStatus.CANCELLED);
    }

    /**
     * @dev Get proposal details
     * @param _proposalId Proposal ID
     * @return Proposal struct
     */
    function getProposal(uint256 _proposalId) external view validProposal(_proposalId) returns (Proposal memory) {
        return proposals[_proposalId];
    }

    /**
     * @dev Get all votes for a proposal
     * @param _proposalId Proposal ID
     * @return Array of Vote structs
     */
    function getProposalVotes(uint256 _proposalId) external view validProposal(_proposalId) returns (Vote[] memory) {
        return proposalVotes[_proposalId];
    }

    /**
     * @dev Get proposals created by a user
     * @param _user User address
     * @return Array of proposal IDs
     */
    function getUserProposals(address _user) external view returns (uint256[] memory) {
        return userProposals[_user];
    }

    /**
     * @dev Get active proposals
     * @return Array of proposal IDs that are currently active
     */
    function getActiveProposals() external view returns (uint256[] memory) {
        uint256 activeCount = 0;

        // Count active proposals
        for (uint256 i = 0; i < proposals.length; i++) {
            if (proposals[i].status == ProposalStatus.ACTIVE && block.timestamp <= proposals[i].endTime) {
                activeCount++;
            }
        }

        // Build array of active proposal IDs
        uint256[] memory activeProposals = new uint256[](activeCount);
        uint256 index = 0;

        for (uint256 i = 0; i < proposals.length; i++) {
            if (proposals[i].status == ProposalStatus.ACTIVE && block.timestamp <= proposals[i].endTime) {
                activeProposals[index] = i;
                index++;
            }
        }

        return activeProposals;
    }

    /**
     * @dev Check if user has voted on a proposal
     * @param _proposalId Proposal ID
     * @param _user User address
     * @return bool indicating if user has voted
     */
    function hasUserVoted(uint256 _proposalId, address _user) external view returns (bool) {
        return hasVoted[_proposalId][_user];
    }

    /**
     * @dev Get user's vote on a proposal
     * @param _proposalId Proposal ID
     * @param _user User address
     * @return VoteOption chosen by user
     */
    function getUserVote(uint256 _proposalId, address _user) external view returns (VoteOption) {
        require(hasVoted[_proposalId][_user], "User has not voted");
        return userVotes[_proposalId][_user];
    }

    /**
     * @dev Check if user can create a proposal (not in cooldown)
     * @param _user User address
     * @return bool indicating if user can create proposal
     */
    function canCreateProposal(address _user) external view returns (bool) {
        if (!proposalCreationOpen && _user != admin) {
            return false;
        }
        return block.timestamp >= lastProposalTime[_user] + PROPOSAL_COOLDOWN;
    }

    /**
     * @dev Get total number of proposals
     * @return Total proposal count
     */
    function getTotalProposals() external view returns (uint256) {
        return totalProposals;
    }

    /**
     * @dev Get voting statistics for a proposal
     * @param _proposalId Proposal ID
     * @return yesVotes Number of yes votes
     * @return noVotes Number of no votes
     * @return abstainVotes Number of abstain votes
     * @return totalVotes Total number of votes
     */
    function getVotingStats(uint256 _proposalId)
        external
        view
        validProposal(_proposalId)
        returns (uint256 yesVotes, uint256 noVotes, uint256 abstainVotes, uint256 totalVotes)
    {
        Proposal memory proposal = proposals[_proposalId];
        return (proposal.yesVotes, proposal.noVotes, proposal.abstainVotes, proposal.totalVotes);
    }
}
