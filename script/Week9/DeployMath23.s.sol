// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {MathChallenge23} from "../../src/Week10/MathChallenge23.sol";

contract DeployMath23 is Script {
    function run() external {
        vm.startBroadcast();
        // Deploy the MathChallenge23 contract
        address mathChallengeContract = address(new MathChallenge23());

        console2.log("MathChallenge23 deployed at:", mathChallengeContract);

        vm.stopBroadcast();
    }
}
