// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {MathChallenge5} from "../../src/Week8/MathChallenge5.sol";

contract DeployMath5 is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the MathChallenge5 contract
        address mathChallengeContract = address(new MathChallenge5());

        console2.log("MathChallenge5 deployed at:", mathChallengeContract);

        vm.stopBroadcast();
    }
}
