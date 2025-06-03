// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract MessageWall {
    mapping(address => mapping(address => bytes32)) public messages;
}
