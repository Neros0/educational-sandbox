// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {AttendanceTracker} from "../../src/Week2/AttendanceTracker.sol";

contract DeployAttendanceTracker is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the AttendanceTracker contract
        address attendanceTracker = address(new AttendanceTracker());

        console2.log("AttendanceTracker deployed at:", attendanceTracker);

        vm.stopBroadcast();
    }
}
