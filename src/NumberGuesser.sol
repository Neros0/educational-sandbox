// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract NumberGuesser {
    bytes32 private secretHash;
    address public winner;
    bool public gameActive = true;
}
