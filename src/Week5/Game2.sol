// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title Word Puzzle Game
 * @dev Guess the secret word related to blockchain technology
 */
contract Game2 {
    // Game state
    mapping(address => bool) public hasWon;
    mapping(address => uint256) public attempts;
    mapping(address => uint256) public bestScore;
    mapping(address => string[]) public guessHistory; // Track all guesses

    string private constant SECRET_WORD = "BLOCKCHAIN";
    uint256 public totalPlayers;
    uint256 public totalWinners;
    uint256 public constant MAX_ATTEMPTS = 99999999; // Add attempt limit for challenge

    // Events
    event GameWon(address indexed player, uint256 attemptsUsed, string correctWord);
    event WrongAnswer(address indexed player, uint256 attempt, string guess, string hint);
    event GameOver(address indexed player, string secretWord);
    event NewPlayer(address indexed player);

    modifier newPlayer() {
        if (attempts[msg.sender] == 0 && guessHistory[msg.sender].length == 0) {
            totalPlayers++;
            emit NewPlayer(msg.sender);
        }
        _;
    }

    modifier gameActive() {
        require(!hasWon[msg.sender], "You've already won! Try resetProgress() to play again.");
        require(
            attempts[msg.sender] < MAX_ATTEMPTS,
            "Game over! You've used all attempts. Try resetProgress() to play again."
        );
        _;
    }

    /**
     * @dev Submit a word guess
     * @param word The player's guess (case insensitive)
     */
    function submitWord(string calldata word) external {
        attempts[msg.sender]++;
        string memory upperWord = _toUpper(word);
        guessHistory[msg.sender].push(upperWord);

        if (keccak256(abi.encodePacked(upperWord)) == keccak256(abi.encodePacked(SECRET_WORD))) {
            hasWon[msg.sender] = true;
            totalWinners++;
            bestScore[msg.sender] = attempts[msg.sender];
            emit GameWon(msg.sender, attempts[msg.sender], SECRET_WORD);
        } else {
            string memory hint = _generateHint(upperWord, attempts[msg.sender]);
            emit WrongAnswer(msg.sender, attempts[msg.sender], upperWord, hint);

            // Check if this was the last attempt
            if (attempts[msg.sender] >= MAX_ATTEMPTS) {
                emit GameOver(msg.sender, SECRET_WORD);
            }
        }
    }

    /**
     * @dev Generate contextual hints based on the guess
     */
    function _generateHint(string memory guess, uint256 attemptNumber) private pure returns (string memory) {
        bytes memory guessBytes = bytes(guess);

        // Check word length
        if (guessBytes.length < 10) {
            return "The word is longer than your guess!";
        } else if (guessBytes.length > 10) {
            return "The word is shorter than your guess!";
        }

        // Check if it starts with 'B'
        if (guessBytes.length > 0 && guessBytes[0] != "B") {
            return "The word starts with 'B'!";
        }

        // Progressive hints based on attempt number
        if (attemptNumber >= 3) {
            return "Think about the technology this smart contract runs on!";
        }

        return "Keep trying! It's a technology-related word.";
    }

    /**
     * @dev Convert string to uppercase (simple implementation)
     */
    function _toUpper(string memory str) private pure returns (string memory) {
        bytes memory bStr = bytes(str);
        bytes memory bUpper = new bytes(bStr.length);

        for (uint256 i = 0; i < bStr.length; i++) {
            if (bStr[i] >= 0x61 && bStr[i] <= 0x7A) {
                bUpper[i] = bytes1(uint8(bStr[i]) - 32);
            } else {
                bUpper[i] = bStr[i];
            }
        }
        return string(bUpper);
    }

    /**
     * @dev Reset player progress to play again
     */
    function resetProgress() external {
        require(hasWon[msg.sender] || attempts[msg.sender] >= MAX_ATTEMPTS, "Finish your current game first!");

        hasWon[msg.sender] = false;
        attempts[msg.sender] = 0;
        delete guessHistory[msg.sender];
    }

    /**
     * @dev Get player's guess history
     */
    function getGuessHistory(address player) external view returns (string[] memory) {
        return guessHistory[player];
    }

    /**
     * @dev Get player statistics
     */
    function getPlayerStats(address player)
        external
        view
        returns (bool won, uint256 currentAttempts, uint256 attemptsLeft, uint256 personalBest, uint256 totalGuesses)
    {
        uint256 left = hasWon[player] ? 0 : (MAX_ATTEMPTS > attempts[player] ? MAX_ATTEMPTS - attempts[player] : 0);
        return (hasWon[player], attempts[player], left, bestScore[player], guessHistory[player].length);
    }

    /**
     * @dev Get game statistics
     */
    function getGameStats() external view returns (uint256 players, uint256 winners, uint256 winRate) {
        uint256 rate = totalPlayers > 0 ? (totalWinners * 100) / totalPlayers : 0;
        return (totalPlayers, totalWinners, rate);
    }

    /**
     * @dev Get hints for the puzzle
     */
    function getHint() external pure returns (string memory) {
        return "A 10-letter word related to distributed ledger technology. Starts with 'B'.";
    }
}
