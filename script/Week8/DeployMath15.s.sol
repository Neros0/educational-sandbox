// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {MathChallenge7} from "../../src/Week8/MathChallenge7.sol";

contract DeployMath7 is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the MathChallenge7 contract
        address mathChallengeContract = address(new MathChallenge7());

        console2.log("MathChallenge7 deployed at:", mathChallengeContract);

        vm.stopBroadcast();
    }
}
