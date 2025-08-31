// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {MathChallenge31} from "../../src/Week10/MathChallenge31.sol";

contract DeployMath31 is Script {
    function run() external {
        vm.startBroadcast();
        // Deploy the MathChallenge31 contract
        address mathChallengeContract = address(new MathChallenge31());

        console2.log("MathChallenge31 deployed at:", mathChallengeContract);

        vm.stopBroadcast();
    }
}
