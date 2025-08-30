// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {MathChallenge30} from "../../src/Week10/MathChallenge30.sol";

contract DeployMath30 is Script {
    function run() external {
        vm.startBroadcast();
        // Deploy the MathChallenge30 contract
        address mathChallengeContract = address(new MathChallenge30());

        console2.log("MathChallenge30 deployed at:", mathChallengeContract);

        vm.stopBroadcast();
    }
}
