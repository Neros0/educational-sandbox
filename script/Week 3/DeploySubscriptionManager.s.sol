// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {SubscriptionManager} from "../../src/Week 3/SubscriptionManager.sol";

contract DeploySubscriptionManager is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the SubscriptionManager contract
        address subscriptionManager = address(new SubscriptionManager());

        console2.log("SubscriptionManager deployed at:", subscriptionManager);

        vm.stopBroadcast();
    }
}
