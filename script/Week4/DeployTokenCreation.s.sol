// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {TokenFactory} from "../../src/Week4/TokenCreation.sol";

contract DeployTokenFactory is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the TokenFactory contract
        address tokenFactory = address(new TokenFactory(msg.sender));

        console2.log("TokenFactory deployed at:", tokenFactory);

        vm.stopBroadcast();
    }
}
