// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {MathChallenge9} from "../../src/Week9/MathChallenge9.sol";

contract DeployMath9 is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the MathChallenge9 contract
        address mathChallengeContract = address(new MathChallenge9());

        console2.log("MathChallenge9 deployed at:", mathChallengeContract);

        vm.stopBroadcast();
    }
}
