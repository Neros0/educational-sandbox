// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {MathChallenge32} from "../../src/Week10/MathChallenge32.sol";

contract DeployMath32 is Script {
    function run() external {
        vm.startBroadcast();
        // Deploy the MathChallenge32 contract
        address mathChallengeContract = address(new MathChallenge32());

        console2.log("MathChallenge32 deployed at:", mathChallengeContract);

        vm.stopBroadcast();
    }
}
