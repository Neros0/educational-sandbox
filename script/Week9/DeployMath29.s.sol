// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {MathChallenge29} from "../../src/Week10/MathChallenge29.sol";

contract DeployMath29 is Script {
    function run() external {
        vm.startBroadcast();
        // Deploy the MathChallenge29 contract
        address mathChallengeContract = address(new MathChallenge29());

        console2.log("MathChallenge29 deployed at:", mathChallengeContract);

        vm.stopBroadcast();
    }
}
