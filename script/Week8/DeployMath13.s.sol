// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {MathChallenge13} from "../../src/Week9/MathChallenge13.sol";

contract DeployMath13 is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the MathChallenge13 contract
        address mathChallengeContract = address(new MathChallenge13());

        console2.log("MathChallenge13 deployed at:", mathChallengeContract);

        vm.stopBroadcast();
    }
}
