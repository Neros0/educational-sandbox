// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {MathChallenge14} from "../../src/Week9/MathChallenge14.sol";

contract DeployMath14 is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the MathChallenge14 contract
        address mathChallengeContract = address(new MathChallenge14());

        console2.log("MathChallenge14 deployed at:", mathChallengeContract);

        vm.stopBroadcast();
    }
}
