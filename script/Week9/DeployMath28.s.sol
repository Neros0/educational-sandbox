// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {MathChallenge28} from "../../src/Week10/MathChallenge28.sol";

contract DeployMath28 is Script {
    function run() external {
        vm.startBroadcast();
        // Deploy the MathChallenge28 contract
        address mathChallengeContract = address(new MathChallenge28());

        console2.log("MathChallenge28 deployed at:", mathChallengeContract);

        vm.stopBroadcast();
    }
}
