// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {SimpleStaking} from "../src/SimpleStaking.sol";

contract DeploySimpleStaking is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the SimpleStaking contract
        address simpleStaking = address(new SimpleStaking());

        console2.log("SimpleStaking deployed at:", simpleStaking);

        vm.stopBroadcast();
    }
}
