// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {GuestBook} from "../src/GuestBook.sol";

contract DeployGuestBook is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the Guestbook contract
        address guestbook = address(new GuestBook());

        console2.log("Guestbook deployed at:", guestbook);

        vm.stopBroadcast();
    }
}
