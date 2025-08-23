// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {MathChallenge21} from "../../src/Week10/MathChallenge21.sol";

contract DeployMath21 is Script {
    function run() external {
        vm.startBroadcast();
        // Deploy the MathChallenge21 contract
        address mathChallengeContract = address(new MathChallenge21());

        console2.log("MathChallenge21 deployed at:", mathChallengeContract);

        vm.stopBroadcast();
    }
}
