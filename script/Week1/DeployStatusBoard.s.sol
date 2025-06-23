// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {StatusBoard} from "../../src/Week1/StatusBoard.sol";

contract DeployStatusBoard is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the StatusBoard contract
        address statusBoard = address(new StatusBoard());

        console2.log("StatusBoard deployed at:", statusBoard);

        vm.stopBroadcast();
    }
}
