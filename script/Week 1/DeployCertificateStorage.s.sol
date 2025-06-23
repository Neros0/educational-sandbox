// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {CertificateStorage} from "../../src/Week 1/CertificateStorage.sol";

contract DeployCertificateStorage is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the CertificateStorage contract
        address certificateStorage = address(new CertificateStorage());

        console2.log("CertificateStorage deployed at:", certificateStorage);

        vm.stopBroadcast();
    }
}
