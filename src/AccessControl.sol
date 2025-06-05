// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract AccessControl {
    mapping(address => uint8) public roles; // 0=none, 1=user, 2=admin
    address public superAdmin;
}
