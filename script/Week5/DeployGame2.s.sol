// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {Game2} from "../../src/Week5/Game2.sol";

contract DeployGame2 is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the Game2 contract
        address game2Contract = address(new Game2());

        console2.log("Game2 deployed at:", game2Contract);

        vm.stopBroadcast();
    }
}
