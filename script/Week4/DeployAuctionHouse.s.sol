// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {AuctionHouse} from "../../src/Week4/AuctionHouse.sol";

contract DeployAuctionHouse is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the AuctionHouse contract
        address auctionHouse = address(new AuctionHouse());

        console2.log("AuctionHouse deployed at:", auctionHouse);

        vm.stopBroadcast();
    }
}
