// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {PersonalRegistry} from "../../src/Week 1/PersonalRegistry.sol";

contract DeployPersonalRegistry is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the PersonalRegistry contract
        address personalRegistry = address(new PersonalRegistry());

        console2.log("PersonalRegistry deployed at:", personalRegistry);

        vm.stopBroadcast();
    }
}
