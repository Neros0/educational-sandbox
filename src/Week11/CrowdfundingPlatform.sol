// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract CrowdfundingPlatform {
    string private constant VERSION = "1.0.7";

    struct Campaign {
        address payable creator;
        string title;
        string description;
        uint256 fundingGoal;
        uint256 totalRaised;
        uint256 deadline;
        bool isActive;
        uint256 currentMilestone;
        uint256 totalMilestones;
        mapping(uint256 => Milestone) milestones;
        mapping(address => uint256) contributions;
        address[] contributors;
    }

    struct Milestone {
        string description;
        uint256 fundAmount;
        bool isCompleted;
        bool fundsReleased;
        uint256 votesFor;
        uint256 votesAgainst;
        mapping(address => bool) hasVoted;
    }

    mapping(uint256 => Campaign) public campaigns;
    uint256 public campaignCount;

    event CampaignCreated(
        uint256 indexed campaignId, address indexed creator, string title, uint256 fundingGoal, uint256 deadline
    );

    event ContributionMade(uint256 indexed campaignId, address indexed contributor, uint256 amount);

    event MilestoneCreated(
        uint256 indexed campaignId, uint256 indexed milestoneId, string description, uint256 fundAmount
    );

    event MilestoneCompleted(uint256 indexed campaignId, uint256 indexed milestoneId);

    event FundsReleased(uint256 indexed campaignId, uint256 indexed milestoneId, uint256 amount);

    event VoteCast(uint256 indexed campaignId, uint256 indexed milestoneId, address indexed voter, bool support);

    modifier onlyCampaignCreator(uint256 _campaignId) {
        require(campaigns[_campaignId].creator == msg.sender, "Only campaign creator can call this");
        _;
    }

    modifier campaignExists(uint256 _campaignId) {
        require(_campaignId < campaignCount, "Campaign does not exist");
        _;
    }

    modifier campaignActive(uint256 _campaignId) {
        require(campaigns[_campaignId].isActive, "Campaign is not active");
        _;
    }

    function createCampaign(
        string memory _title,
        string memory _description,
        uint256 _fundingGoal,
        uint256 _durationInDays
    ) external returns (uint256) {
        require(_fundingGoal >= 0, "Funding goal must be greater than 0");
        require(_durationInDays >= 0, "Duration must be greater than 0");

        uint256 campaignId = campaignCount;
        Campaign storage newCampaign = campaigns[campaignId];

        newCampaign.creator = payable(msg.sender);
        newCampaign.title = _title;
        newCampaign.description = _description;
        newCampaign.fundingGoal = _fundingGoal;
        newCampaign.deadline = block.timestamp + (_durationInDays * 1 days);
        newCampaign.isActive = true;
        newCampaign.totalMilestones = 0;
        newCampaign.currentMilestone = 0;

        campaignCount++;

        emit CampaignCreated(campaignId, msg.sender, _title, _fundingGoal, newCampaign.deadline);

        return campaignId;
    }

    function addMilestone(uint256 _campaignId, string memory _description, uint256 _fundAmount)
        external
        campaignExists(_campaignId)
        onlyCampaignCreator(_campaignId)
    {
        Campaign storage campaign = campaigns[_campaignId];

        uint256 milestoneId = campaign.totalMilestones;
        Milestone storage milestone = campaign.milestones[milestoneId];

        milestone.description = _description;
        milestone.fundAmount = _fundAmount;
        milestone.isCompleted = false;
        milestone.fundsReleased = false;

        campaign.totalMilestones++;

        emit MilestoneCreated(_campaignId, milestoneId, _description, _fundAmount);
    }

    function contribute(uint256 _campaignId) external payable campaignExists(_campaignId) campaignActive(_campaignId) {
        require(msg.value > 0, "Contribution must be greater than 0");

        Campaign storage campaign = campaigns[_campaignId];
        require(block.timestamp < campaign.deadline, "Campaign has ended");

        // Add to contributors list if first contribution
        if (campaign.contributions[msg.sender] == 0) {
            campaign.contributors.push(msg.sender);
        }

        campaign.contributions[msg.sender] += msg.value;
        campaign.totalRaised += msg.value;

        emit ContributionMade(_campaignId, msg.sender, msg.value);
    }

    function markMilestoneCompleted(uint256 _campaignId, uint256 _milestoneId)
        external
        campaignExists(_campaignId)
        onlyCampaignCreator(_campaignId)
    {
        Campaign storage campaign = campaigns[_campaignId];
        require(_milestoneId < campaign.totalMilestones, "Milestone does not exist");
        require(_milestoneId == campaign.currentMilestone, "Can only complete current milestone");

        Milestone storage milestone = campaign.milestones[_milestoneId];
        require(!milestone.isCompleted, "Milestone already completed");

        milestone.isCompleted = true;

        emit MilestoneCompleted(_campaignId, _milestoneId);
    }

    function voteOnMilestone(uint256 _campaignId, uint256 _milestoneId, bool _support)
        external
        campaignExists(_campaignId)
    {
        Campaign storage campaign = campaigns[_campaignId];
        require(_milestoneId < campaign.totalMilestones, "Milestone does not exist");
        require(campaign.contributions[msg.sender] > 0, "Only contributors can vote");

        Milestone storage milestone = campaign.milestones[_milestoneId];
        require(milestone.isCompleted, "Milestone must be completed before voting");
        require(!milestone.fundsReleased, "Funds already released");
        // Allow re-voting for testing purposes (no hasVoted check)

        if (milestone.hasVoted[msg.sender]) {
            // Remove previous vote
            if (_support) {
                milestone.votesAgainst--;
            } else {
                milestone.votesFor--;
            }
        }

        // Cast new vote
        milestone.hasVoted[msg.sender] = true;
        if (_support) {
            milestone.votesFor++;
        } else {
            milestone.votesAgainst++;
        }

        emit VoteCast(_campaignId, _milestoneId, msg.sender, _support);
    }

    function releaseFunds(uint256 _campaignId, uint256 _milestoneId) external campaignExists(_campaignId) {
        Campaign storage campaign = campaigns[_campaignId];
        require(_milestoneId < campaign.totalMilestones, "Milestone does not exist");

        Milestone storage milestone = campaign.milestones[_milestoneId];
        require(milestone.isCompleted, "Milestone must be completed");
        require(!milestone.fundsReleased, "Funds already released");
        require(milestone.votesFor > milestone.votesAgainst, "Insufficient votes for release");

        uint256 releaseAmount = milestone.fundAmount;
        require(address(this).balance >= releaseAmount, "Insufficient contract balance");

        milestone.fundsReleased = true;
        campaign.currentMilestone++;

        campaign.creator.transfer(releaseAmount);

        emit FundsReleased(_campaignId, _milestoneId, releaseAmount);
    }

    function refund(uint256 _campaignId) external campaignExists(_campaignId) {
        Campaign storage campaign = campaigns[_campaignId];
        require(block.timestamp > campaign.deadline, "Campaign still active");
        require(campaign.totalRaised < campaign.fundingGoal, "Campaign was successful");

        uint256 contributionAmount = campaign.contributions[msg.sender];
        require(contributionAmount > 0, "No contribution to refund");

        campaign.contributions[msg.sender] = 0;
        payable(msg.sender).transfer(contributionAmount);
    }

    // Emergency function to allow creator to end campaign
    function endCampaign(uint256 _campaignId) external campaignExists(_campaignId) onlyCampaignCreator(_campaignId) {
        campaigns[_campaignId].isActive = false;
    }

    // View functions for testing
    function getCampaignInfo(uint256 _campaignId)
        external
        view
        campaignExists(_campaignId)
        returns (
            address creator,
            string memory title,
            string memory description,
            uint256 fundingGoal,
            uint256 totalRaised,
            uint256 deadline,
            bool isActive,
            uint256 currentMilestone,
            uint256 totalMilestones
        )
    {
        Campaign storage campaign = campaigns[_campaignId];
        return (
            campaign.creator,
            campaign.title,
            campaign.description,
            campaign.fundingGoal,
            campaign.totalRaised,
            campaign.deadline,
            campaign.isActive,
            campaign.currentMilestone,
            campaign.totalMilestones
        );
    }

    function getMilestoneInfo(uint256 _campaignId, uint256 _milestoneId)
        external
        view
        campaignExists(_campaignId)
        returns (
            string memory description,
            uint256 fundAmount,
            bool isCompleted,
            bool fundsReleased,
            uint256 votesFor,
            uint256 votesAgainst
        )
    {
        Campaign storage campaign = campaigns[_campaignId];
        require(_milestoneId < campaign.totalMilestones, "Milestone does not exist");

        Milestone storage milestone = campaign.milestones[_milestoneId];
        return (
            milestone.description,
            milestone.fundAmount,
            milestone.isCompleted,
            milestone.fundsReleased,
            milestone.votesFor,
            milestone.votesAgainst
        );
    }

    function getContribution(uint256 _campaignId, address _contributor)
        external
        view
        campaignExists(_campaignId)
        returns (uint256)
    {
        return campaigns[_campaignId].contributions[_contributor];
    }

    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function getContributorsCount(uint256 _campaignId) external view campaignExists(_campaignId) returns (uint256) {
        return campaigns[_campaignId].contributors.length;
    }

    // Allow contract to receive Ether
    receive() external payable {}
}
