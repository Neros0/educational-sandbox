// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {MathChallenge18} from "../../src/Week10/MathChallenge18.sol";

contract DeployMath18 is Script {
    function run() external {
        vm.startBroadcast();
        // Deploy the MathChallenge18 contract
        address mathChallengeContract = address(new MathChallenge18());

        console2.log("MathChallenge18 deployed at:", mathChallengeContract);

        vm.stopBroadcast();
    }
}
