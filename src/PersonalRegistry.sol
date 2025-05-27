// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title PersonalRegistry
 * @dev A simple contract where users can store and update their personal profile information
 */
contract PersonalRegistry {
    struct Profile {
        string name;
        string bio;
        string website;
        string twitter;
        string github;
        uint256 lastUpdated;
        bool exists;
    }

    mapping(address => Profile) public profiles;
    address[] public registeredUsers;
}
