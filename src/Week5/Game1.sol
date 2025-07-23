// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title Math Puzzle Game
 * @dev Simple mathematical puzzle game - guess the answer to life, universe, and everything
 */
contract Game1 {
    // Game state
    mapping(address => bool) public hasWon;
    mapping(address => uint256) public attempts;
    mapping(address => uint256) public bestScore; // Track lowest attempts to win

    uint256 private constant SECRET_ANSWER = 99999;
    uint256 public totalPlayers;
    uint256 public totalWinners;

    // Events
    event GameWon(address indexed player, uint256 attemptsUsed);
    event WrongAnswer(address indexed player, uint256 attempt, uint256 guess);
    event NewPlayer(address indexed player);

    modifier newPlayer() {
        if (attempts[msg.sender] == 0) {
            totalPlayers++;
            emit NewPlayer(msg.sender);
        }
        _;
    }

    /**
     * @dev Submit an answer to the math puzzle
     * @param guess The player's guess for the secret number
     */
    function submitAnswer(uint256 guess) external {
        attempts[msg.sender]++;

        if (hasWon[msg.sender]) {
            revert("You've already won! Try resetProgress() to play again.");
        }

        if (guess == SECRET_ANSWER) {
            hasWon[msg.sender] = true;
            totalWinners++;
            bestScore[msg.sender] = attempts[msg.sender];
            emit GameWon(msg.sender, attempts[msg.sender]);
        } else {
            emit WrongAnswer(msg.sender, attempts[msg.sender], guess);
        }
    }

    /**
     * @dev Reset player progress to play again
     */
    function resetProgress() external {
        require(hasWon[msg.sender], "You haven't won yet!");

        hasWon[msg.sender] = false;
        attempts[msg.sender] = 0;
        // Keep bestScore for leaderboard purposes
    }

    /**
     * @dev Get player statistics
     */
    function getPlayerStats(address player)
        external
        view
        returns (bool won, uint256 currentAttempts, uint256 personalBest)
    {
        return (hasWon[player], attempts[player], bestScore[player]);
    }

    /**
     * @dev Get game statistics
     */
    function getGameStats() external view returns (uint256 players, uint256 winners, uint256 winRate) {
        uint256 rate = totalPlayers > 0 ? (totalWinners * 100) / totalPlayers : 0;
        return (totalPlayers, totalWinners, rate);
    }

    /**
     * @dev Get a hint for the puzzle
     */
    function getHint() external pure returns (string memory) {
        return
        "What's the answer to life, the universe, and everything? (Hint: It's from The Hitchhiker's Guide to the Galaxy)";
    }
}
