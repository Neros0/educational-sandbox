// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// 2. Simple Name Registry - First come, first served
contract NameRegistry {
    mapping(bytes32 => address) public nameToAddress;
    mapping(address => bytes32) public addressToName;

    function registerName(bytes32 name) external {
        require(nameToAddress[name] == address(0), "Name taken");
        require(addressToName[msg.sender] == bytes32(0), "Already registered");

        nameToAddress[name] = msg.sender;
        addressToName[msg.sender] = name;
    }
}
