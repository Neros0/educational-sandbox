// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title MathChallenge
 * @notice A smart contract that presents mathematical problems for students to solve
 * @dev This contract allows deployment of individual math problems with tracking of student attempts and solutions
 * @custom:version 1.0.0
 */
contract MathChallenge24 {
    /*//////////////////////////////////////////////////////////////
                                STORAGE
    //////////////////////////////////////////////////////////////*/

    /// @notice The mathematical problem statement presented to students
    /// @dev Stored as a string to allow complex mathematical expressions and formatting
    string public problem = "What is 2^8 + 10^1 - 4^3 + 7 + 3 + 1 + 1 + 6 + 2 + 2 + 2 + 2 + 2?";

    /// @notice The correct numerical answer to the mathematical problem
    /// @dev Immutable to prevent tampering after deployment, ensuring problem integrity
    uint256 public immutable correctAnswer = 231; // 256 + 10 - 64 + 7 + 3 + 1 + 1 + 6 + 2 + 2 + 2 + 2 + 2= 231

    /// @notice A hint to help students solve the problem
    /// @dev Can be updated by adding a setter function if needed for dynamic hints
    string public hint = "Break it down: calculate each exponent separately, then add and subtract";

    /// @notice Difficulty rating of the problem on a 1-5 scale
    /// @dev 1 = Very Easy, 2 = Easy, 3 = Medium, 4 = Hard, 5 = Very Hard
    uint256 public difficulty = 4;

    /*//////////////////////////////////////////////////////////////
                                MAPPINGS
    //////////////////////////////////////////////////////////////*/

    /// @notice Tracks the number of attempts each student has made
    /// @dev Maps student address to their attempt count for this specific problem
    mapping(address => uint256) public attempts;

    /// @notice Tracks whether each student has successfully solved the problem
    /// @dev Maps student address to boolean indicating if they've found the correct answer
    mapping(address => bool) public solved;

    /*//////////////////////////////////////////////////////////////
                                EVENTS
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Emitted when a student submits an answer attempt
     * @dev Provides comprehensive logging for tracking student progress and analytics
     * @param student The address of the student making the attempt
     * @param answer The numerical answer submitted by the student
     * @param correct Whether the submitted answer was correct
     * @param attemptCount The total number of attempts this student has made
     */
    event Attempt(address indexed student, uint256 answer, bool correct, uint256 attemptCount);

    /**
     * @notice Emitted when a student successfully solves the problem
     * @dev Marks the completion milestone for analytics and potential reward distribution
     * @param student The address of the student who solved the problem
     * @param finalAttempts The total number of attempts it took to solve the problem
     */
    event ProblemSolved(address indexed student, uint256 finalAttempts);

    /*//////////////////////////////////////////////////////////////
                              CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Initializes a new math challenge with hardcoded problem details
     * @dev No parameters needed - all values are set directly in storage declarations
     */
    constructor() {
        // No initialization needed - all values are set in storage declarations above
    }
}
