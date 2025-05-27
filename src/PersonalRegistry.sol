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

    event ProfileCreated(address indexed user, string name);
    event ProfileUpdated(address indexed user, string name);

    /**
     * @dev Create or update a user's profile
     * @param _name Display name
     * @param _bio Short biography
     * @param _website Website URL
     * @param _twitter Twitter handle
     * @param _github GitHub username
     */
    function setProfile(
        string memory _name,
        string memory _bio,
        string memory _website,
        string memory _twitter,
        string memory _github
    ) external {
        bool isNewProfile = !profiles[msg.sender].exists;

        profiles[msg.sender] = Profile({
            name: _name,
            bio: _bio,
            website: _website,
            twitter: _twitter,
            github: _github,
            lastUpdated: block.timestamp,
            exists: true
        });

        if (isNewProfile) {
            registeredUsers.push(msg.sender);
            emit ProfileCreated(msg.sender, _name);
        } else {
            emit ProfileUpdated(msg.sender, _name);
        }
    }

    /**
     * @dev Get a user's profile
     * @param _user Address of the user
     * @return Profile struct containing user information
     */
    function getProfile(address _user) external view returns (Profile memory) {
        require(profiles[_user].exists, "Profile does not exist");
        return profiles[_user];
    }

    /**
     * @dev Check if a user has a profile
     * @param _user Address to check
     * @return bool indicating if profile exists
     */
    function hasProfile(address _user) external view returns (bool) {
        return profiles[_user].exists;
    }

    /**
     * @dev Get total number of registered users
     * @return uint256 count of registered users
     */
    function getTotalUsers() external view returns (uint256) {
        return registeredUsers.length;
    }

    /**
     * @dev Get user address by index (for iteration)
     * @param _index Index in the registeredUsers array
     * @return address of the user at given index
     */
    function getUserByIndex(uint256 _index) external view returns (address) {
        require(_index < registeredUsers.length, "Index out of bounds");
        return registeredUsers[_index];
    }

    /**
     * @dev Delete your own profile
     */
    function deleteProfile() external {
        require(profiles[msg.sender].exists, "Profile does not exist");

        delete profiles[msg.sender];

        // Remove from registeredUsers array
        for (uint256 i = 0; i < registeredUsers.length; i++) {
            if (registeredUsers[i] == msg.sender) {
                registeredUsers[i] = registeredUsers[registeredUsers.length - 1];
                registeredUsers.pop();
                break;
            }
        }
    }
}
