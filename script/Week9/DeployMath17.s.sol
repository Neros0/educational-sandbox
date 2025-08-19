// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {MathChallenge17} from "../../src/Week10/MathChallenge17.sol";

contract DeployMath17 is Script {
    function run() external {
        vm.startBroadcast();
        // Deploy the MathChallenge17 contract
        address mathChallengeContract = address(new MathChallenge17());

        console2.log("MathChallenge17 deployed at:", mathChallengeContract);

        vm.stopBroadcast();
    }
}
