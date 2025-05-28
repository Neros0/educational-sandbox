// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title ReputationSystem
 * @dev A basic reputation system where users can give/receive endorsements
 */
contract ReputationSystem {
    struct Endorsement {
        address endorser;
        address endorsed;
        string category;
        string comment;
        uint8 rating; // 1-5 stars
        uint256 timestamp;
        uint256 id;
    }

    struct ReputationScore {
        uint256 totalEndorsements;
        uint256 totalRating;
        uint256 averageRating; // Stored as rating * 100 to handle decimals
        mapping(string => uint256) categoryCount;
        mapping(string => uint256) categoryRating;
    }
}
