// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {Game1} from "../../src/Week5/Game1.sol";

contract DeployGame1 is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the Game1 contract
        address game1Contract = address(new Game1());

        console2.log("Game1 deployed at:", game1Contract);

        vm.stopBroadcast();
    }
}
