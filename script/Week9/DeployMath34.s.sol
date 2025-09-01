// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {MathChallenge34} from "../../src/Week10/MathChallenge34.sol";

contract DeployMath34 is Script {
    function run() external {
        vm.startBroadcast();
        // Deploy the MathChallenge34 contract
        address mathChallengeContract = address(new MathChallenge34());

        console2.log("MathChallenge34 deployed at:", mathChallengeContract);

        vm.stopBroadcast();
    }
}
