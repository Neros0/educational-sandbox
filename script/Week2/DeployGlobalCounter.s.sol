// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {GlobalCounter} from "../../src/Week2/GlobalCounter.sol";

contract DeployGlobalCounter is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the GlobalCounter contract
        address globalCounter = address(new GlobalCounter());

        console2.log("GlobalCounter deployed at:", globalCounter);

        vm.stopBroadcast();
    }
}
