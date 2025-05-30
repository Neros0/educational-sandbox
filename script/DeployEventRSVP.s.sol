// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {EventRSVP} from "../src/EventRSVP.sol";

contract DeployEventRSVP is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the EventRSVP contract
        address eventRSVP = address(new EventRSVP());

        console2.log("EventRSVP deployed at:", eventRSVP);

        vm.stopBroadcast();
    }
}
