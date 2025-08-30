// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {MathChallenge26} from "../../src/Week10/MathChallenge26.sol";

contract DeployMath26 is Script {
    function run() external {
        vm.startBroadcast();
        // Deploy the MathChallenge26 contract
        address mathChallengeContract = address(new MathChallenge26());

        console2.log("MathChallenge26 deployed at:", mathChallengeContract);

        vm.stopBroadcast();
    }
}
