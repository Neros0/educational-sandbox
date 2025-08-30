// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {MathChallenge25} from "../../src/Week10/MathChallenge25.sol";

contract DeployMath25 is Script {
    function run() external {
        vm.startBroadcast();
        // Deploy the MathChallenge25 contract
        address mathChallengeContract = address(new MathChallenge25());

        console2.log("MathChallenge25 deployed at:", mathChallengeContract);

        vm.stopBroadcast();
    }
}
