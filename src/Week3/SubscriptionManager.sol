// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SubscriptionManager {
    struct Subscription {
        uint256 price;
        uint256 duration;
        bool active;
    }

    struct UserSubscription {
        uint256 planId;
        uint256 expiresAt;
        bool active;
    }

    mapping(uint256 => Subscription) public plans;
    mapping(address => UserSubscription) public userSubscriptions;
    mapping(address => uint256) public balances;
    uint256 public planCount;
    address public admin;

    constructor() {
        admin = msg.sender;
    }

    function createPlan(uint256 _price, uint256 _duration) external {
        plans[planCount] = Subscription({price: _price, duration: _duration, active: true});
        planCount++;
    }

    function subscribe(uint256 _planId) external payable {
        Subscription memory plan = plans[_planId];
        require(plan.active, "Plan not active");
        require(msg.value >= plan.price, "Insufficient payment");

        uint256 newExpiry = block.timestamp + plan.duration;
        if (userSubscriptions[msg.sender].active && userSubscriptions[msg.sender].expiresAt > block.timestamp) {
            // Extend existing subscription
            newExpiry = userSubscriptions[msg.sender].expiresAt + plan.duration;
        }

        userSubscriptions[msg.sender] = UserSubscription({planId: _planId, expiresAt: newExpiry, active: true});

        balances[admin] += plan.price;

        // Refund excess
        if (msg.value > plan.price) {
            payable(msg.sender).transfer(msg.value - plan.price);
        }
    }

    function isSubscriptionActive(address _user) external view returns (bool) {
        return userSubscriptions[_user].active && userSubscriptions[_user].expiresAt > block.timestamp;
    }

    function withdraw() external {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "No balance");
        balances[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    receive() external payable {}
}
