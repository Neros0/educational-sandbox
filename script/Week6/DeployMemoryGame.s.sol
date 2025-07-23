// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {MemoryGame} from "../../src/Week6/MemoryGame.sol";

contract DeployMemoryGame is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the MemoryGame contract
        address memoryGameContract = address(new MemoryGame());

        console2.log("MemoryGame deployed at:", memoryGameContract);

        vm.stopBroadcast();
    }
}
