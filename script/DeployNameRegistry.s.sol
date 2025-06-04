// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {NameRegistry} from "../src/Week 1/NameRegistry.sol";

contract DeployNameRegistry is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the NameRegistry contract
        address nameRegistry = address(new NameRegistry());

        console2.log("NameRegistry deployed at:", nameRegistry);

        vm.stopBroadcast();
    }
}
