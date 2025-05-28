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

    // Storage
    Endorsement[] public endorsements;
    mapping(address => ReputationScore) public reputationScores;
    mapping(address => mapping(address => bool)) public hasEndorsed; // endorser => endorsed => bool
    mapping(address => uint256[]) public userEndorsements; // endorsements received by user
    mapping(address => uint256[]) public userGivenEndorsements; // endorsements given by user

    // Categories
    string[] public categories;
    mapping(string => bool) public validCategories;

    uint256 public totalEndorsements;
    uint256 private nextEndorsementId;

    // Configuration
    uint256 public constant COOLDOWN_PERIOD = 0; // 0 hours between endorsements from same user
    mapping(address => mapping(address => uint256)) public lastEndorsementTime;

    event EndorsementGiven(
        address indexed endorser, address indexed endorsed, string category, uint8 rating, uint256 endorsementId
    );

    event CategoryAdded(string category);

    constructor() {
        // Initialize default categories
        _addCategory("Technical Skills");
        _addCategory("Communication");
        _addCategory("Reliability");
        _addCategory("Teamwork");
        _addCategory("Leadership");
        _addCategory("Creativity");
    }
}
