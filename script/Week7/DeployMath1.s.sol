// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {MathChallenge1} from "../../src/MathChallenge1.sol";

contract DeployMath1 is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the MathChallenge1 contract
        address mathChallengeContract = address(new MathChallenge1());

        console2.log("MathChallenge1 deployed at:", mathChallengeContract);

        vm.stopBroadcast();
    }
}
