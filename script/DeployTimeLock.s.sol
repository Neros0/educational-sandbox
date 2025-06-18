// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {TimeLock} from "../src/Week 3/TimeLock.sol";

contract DeployTimeLock is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the TimeLock contract
        address timeLock = address(new TimeLock());

        console2.log("TimeLock deployed at:", timeLock);

        vm.stopBroadcast();
    }
}
