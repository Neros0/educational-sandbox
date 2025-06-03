// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {MessageWall} from "../src/MessageWall.sol";

contract DeployMessageWall is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the MessageWall contract
        address messageWall = address(new MessageWall());

        console2.log("MessageWall deployed at:", messageWall);

        vm.stopBroadcast();
    }
}
