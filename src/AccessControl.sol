// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract AccessControl {
    mapping(address => uint8) public roles; // 0=none, 1=user, 2=admin
    address public superAdmin;

    constructor() {
        superAdmin = msg.sender;
        roles[msg.sender] = 2;
    }

    function setRole(address _user, uint8 _role) external {
        require(_role <= 2, "Invalid role");
        roles[_user] = _role;
    }
}
