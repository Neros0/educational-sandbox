// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// 2. Simple Name Registry - First come, first served
contract NameRegistry {
    mapping(bytes32 => address) public nameToAddress;
    mapping(address => bytes32) public addressToName;
}
