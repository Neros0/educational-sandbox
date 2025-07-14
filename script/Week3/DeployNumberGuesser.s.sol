// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {NumberGuesser} from "../../src/Week3/NumberGuesser.sol";

contract DeployNumberGuesser is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the NumberGuesser contract
        address numberGuesser = address(new NumberGuesser());

        console2.log("NumberGuesser deployed at:", numberGuesser);

        vm.stopBroadcast();
    }
}
