// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {ReputationSystem} from "../../src/Week 1/ReputationSystem.sol";

contract DeployReputationSystem is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the ReputationSystem contract
        address reputationSystem = address(new ReputationSystem());

        console2.log("ReputationSystem deployed at:", reputationSystem);

        vm.stopBroadcast();
    }
}
