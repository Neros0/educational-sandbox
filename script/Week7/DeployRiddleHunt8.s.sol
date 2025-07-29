// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {RiddleHunt8} from "../../src/Week7/RiddleHunt8.sol";

contract DeployRiddleHunt8 is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the RiddleHunt8 contract
        address riddleHunt8Contract = address(new RiddleHunt8("Bambiraptor"));

        console2.log("RiddleHunt8 deployed at:", riddleHunt8Contract);

        vm.stopBroadcast();
    }
}
