// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {VotingSystem} from "../../src/Week1/VotingSystem.sol";

contract DeployVotingSystem is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the VotingSystem contract
        address votingSystem = address(new VotingSystem());

        console2.log("VotingSystem deployed at:", votingSystem);

        vm.stopBroadcast();
    }
}
