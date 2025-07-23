// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {SimpleNFT} from "../../src/Week4/SimpleNFT.sol";

contract DeploySimpleNFT is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the SimpleNFT contract
        address simpleNFT = address(new SimpleNFT("Simple Cantina NFT", "CNFT", "https://example.com/metadata", 0));

        console2.log("SimpleNFT deployed at:", simpleNFT);

        vm.stopBroadcast();
    }
}
