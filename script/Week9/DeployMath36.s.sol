// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {MathChallenge36} from "../../src/Week10/MathChallenge36.sol";

contract DeployMath36 is Script {
    function run() external {
        vm.startBroadcast();
        // Deploy the MathChallenge36 contract
        address mathChallengeContract = address(new MathChallenge36());

        console2.log("MathChallenge36 deployed at:", mathChallengeContract);

        vm.stopBroadcast();
    }
}
