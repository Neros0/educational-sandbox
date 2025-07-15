// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {TokenVault} from "../../src/Week4/TokenVault.sol";

contract DeployTokenVault is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the TokenVault contract
        address tokenVault = address(new TokenVault(msg.sender));

        console2.log("TokenVault deployed at:", tokenVault);

        vm.stopBroadcast();
    }
}
