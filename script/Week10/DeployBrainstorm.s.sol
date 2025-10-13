// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {Brainstorm} from "../../src/Week11/Brainstorm.sol";

contract DeployBrainstorm is Script {
    function run() external {
        vm.startBroadcast();
        // Deploy the Brainstorm contract
        address brainstorming = address(new Brainstorm());

        console2.log("Brainstorm deployed at:", brainstorming);

        vm.stopBroadcast();
    }
}
