// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {RiddleHunt2} from "../../src/Week6/RiddleHunt2.sol";

contract DeployRiddleHunt2 is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the RiddleHunt2 contract
        address riddleHunt2Contract = address(new RiddleHunt2("ECHO"));

        console2.log("RiddleHunt2 deployed at:", riddleHunt2Contract);

        vm.stopBroadcast();
    }
}
