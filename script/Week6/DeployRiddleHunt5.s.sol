// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {RiddleHunt5} from "../../src/Week6/RiddleHunt5.sol";

contract DeployRiddleHunt5 is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the RiddleHunt5 contract
        address riddleHunt5Contract = address(new RiddleHunt5("BLUEBERRY"));

        console2.log("RiddleHunt5 deployed at:", riddleHunt5Contract);

        vm.stopBroadcast();
    }
}
