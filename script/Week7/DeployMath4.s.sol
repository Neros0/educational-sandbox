// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {MathChallenge4} from "../../src/Week8/MathChallenge4.sol";

contract DeployMath4 is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the MathChallenge4 contract
        address mathChallengeContract = address(new MathChallenge4());

        console2.log("MathChallenge4 deployed at:", mathChallengeContract);

        vm.stopBroadcast();
    }
}
