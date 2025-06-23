// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {AccessControl} from "../../src/Week3/AccessControl.sol";

contract DeployAccessControl is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the AccessControl contract
        address accessControl = address(new AccessControl());

        console2.log("AccessControl deployed at:", accessControl);

        vm.stopBroadcast();
    }
}
