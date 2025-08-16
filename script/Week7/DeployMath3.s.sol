// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {MathChallenge3} from "../../src/Week8/MathChallenge3.sol";

contract DeployMath3 is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the MathChallenge3 contract
        address mathChallengeContract = address(new MathChallenge3());

        console2.log("MathChallenge3 deployed at:", mathChallengeContract);

        vm.stopBroadcast();
    }
}
