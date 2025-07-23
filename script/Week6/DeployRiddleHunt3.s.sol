// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {RiddleHunt3} from "../../src/Week6/RiddleHunt3.sol";

contract DeployRiddleHunt3 is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the RiddleHunt3 contract
        address riddleHunt3Contract = address(new RiddleHunt3("HEDGEHOG"));

        console2.log("RiddleHunt3 deployed at:", riddleHunt3Contract);

        vm.stopBroadcast();
    }
}
