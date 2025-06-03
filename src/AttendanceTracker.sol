// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract AttendanceTracker {
    mapping(bytes32 => mapping(address => bool)) public attendance;
}
