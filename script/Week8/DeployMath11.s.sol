// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {MathChallenge11} from "../../src/Week9/MathChallenge11.sol";

contract DeployMath11 is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the MathChallenge11 contract
        address mathChallengeContract = address(new MathChallenge11());

        console2.log("MathChallenge11 deployed at:", mathChallengeContract);

        vm.stopBroadcast();
    }
}
