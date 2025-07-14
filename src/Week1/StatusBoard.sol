// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract StatusBoard {
    address owner;
    mapping(address => bytes32) public statuses;

    constructor() {
        msg.sender == owner;
    }

    function updateStatus(bytes32 status) external {
        statuses[msg.sender] = status;
    }

    function getStatus(address user) external view returns (bytes32) {
        return statuses[user];
    }

    receive() external payable {}
}
