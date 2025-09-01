// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {MathChallenge35} from "../../src/Week10/MathChallenge35.sol";

contract DeployMath35 is Script {
    function run() external {
        vm.startBroadcast();
        // Deploy the MathChallenge35 contract
        address mathChallengeContract = address(new MathChallenge35());

        console2.log("MathChallenge35 deployed at:", mathChallengeContract);

        vm.stopBroadcast();
    }
}
