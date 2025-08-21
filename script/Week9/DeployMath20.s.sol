// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {MathChallenge20} from "../../src/Week10/MathChallenge20.sol";

contract DeployMath20 is Script {
    function run() external {
        vm.startBroadcast();
        // Deploy the MathChallenge20 contract
        address mathChallengeContract = address(new MathChallenge20());

        console2.log("MathChallenge20 deployed at:", mathChallengeContract);

        vm.stopBroadcast();
    }
}
