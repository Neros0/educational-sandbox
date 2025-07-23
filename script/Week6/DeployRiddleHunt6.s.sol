// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {RiddleHunt6} from "../../src/Week6/RiddleHunt6.sol";

contract DeployRiddleHunt6 is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the RiddleHunt6 contract
        address riddleHunt6Contract = address(new RiddleHunt6("REAL MADRID"));

        console2.log("RiddleHunt6 deployed at:", riddleHunt6Contract);

        vm.stopBroadcast();
    }
}
