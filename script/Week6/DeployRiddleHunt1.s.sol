// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {RiddleHunt1} from "../../src/Week6/RiddleHunt1.sol";

contract DeployRiddleHunt1 is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the RiddleHunt1 contract
        address riddleHunt1Contract = address(new RiddleHunt1("WORD"));

        console2.log("RiddleHunt1 deployed at:", riddleHunt1Contract);

        vm.stopBroadcast();
    }
}
