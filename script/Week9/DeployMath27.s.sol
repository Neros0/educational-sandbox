// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {MathChallenge27} from "../../src/Week10/MathChallenge27.sol";

contract DeployMath27 is Script {
    function run() external {
        vm.startBroadcast();
        // Deploy the MathChallenge27 contract
        address mathChallengeContract = address(new MathChallenge27());

        console2.log("MathChallenge27 deployed at:", mathChallengeContract);

        vm.stopBroadcast();
    }
}
