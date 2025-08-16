// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {MathChallenge6} from "../../src/Week8/MathChallenge6.sol";

contract DeployMath6 is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the MathChallenge6 contract
        address mathChallengeContract = address(new MathChallenge6());

        console2.log("MathChallenge6 deployed at:", mathChallengeContract);

        vm.stopBroadcast();
    }
}
