// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {LotteryContract} from "../../src/Week4/LotteryContract.sol";

contract DeployLotteryContract is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the LotteryContract contract
        address lotteryContract = address(new LotteryContract());

        console2.log("LotteryContract deployed at:", lotteryContract);

        vm.stopBroadcast();
    }
}
