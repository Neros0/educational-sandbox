// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {SimpleBrainstorm} from "../../src/Week11/SimpleBrainstorm.sol";

contract DeploySimpleBrainstorm is Script {
    function run() external {
        vm.startBroadcast();
        // Deploy the SimpleBrainstorm contract
        address brainstorming = address(new SimpleBrainstorm());

        console2.log("SimpleBrainstorm deployed at:", brainstorming);

        vm.stopBroadcast();
    }
}
