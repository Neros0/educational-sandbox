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

    // Enums
    enum ProfileVisibility {
        PUBLIC,
        RESTRICTED,
        PRIVATE
    }

    enum UserStatus {
        ACTIVE,
        SUSPENDED,
        BANNED,
        INACTIVE
    }

    enum BadgeType {
        EARLY_ADOPTER,
        TOP_RATED,
        TRUSTED_MEMBER,
        VERIFIED,
        EXPERT,
        CONTRIBUTOR,
        VETERAN
    }

    // Structs
    struct Profile {
        string username; // Unique username
        string bio; // User biography
        string avatarURI; // IPFS hash or URI for avatar
        string[] skills; // List of skills
        string[] socialLinks; // Social media links
        ProfileVisibility visibility; // Profile visibility setting
        UserStatus status; // Account status
        uint256 joinDate; // Registration timestamp
        uint256 lastActiveTime; // Last activity timestamp
        bool isVerified; // Verified user status
        uint256 profileVersion; // Version counter for updates
    }

    struct Badge {
        BadgeType badgeType;
        string name;
        string description;
        string iconURI;
        uint256 awardedAt;
        address awardedBy;
        bool isActive;
    }

    struct UserRelationship {
        bool hasInteracted; // Whether users have rated each other
        bool isFollowing; // Whether user1 follows user2
        bool isBlocked; // Whether user1 has blocked user2
        uint256 firstInteraction; // Timestamp of first interaction
        uint256 lastInteraction; // Timestamp of last interaction
        uint256 interactionCount; // Total number of interactions
    }

    struct UserStatistics {
        uint256 profileViews;
        uint256 followersCount;
        uint256 followingCount;
        uint256 totalInteractions;
        uint256 badgesCount;
        uint256 endorsementsReceived;
    }

    struct Endorsement {
        address endorser;
        string skill;
        string comment;
        uint256 timestamp;
        bool isActive;
    }

    // State variables
    IReputationRegistry public immutable reputationRegistry;
    IRatingSystem public ratingSystem;

    // Storage mappings
    mapping(address => Profile) public profiles;
    mapping(string => address) public usernameToAddress;
    mapping(address => Badge[]) public userBadges;
    mapping(address => mapping(address => UserRelationship)) public relationships;
    mapping(address => UserStatistics) public userStatistics;
    mapping(address => Endorsement[]) public userEndorsements;
    mapping(address => mapping(string => uint256)) public skillEndorsementCount;
    mapping(address => address[]) public userFollowers;
    mapping(address => address[]) public userFollowing;
    mapping(address => mapping(address => bool)) public isFollowing;
    mapping(address => mapping(address => bool)) public isBlocked;

    // Additional tracking
    address[] private _registeredUsers;
    mapping(address => bool) public isRegistered;
    mapping(address => uint256) public registrationIndex;

    // Badge management
    mapping(BadgeType => bool) public availableBadges;
    mapping(address => bool) public badgeIssuers;

    // Events
    event ProfileCreated(address indexed user, string username, uint256 timestamp);
    event ProfileUpdated(address indexed user, uint256 profileVersion);
    event UsernameChanged(address indexed user, string oldUsername, string newUsername);
    event ProfileVisibilityChanged(
        address indexed user, ProfileVisibility oldVisibility, ProfileVisibility newVisibility
    );
    event UserStatusChanged(
        address indexed user, UserStatus oldStatus, UserStatus newStatus, address indexed changedBy
    );
    event BadgeAwarded(address indexed user, BadgeType indexed badgeType, address indexed awardedBy, uint256 timestamp);
    event BadgeRevoked(address indexed user, uint256 indexed badgeIndex, address indexed revokedBy);
    event UserFollowed(address indexed follower, address indexed following);
    event UserUnfollowed(address indexed follower, address indexed unfollowing);
    event UserBlocked(address indexed blocker, address indexed blocked);
    event UserUnblocked(address indexed blocker, address indexed unblocked);
    event EndorsementGiven(address indexed endorser, address indexed endorsed, string skill, uint256 timestamp);
    event EndorsementRevoked(address indexed endorser, address indexed endorsed, uint256 indexed endorsementIndex);
    event ProfileViewed(address indexed viewer, address indexed profileOwner);
    event VerificationStatusChanged(address indexed user, bool isVerified, address indexed verifiedBy);

    // Errors
    error UserAlreadyRegistered(address user);
    error UserNotRegistered(address user);
    error UsernameAlreadyTaken(string username);
    error InvalidUsername(string username);
    error InvalidBioLength(uint256 length);

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
