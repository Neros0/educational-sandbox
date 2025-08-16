// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title MathChallenge
 * @notice A smart contract that presents mathematical problems for students to solve
 * @dev This contract allows deployment of individual math problems with tracking of student attempts and solutions
 * @custom:version 1.0.0
 */
contract MathChallenge7 {
    /*//////////////////////////////////////////////////////////////
                                STORAGE
    //////////////////////////////////////////////////////////////*/

    /// @notice The mathematical problem statement presented to students
    /// @dev Stored as a string to allow complex mathematical expressions and formatting
    string public problem = "What is 2^8 + 10^1 - 4^3 + 1?";

    /// @notice The correct numerical answer to the mathematical problem
    /// @dev Immutable to prevent tampering after deployment, ensuring problem integrity
    uint256 public immutable correctAnswer = 203; // 256 + 10 - 64 + 1 = 203

    /// @notice A hint to help students solve the problem
    /// @dev Can be updated by adding a setter function if needed for dynamic hints
    string public hint = "Break it down: calculate each exponent separately, then add and subtract";

    /// @notice Difficulty rating of the problem on a 1-5 scale
    /// @dev 1 = Very Easy, 2 = Easy, 3 = Medium, 4 = Hard, 5 = Very Hard
    uint256 public difficulty = 2;

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

    /*//////////////////////////////////////////////////////////////
                            EXTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Allows students to submit their answer to the math problem
     * @dev Tracks attempts, validates answers, and emits appropriate events
     * @param answer The numerical answer the student believes is correct
     *
     * Requirements:
     * - Student must not have already solved this problem
     * - Function will increment attempt counter regardless of correctness
     *
     * Effects:
     * - Increments the student's attempt counter
     * - Sets solved status to true if answer is correct
     * - Emits Attempt event for all submissions
     * - Emits ProblemSolved event for correct answers
     *
     * @custom:emits Attempt
     * @custom:emits ProblemSolved (if answer is correct)
     */
    function submitAnswer(uint256 answer) external {
        // Prevent multiple solutions by the same student
        // This maintains the integrity of the "first solve" tracking
        require(!solved[msg.sender], "Already solved this problem");

        // Increment attempt counter before processing
        // This ensures the count is accurate even if the transaction reverts later
        attempts[msg.sender]++;

        // Check if the submitted answer matches the correct answer
        bool correct = (answer == correctAnswer);

        // Process correct answer
        if (correct) {
            // Mark as solved to prevent further attempts
            solved[msg.sender] = true;

            // Emit success event with final attempt count
            emit ProblemSolved(msg.sender, attempts[msg.sender]);
        }

        // Always emit attempt event for tracking and analytics
        // This provides a complete audit trail of all submission attempts
        emit Attempt(msg.sender, answer, correct, attempts[msg.sender]);
    }

    /**
     * @notice Retrieves comprehensive progress information for a specific student
     * @dev Provides a consolidated view of student progress without multiple calls
     * @param student The address of the student whose progress to query
     * @return attemptCount The total number of attempts made by this student
     * @return hasSolved Whether the student has successfully solved the problem
     * @return problemDifficulty The difficulty level of this problem (for context)
     *
     * Usage:
     * - Frontend applications can use this for displaying student dashboards
     * - Teachers can monitor individual student progress
     * - Analytics systems can aggregate data across multiple students
     */
    function getProgress(address student)
        external
        view
        returns (uint256 attemptCount, bool hasSolved, uint256 problemDifficulty)
    {
        return (
            attempts[student], // Number of attempts made
            solved[student], // Solution status
            difficulty // Problem difficulty for context
        );
    }
}
