// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {MathChallenge33} from "../../src/Week10/MathChallenge33.sol";

contract DeployMath33 is Script {
    function run() external {
        vm.startBroadcast();
        // Deploy the MathChallenge33 contract
        address mathChallengeContract = address(new MathChallenge33());

        console2.log("MathChallenge33 deployed at:", mathChallengeContract);

        vm.stopBroadcast();
    }
}
