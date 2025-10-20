// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Counter {
    uint256 private count;
    string private Version = "1.0.3";

    function increment() public {
        count++;
    }

    function getCount() public view returns (uint256) {
        return count;
    }
}
