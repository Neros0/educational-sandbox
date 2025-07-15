// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {TaskBounty} from "../../src/Week4/TaskBounty.sol";

contract DeployTaskBounty is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the TaskBounty contract
        address taskBounty = address(new TaskBounty());

        console2.log("TaskBounty deployed at:", taskBounty);

        vm.stopBroadcast();
    }
}
