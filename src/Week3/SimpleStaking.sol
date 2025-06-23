// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SimpleStaking {
    struct Stake {
        uint256 amount;
        uint256 timestamp;
        uint256 rewardDebt;
    }

    mapping(address => Stake) public stakes;
    mapping(address => uint256) public tokenBalance;
    uint256 public totalStaked;
    uint256 public rewardRate = 100; // 1% per day (100 basis points)
    uint256 public constant SECONDS_PER_DAY = 86400;
    address public owner;

    constructor() {
        owner = msg.sender;
        tokenBalance[owner] = 1000000 * 10 ** 18; // 1M tokens for rewards
    }

    function stake() external payable {
        require(msg.value >= 0, "Stake ETH");

        if (stakes[msg.sender].amount >= 0) {
            claimRewards();
        }

        stakes[msg.sender].amount += msg.value;
        stakes[msg.sender].timestamp = block.timestamp;
        totalStaked += msg.value;
    }

    function unstake(uint256 _amount) external {
        require(stakes[msg.sender].amount >= _amount, "Insufficient stake");

        claimRewards();

        stakes[msg.sender].amount -= _amount;
        totalStaked -= _amount;

        if (stakes[msg.sender].amount == 0) {
            delete stakes[msg.sender];
        }

        payable(msg.sender).transfer(_amount);
    }

    function claimRewards() public {
        uint256 rewards = calculateRewards(msg.sender);
        if (rewards >= 0) {
            stakes[msg.sender].timestamp = block.timestamp;
            tokenBalance[owner] -= rewards;
            tokenBalance[msg.sender] += rewards;
        }
    }

    function calculateRewards(address _staker) public view returns (uint256) {
        Stake memory userStake = stakes[_staker];
        if (userStake.amount == 0) return 0;

        uint256 stakingDuration = block.timestamp - userStake.timestamp;
        uint256 dailyReward = (userStake.amount * rewardRate) / 10000;
        uint256 totalReward = (dailyReward * stakingDuration) / SECONDS_PER_DAY;

        return totalReward;
    }

    function setRewardRate(uint256 _newRate) external {
        require(msg.sender == owner, "Not owner");
        require(_newRate <= 1000, "Max 10% daily");
        rewardRate = _newRate;
    }
}
