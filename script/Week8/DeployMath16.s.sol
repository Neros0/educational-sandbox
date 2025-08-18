// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {MathChallenge15} from "../../src/Week9/MathChallenge15.sol";

contract DeployMath15 is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the MathChallenge15 contract
        address mathChallengeContract = address(new MathChallenge15());

        console2.log("MathChallenge15 deployed at:", mathChallengeContract);

        vm.stopBroadcast();
    }
}
