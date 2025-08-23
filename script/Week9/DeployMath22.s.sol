// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {MathChallenge22} from "../../src/Week10/MathChallenge22.sol";

contract DeployMath22 is Script {
    function run() external {
        vm.startBroadcast();
        // Deploy the MathChallenge22 contract
        address mathChallengeContract = address(new MathChallenge22());

        console2.log("MathChallenge22 deployed at:", mathChallengeContract);

        vm.stopBroadcast();
    }
}
