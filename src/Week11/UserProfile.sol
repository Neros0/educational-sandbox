// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";

interface IReputationRegistry {
    function getReputation(address user) external view returns (uint256);
    function getReputationData(address user)
        external
        view
        returns (
            uint256 score,
            uint256 totalRatings,
            uint256 totalScore,
            uint256 lastUpdateTime,
            uint256 lastDecayTime,
            bool isRegistered
        );
}

interface IRatingSystem {
    function getUserStats(address user)
        external
        view
        returns (
            uint256 totalRatingsGiven,
            uint256 totalRatingsReceived,
            uint256 averageGiven,
            uint256 averageReceived,
            uint256 lastRatingTime
        );
}

/**
 * @title UserProfile
 * @dev Manages user profiles, metadata, and social interactions
 * @notice This contract handles user registration, profiles, and relationship tracking
 */
contract UserProfile is Ownable, ReentrancyGuard, Pausable {
    // Constants
    uint256 public constant MAX_BIO_LENGTH = 500;
    uint256 public constant MAX_USERNAME_LENGTH = 32;
    uint256 public constant MAX_SKILLS = 20;
    uint256 public constant MAX_SOCIAL_LINKS = 10;

    constructor(address _reputationRegistry, address _ratingSystem, address _owner) Ownable(_owner) {
        reputationRegistry = IReputationRegistry(_reputationRegistry);
        ratingSystem = IRatingSystem(_ratingSystem);

        // Initialize available badges
        availableBadges[BadgeType.EARLY_ADOPTER] = true;
        availableBadges[BadgeType.TOP_RATED] = true;
        availableBadges[BadgeType.TRUSTED_MEMBER] = true;
        availableBadges[BadgeType.VERIFIED] = true;
        availableBadges[BadgeType.EXPERT] = true;
        availableBadges[BadgeType.CONTRIBUTOR] = true;
        availableBadges[BadgeType.VETERAN] = true;

        // Owner is default badge issuer
        badgeIssuers[_owner] = true;
    }
}
