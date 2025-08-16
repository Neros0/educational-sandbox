// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {MathChallenge2} from "../../src/Week8/MathChallenge2.sol";

contract DeployMath2 is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the MathChallenge2 contract
        address mathChallengeContract = address(new MathChallenge2());

        console2.log("MathChallenge2 deployed at:", mathChallengeContract);

        vm.stopBroadcast();
    }
}
