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

    /**
     * @dev Add a new endorsement category
     * @param _category Category name
     */
    function addCategory(string memory _category) external {
        require(bytes(_category).length > 0, "Category cannot be empty");
        require(!validCategories[_category], "Category already exists");

        _addCategory(_category);
    }

    function _addCategory(string memory _category) internal {
        categories.push(_category);
        validCategories[_category] = true;
        emit CategoryAdded(_category);
    }

    /**
     * @dev Give an endorsement to another user
     * @param _endorsed Address of the user being endorsed
     * @param _category Endorsement category
     * @param _rating Rating from 1-5
     * @param _comment Optional comment
     */
    function giveEndorsement(address _endorsed, string memory _category, uint8 _rating, string memory _comment)
        external
    {
        require(_endorsed != address(0), "Invalid endorsed address");
        require(_endorsed != msg.sender, "Cannot endorse yourself");
        require(validCategories[_category], "Invalid category");
        require(_rating >= 1 && _rating <= 5, "Rating must be between 1-5");
        require(
            block.timestamp >= lastEndorsementTime[msg.sender][_endorsed] + COOLDOWN_PERIOD,
            "Must wait 24 hours between endorsements for same user"
        );

        uint256 endorsementId = nextEndorsementId;
        nextEndorsementId++;

        Endorsement memory newEndorsement = Endorsement({
            endorser: msg.sender,
            endorsed: _endorsed,
            category: _category,
            comment: _comment,
            rating: _rating,
            timestamp: block.timestamp,
            id: endorsementId
        });

        endorsements.push(newEndorsement);
        userEndorsements[_endorsed].push(endorsementId);
        userGivenEndorsements[msg.sender].push(endorsementId);

        // Update reputation score
        ReputationScore storage score = reputationScores[_endorsed];
        score.totalEndorsements++;
        score.totalRating += _rating;
        score.averageRating = (score.totalRating * 100) / score.totalEndorsements;
        score.categoryCount[_category]++;
        score.categoryRating[_category] += _rating;

        hasEndorsed[msg.sender][_endorsed] = true;
        lastEndorsementTime[msg.sender][_endorsed] = block.timestamp;
        totalEndorsements++;

        emit EndorsementGiven(msg.sender, _endorsed, _category, _rating, endorsementId);
    }

    /**
     * @dev Get user's reputation score
     * @param _user Address of the user
     * @return totalEndorsements Total number of endorsements received
     * @return averageRating Average rating (multiplied by 100)
     */
    function getReputationScore(address _user)
        external
        view
        returns (uint256 totalEndorsements, uint256 averageRating)
    {
        ReputationScore storage score = reputationScores[_user];
        return (score.totalEndorsements, score.averageRating);
    }

    /**
     * @dev Get user's reputation in a specific category
     * @param _user Address of the user
     * @param _category Category name
     * @return count Number of endorsements in category
     * @return averageRating Average rating in category (multiplied by 100)
     */
    function getCategoryReputation(address _user, string memory _category)
        external
        view
        returns (uint256 count, uint256 averageRating)
    {
        require(validCategories[_category], "Invalid category");

        ReputationScore storage score = reputationScores[_user];
        uint256 categoryCount = score.categoryCount[_category];
        uint256 categoryAverage = categoryCount > 0 ? (score.categoryRating[_category] * 100) / categoryCount : 0;

        return (categoryCount, categoryAverage);
    }

    /**
     * @dev Get endorsements received by a user
     * @param _user Address of the user
     * @return Array of endorsement IDs
     */
    function getUserEndorsements(address _user) external view returns (uint256[] memory) {
        return userEndorsements[_user];
    }

    /**
     * @dev Get endorsements given by a user
     * @param _user Address of the user
     * @return Array of endorsement IDs
     */
    function getUserGivenEndorsements(address _user) external view returns (uint256[] memory) {
        return userGivenEndorsements[_user];
    }

    /**
     * @dev Get endorsement details
     * @param _endorsementId Endorsement ID
     * @return Endorsement struct
     */
    function getEndorsement(uint256 _endorsementId) external view returns (Endorsement memory) {
        require(_endorsementId < endorsements.length, "Endorsement does not exist");
        return endorsements[_endorsementId];
    }

    /**
     * @dev Get all available categories
     * @return Array of category names
     */
    function getCategories() external view returns (string[] memory) {
        return categories;
    }

    /**
     * @dev Check if user can endorse another user (not in cooldown)
     * @param _endorser Address of potential endorser
     * @param _endorsed Address of potential endorsed
     * @return bool indicating if endorsement is allowed
     */
    function canEndorse(address _endorser, address _endorsed) external view returns (bool) {
        if (_endorser == _endorsed) return false;
        return block.timestamp >= lastEndorsementTime[_endorser][_endorsed] + COOLDOWN_PERIOD;
    }

    /**
     * @dev Get cooldown remaining time
     * @param _endorser Address of endorser
     * @param _endorsed Address of endorsed
     * @return Seconds remaining in cooldown
     */
    function getCooldownRemaining(address _endorser, address _endorsed) external view returns (uint256) {
        uint256 nextAllowedTime = lastEndorsementTime[_endorser][_endorsed] + COOLDOWN_PERIOD;
        if (block.timestamp >= nextAllowedTime) {
            return 0;
        }
        return nextAllowedTime - block.timestamp;
    }

    /**
     * @dev Get recent endorsements (latest N)
     * @param _count Number of recent endorsements to get
     * @return Array of Endorsement structs
     */
    function getRecentEndorsements(uint256 _count) external view returns (Endorsement[] memory) {
        require(_count > 0, "Count must be greater than 0");

        uint256 startIndex = endorsements.length > _count ? endorsements.length - _count : 0;
        uint256 resultLength = endorsements.length - startIndex;

        Endorsement[] memory result = new Endorsement[](resultLength);

        for (uint256 i = 0; i < resultLength; i++) {
            result[i] = endorsements[startIndex + i];
        }

        return result;
    }

    /**
     * @dev Get total number of endorsements in the system
     * @return Total endorsement count
     */
    function getTotalEndorsements() external view returns (uint256) {
        return totalEndorsements;
    }
}
