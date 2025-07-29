// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {RiddleHunt7} from "../../src/Week7/RiddleHunt7.sol";

contract DeployRiddleHunt7 is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the RiddleHunt7 contract
        address riddleHunt7Contract = address(new RiddleHunt7("ASTRALIS"));

        console2.log("RiddleHunt7 deployed at:", riddleHunt7Contract);

        vm.stopBroadcast();
    }
}
