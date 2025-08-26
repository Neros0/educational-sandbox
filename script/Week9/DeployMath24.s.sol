// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {MathChallenge24} from "../../src/Week10/MathChallenge24.sol";

contract DeployMath24 is Script {
    function run() external {
        vm.startBroadcast();
        // Deploy the MathChallenge24 contract
        address mathChallengeContract = address(new MathChallenge24());

        console2.log("MathChallenge24 deployed at:", mathChallengeContract);

        vm.stopBroadcast();
    }
}
