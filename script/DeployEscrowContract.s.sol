// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {EscrowContract} from "../src/Week 4/EscrowContract.sol";

contract DeployEscrowContract is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the EscrowContract contract
        address escrowContract = address(new EscrowContract());

        console2.log("EscrowContract deployed at:", escrowContract);

        vm.stopBroadcast();
    }
}
