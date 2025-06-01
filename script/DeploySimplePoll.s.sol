// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {SimplePoll} from "../src/SimplePoll.sol";

contract DeploySimplePoll is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the SimplePoll contract
        address simplePoll = address(new SimplePoll("Will it be green?"));

        console2.log("SimplePoll deployed at:", simplePoll);

        vm.stopBroadcast();
    }
}
