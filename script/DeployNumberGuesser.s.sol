// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {NumberGuesser} from "../src/NumberGuesser.sol";

contract DeployNNumberGuesser is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the NumberGuesser contract
        address numberGuesser = address(new NumberGuesser(99999999999999999999999999));

        console2.log("NumberGuesser deployed at:", numberGuesser);

        vm.stopBroadcast();
    }
}
