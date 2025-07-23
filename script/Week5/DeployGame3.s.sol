// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {Game3} from "../../src/Week5/Game3.sol";

contract DeployGame3 is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the Game3 contract
        address game3Contract = address(new Game3());

        console2.log("Game3 deployed at:", game3Contract);

        vm.stopBroadcast();
    }
}
