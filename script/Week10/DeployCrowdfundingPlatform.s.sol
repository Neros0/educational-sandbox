// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {CrowdfundingPlatform} from "../../src/Week11/CrowdfundingPlatform.sol";

contract DeployCrowdfundingPlatform is Script {
    function run() external {
        vm.startBroadcast();
        // Deploy the CrowdfundingPlatform contract
        address crowdfundingPlatform = address(new CrowdfundingPlatform());

        console2.log("CrowdfundingPlatform deployed at:", crowdfundingPlatform);

        vm.stopBroadcast();
    }
}
