// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// 1. Global Counter - Anyone can increment, great for teaching state changes
contract GlobalCounter {
    // @notice The number of times this contract has been incremented
    uint256 public count;

    function increment() external {
        count++;
    }
}
