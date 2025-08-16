// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {MathChallenge10} from "../../src/Week9/MathChallenge10.sol";

contract DeployMath10 is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the MathChallenge10 contract
        address mathChallengeContract = address(new MathChallenge10());

        console2.log("MathChallenge10 deployed at:", mathChallengeContract);

        vm.stopBroadcast();
    }
}
