// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {MathChallenge8} from "../../src/Week9/MathChallenge8.sol";

contract DeployMath8 is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the MathChallenge8 contract
        address mathChallengeContract = address(new MathChallenge8());

        console2.log("MathChallenge8 deployed at:", mathChallengeContract);

        vm.stopBroadcast();
    }
}
