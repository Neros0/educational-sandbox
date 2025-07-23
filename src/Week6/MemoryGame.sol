// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract MemoryGame {
    struct Player {
        uint8 currentRound;
        uint8 livesRemaining;
        uint256 score;
        uint256 bestRound;
        uint256 totalGamesPlayed;
        bool isActive;
        uint256 roundStartTime;
    }

    struct GameSession {
        uint8[] currentPattern;
        bool isComplete;
        uint256 startTime;
    }

    mapping(address => Player) public players;
    mapping(address => GameSession) public gameSessions;

    // Leaderboard
    address[] public leaderboard;
    mapping(address => uint256) public leaderboardIndex;

    uint8 public constant MAX_ROUNDS = 10;
    uint8 public constant STARTING_LIVES = 3;
    uint8 public constant STARTING_PATTERN_LENGTH = 3;
    uint8 public constant NUM_COLORS = 4; // 0, 1, 2, 3 representing different colors
    uint256 public constant TIME_BONUS_THRESHOLD = 10; // seconds
    uint256 public constant POINTS_PER_ROUND = 100;
    uint256 public constant TIME_BONUS_MULTIPLIER = 2;

    event GameStarted(address indexed player, uint8[] pattern);
    event PatternGuessed(address indexed player, uint8[] guess, bool correct);
    event RoundCompleted(address indexed player, uint8 round, uint256 score);
    event GameCompleted(address indexed player, uint256 finalScore, bool won);
    event LifeLost(address indexed player, uint8 livesRemaining);
    event LeaderboardUpdated(address indexed player, uint256 bestRound);

    error GameNotActive();
    error GameAlreadyActive();
    error InvalidPatternLength();
    error InvalidColorValue();
    error NoLivesRemaining();
    error PatternLengthMismatch();

    function startGame() external {
        Player storage player = players[msg.sender];

        player.currentRound = 1;
        player.livesRemaining = STARTING_LIVES;
        player.score = 0;
        player.isActive = true;
        player.totalGamesPlayed++;

        _generatePattern();

        emit GameStarted(msg.sender, gameSessions[msg.sender].currentPattern);
    }

    function submitGuess(uint8[] calldata guess) external {
        Player storage player = players[msg.sender];
        GameSession storage session = gameSessions[msg.sender];

        uint8 expectedLength = STARTING_PATTERN_LENGTH + player.currentRound - 1;
        if (guess.length != expectedLength) revert PatternLengthMismatch();

        // Validate color values
        for (uint256 i = 0; i < guess.length; i++) {
            if (guess[i] >= NUM_COLORS) revert InvalidColorValue();
        }

        bool correct = _checkPattern(guess, session.currentPattern);
        emit PatternGuessed(msg.sender, guess, correct);

        if (correct) {
            _handleCorrectGuess();
        } else {
            _handleIncorrectGuess();
        }
    }

    function _generatePattern() internal {
        Player storage player = players[msg.sender];
        GameSession storage session = gameSessions[msg.sender];

        uint8 patternLength = STARTING_PATTERN_LENGTH + player.currentRound - 1;
        session.currentPattern = new uint8[](patternLength);

        // Generate pseudo-random pattern using block data and player address
        uint256 seed =
            uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender, player.currentRound)));

        for (uint8 i = 0; i < patternLength; i++) {
            session.currentPattern[i] = uint8(uint256(keccak256(abi.encodePacked(seed, i))) % NUM_COLORS);
        }

        player.roundStartTime = block.timestamp;
    }

    function _checkPattern(uint8[] calldata guess, uint8[] memory pattern) internal pure returns (bool) {
        if (guess.length != pattern.length) return false;

        for (uint256 i = 0; i < guess.length; i++) {
            if (guess[i] != pattern[i]) return false;
        }
        return true;
    }

    function _handleCorrectGuess() internal {
        Player storage player = players[msg.sender];

        // Calculate score with time bonus
        uint256 roundScore = POINTS_PER_ROUND;
        uint256 timeTaken = block.timestamp - player.roundStartTime;

        if (timeTaken <= TIME_BONUS_THRESHOLD) {
            roundScore *= TIME_BONUS_MULTIPLIER;
        }

        player.score += roundScore;
        emit RoundCompleted(msg.sender, player.currentRound, roundScore);

        if (player.currentRound >= MAX_ROUNDS) {
            _completeGame(true);
        } else {
            player.currentRound++;
            _generatePattern();
            emit GameStarted(msg.sender, gameSessions[msg.sender].currentPattern);
        }
    }

    function _handleIncorrectGuess() internal {
        Player storage player = players[msg.sender];

        player.livesRemaining--;
        emit LifeLost(msg.sender, player.livesRemaining);

        if (player.livesRemaining == 0) {
            _completeGame(false);
        }
        // If lives remain, player can try the same pattern again
    }

    function _completeGame(bool won) internal {
        Player storage player = players[msg.sender];

        if (player.currentRound > player.bestRound) {
            player.bestRound = player.currentRound;
            _updateLeaderboard();
        }

        player.isActive = false;
        gameSessions[msg.sender].isComplete = true;

        emit GameCompleted(msg.sender, player.score, won);
    }

    function _updateLeaderboard() internal {
        address player = msg.sender;

        // If player not in leaderboard, add them
        if (leaderboardIndex[player] == 0 && (leaderboard.length == 0 || leaderboard[0] != player)) {
            leaderboard.push(player);
            leaderboardIndex[player] = leaderboard.length;
        }

        // Bubble sort to maintain leaderboard order (top scores first)
        uint256 currentIndex = leaderboardIndex[player] - 1;

        while (
            currentIndex > 0
                && players[leaderboard[currentIndex]].bestRound > players[leaderboard[currentIndex - 1]].bestRound
        ) {
            // Swap positions
            address temp = leaderboard[currentIndex];
            leaderboard[currentIndex] = leaderboard[currentIndex - 1];
            leaderboard[currentIndex - 1] = temp;

            // Update indices
            leaderboardIndex[leaderboard[currentIndex]] = currentIndex + 1;
            leaderboardIndex[leaderboard[currentIndex - 1]] = currentIndex;

            currentIndex--;
        }

        emit LeaderboardUpdated(player, players[player].bestRound);
    }

    // View functions
    function getCurrentPattern() external view returns (uint8[] memory) {
        return gameSessions[msg.sender].currentPattern;
    }

    function getPlayerStats(address playerAddr)
        external
        view
        returns (
            uint8 currentRound,
            uint8 livesRemaining,
            uint256 score,
            uint256 bestRound,
            uint256 totalGamesPlayed,
            bool isActive
        )
    {
        Player memory player = players[playerAddr];
        return (
            player.currentRound,
            player.livesRemaining,
            player.score,
            player.bestRound,
            player.totalGamesPlayed,
            player.isActive
        );
    }

    function getLeaderboard() external view returns (address[] memory, uint256[] memory) {
        uint256[] memory scores = new uint256[](leaderboard.length);
        for (uint256 i = 0; i < leaderboard.length; i++) {
            scores[i] = players[leaderboard[i]].bestRound;
        }
        return (leaderboard, scores);
    }

    function getTopPlayers(uint256 count) external view returns (address[] memory, uint256[] memory) {
        uint256 returnCount = count > leaderboard.length ? leaderboard.length : count;
        address[] memory topPlayers = new address[](returnCount);
        uint256[] memory topScores = new uint256[](returnCount);

        for (uint256 i = 0; i < returnCount; i++) {
            topPlayers[i] = leaderboard[i];
            topScores[i] = players[leaderboard[i]].bestRound;
        }

        return (topPlayers, topScores);
    }

    function forfeitGame() external {
        _completeGame(false);
    }
}
