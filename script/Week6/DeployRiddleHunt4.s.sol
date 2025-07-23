// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {RiddleHunt4} from "../../src/Week6/RiddleHunt4.sol";

contract DeployRiddleHunt4 is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the RiddleHunt4 contract
        address riddleHunt4Contract = address(new RiddleHunt4("AQUA"));

        console2.log("RiddleHunt4 deployed at:", riddleHunt4Contract);

        vm.stopBroadcast();
    }
}
