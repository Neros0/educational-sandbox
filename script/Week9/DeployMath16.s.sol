// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {MathChallenge16} from "../../src/Week10/MathChallenge16.sol";

contract DeployMath16 is Script {
    function run() external {
        vm.startBroadcast();
        // Deploy the MathChallenge16 contract
        address mathChallengeContract = address(new MathChallenge16());

        console2.log("MathChallenge16 deployed at:", mathChallengeContract);

        vm.stopBroadcast();
    }
}
