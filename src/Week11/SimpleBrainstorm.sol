// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SimpleBrainstorm {
    string constant VERSION = "1.0.15";

    struct Campaign {
        address creator;
        string title;
        string description;
        uint256 fundingGoal;
        uint256 deadline;
        bool isActive;
    }

    mapping(uint256 => Campaign) public campaigns;
    uint256 public campaignCount;

    event CampaignCreated(
        uint256 indexed campaignId, address indexed creator, string title, uint256 fundingGoal, uint256 deadline
    );

    function createCampaign(
        string memory _title,
        string memory _description,
        uint256 _fundingGoal,
        uint256 _durationInDays
    ) external returns (uint256) {
        require(_fundingGoal > 0, "Funding goal must be greater than 0");
        require(_durationInDays > 0, "Duration must be greater than 0");

        uint256 campaignId = campaignCount;

        campaigns[campaignId] = Campaign({
            creator: msg.sender,
            title: _title,
            description: _description,
            fundingGoal: _fundingGoal,
            deadline: block.timestamp + (_durationInDays * 1 days),
            isActive: true
        });

        campaignCount++;

        emit CampaignCreated(campaignId, msg.sender, _title, _fundingGoal, campaigns[campaignId].deadline);

        return campaignId;
    }

    function getCampaignInfo(uint256 _campaignId)
        external
        view
        returns (
            address creator,
            string memory title,
            string memory description,
            uint256 fundingGoal,
            uint256 deadline,
            bool isActive
        )
    {
        require(_campaignId < campaignCount, "Campaign does not exist");
        Campaign memory campaign = campaigns[_campaignId];
        return (
            campaign.creator,
            campaign.title,
            campaign.description,
            campaign.fundingGoal,
            campaign.deadline,
            campaign.isActive
        );
    }
}
