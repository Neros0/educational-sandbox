// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {MathChallenge19} from "../../src/Week10/MathChallenge19.sol";

contract DeployMath19 is Script {
    function run() external {
        vm.startBroadcast();
        // Deploy the MathChallenge19 contract
        address mathChallengeContract = address(new MathChallenge19());

        console2.log("MathChallenge19 deployed at:", mathChallengeContract);

        vm.stopBroadcast();
    }
}
