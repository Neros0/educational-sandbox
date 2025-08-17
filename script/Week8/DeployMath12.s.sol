// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {MathChallenge12} from "../../src/Week9/MathChallenge12.sol";

contract DeployMath12 is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the MathChallenge12 contract
        address mathChallengeContract = address(new MathChallenge12());

        console2.log("MathChallenge12 deployed at:", mathChallengeContract);

        vm.stopBroadcast();
    }
}
