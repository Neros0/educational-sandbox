// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title Treasure Hunt Game
 * @dev Players must explore different locations to find hidden treasures and keys
 */
contract Game3 {
    // Game state
    mapping(address => bool) public hasWon;
    mapping(address => uint256) public attempts;
    mapping(address => uint256) public bestScore;
    mapping(address => mapping(string => bool)) public locationsVisited;
    mapping(address => uint256) public treasuresFound;
    mapping(address => bool) public hasGoldenKey;

    uint256 public totalPlayers;
    uint256 public totalWinners;
    uint256 public constant MAX_ATTEMPTS = 25;
    uint256 public constant TREASURES_NEEDED = 3;

    // Locations and their treasures
    string[] public locations =
        ["LIBRARY", "GARDEN", "CELLAR", "ATTIC", "KITCHEN", "TOWER", "DUNGEON", "LABORATORY", "VAULT", "SECRET_ROOM"];

    mapping(string => bool) public hasTreasure;
    mapping(string => string) public locationHints;
    string public constant GOLDEN_KEY_LOCATION = "SECRET_ROOM";

    // Events
    event LocationExplored(address indexed player, string location, bool foundTreasure, string hint);
    event TreasureFound(address indexed player, string location, uint256 totalTreasures);
    event GoldenKeyFound(address indexed player, string location);
    event GameWon(address indexed player, uint256 attemptsUsed, uint256 treasuresFound);
    event NewPlayer(address indexed player);

    constructor() {
        _initializeGame();
    }

    /**
     * @dev Initialize treasure locations and hints
     */
    function _initializeGame() private {
        // Set treasure locations (3 out of 10 locations have treasures)
        hasTreasure["LIBRARY"] = true;
        hasTreasure["GARDEN"] = true;
        hasTreasure["LABORATORY"] = true;

        // Set location hints
        locationHints["LIBRARY"] = "Ancient knowledge lies within these walls...";
        locationHints["GARDEN"] = "Beauty blooms where nature thrives...";
        locationHints["CELLAR"] = "Dark and damp, storing forgotten things...";
        locationHints["ATTIC"] = "Dust covers memories of the past...";
        locationHints["KITCHEN"] = "The heart of the home, where meals are made...";
        locationHints["TOWER"] = "High above, overlooking the lands...";
        locationHints["DUNGEON"] = "Cold stone walls echo with despair...";
        locationHints["LABORATORY"] = "Where science and magic intertwine...";
        locationHints["VAULT"] = "Secured behind thick metal doors...";
        locationHints["SECRET_ROOM"] = "Hidden from plain sight, the ultimate prize awaits...";
    }

    modifier newPlayer() {
        if (attempts[msg.sender] == 0) {
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

    modifier validLocation(string calldata location) {
        bool isValid = false;
        for (uint256 i = 0; i < locations.length; i++) {
            if (keccak256(abi.encodePacked(locations[i])) == keccak256(abi.encodePacked(location))) {
                isValid = true;
                break;
            }
        }
        require(isValid, "Invalid location! Check available locations.");
        _;
    }

    /**
     * @dev Explore a location to search for treasures
     * @param location The location to explore (must be uppercase)
     */
    function exploreLocation(string calldata location) external {
        attempts[msg.sender]++;

        locationsVisited[msg.sender][location] = true;
        string memory hint = locationHints[location];
        bool foundTreasure = false;

        // Check for regular treasure
        if (hasTreasure[location] && treasuresFound[msg.sender] < TREASURES_NEEDED) {
            treasuresFound[msg.sender]++;
            foundTreasure = true;
            emit TreasureFound(msg.sender, location, treasuresFound[msg.sender]);
        }

        // Check for golden key (only available after finding all treasures)
        if (keccak256(abi.encodePacked(location)) == keccak256(abi.encodePacked(GOLDEN_KEY_LOCATION))) {
            if (treasuresFound[msg.sender] >= TREASURES_NEEDED) {
                hasGoldenKey[msg.sender] = true;
                emit GoldenKeyFound(msg.sender, location);
                hint = "You found the Golden Key! You can now claim victory!";
            } else {
                hint = "The room seems important, but you need more treasures to unlock its secret...";
            }
        }

        emit LocationExplored(msg.sender, location, foundTreasure, hint);

        // Check win condition
        if (hasGoldenKey[msg.sender] && treasuresFound[msg.sender] >= TREASURES_NEEDED) {
            hasWon[msg.sender] = true;
            totalWinners++;
            bestScore[msg.sender] = attempts[msg.sender];
            emit GameWon(msg.sender, attempts[msg.sender], treasuresFound[msg.sender]);
        }
    }

    /**
     * @dev Get all available locations
     */
    function getLocations() external view returns (string[] memory) {
        return locations;
    }

    /**
     * @dev Get locations visited by a player
     */
    function getVisitedLocations(address player) external view returns (string[] memory visited) {
        uint256 count = 0;

        // First pass: count visited locations
        for (uint256 i = 0; i < locations.length; i++) {
            if (locationsVisited[player][locations[i]]) {
                count++;
            }
        }

        // Second pass: populate array
        visited = new string[](count);
        uint256 index = 0;
        for (uint256 i = 0; i < locations.length; i++) {
            if (locationsVisited[player][locations[i]]) {
                visited[index] = locations[i];
                index++;
            }
        }
    }

    /**
     * @dev Get remaining locations for a player
     */
    function getRemainingLocations(address player) external view returns (string[] memory remaining) {
        uint256 count = 0;

        // First pass: count unvisited locations
        for (uint256 i = 0; i < locations.length; i++) {
            if (!locationsVisited[player][locations[i]]) {
                count++;
            }
        }

        // Second pass: populate array
        remaining = new string[](count);
        uint256 index = 0;
        for (uint256 i = 0; i < locations.length; i++) {
            if (!locationsVisited[player][locations[i]]) {
                remaining[index] = locations[i];
                index++;
            }
        }
    }

    /**
     * @dev Reset player progress
     */
    function resetProgress() external {
        require(hasWon[msg.sender] || attempts[msg.sender] >= MAX_ATTEMPTS, "Finish your current game first!");

        // Reset all mappings for the player
        for (uint256 i = 0; i < locations.length; i++) {
            locationsVisited[msg.sender][locations[i]] = false;
        }

        hasWon[msg.sender] = false;
        attempts[msg.sender] = 0;
        treasuresFound[msg.sender] = 0;
        hasGoldenKey[msg.sender] = false;
    }

    /**
     * @dev Get player progress
     */
    function getPlayerStats(address player)
        external
        view
        returns (
            bool won,
            uint256 currentAttempts,
            uint256 attemptsLeft,
            uint256 treasures,
            bool goldenKey,
            uint256 locationsExplored,
            uint256 personalBest
        )
    {
        uint256 left = hasWon[player] ? 0 : (MAX_ATTEMPTS > attempts[player] ? MAX_ATTEMPTS - attempts[player] : 0);

        // Count visited locations
        uint256 visitedCount = 0;
        for (uint256 i = 0; i < locations.length; i++) {
            if (locationsVisited[player][locations[i]]) {
                visitedCount++;
            }
        }

        return (
            hasWon[player],
            attempts[player],
            left,
            treasuresFound[player],
            hasGoldenKey[player],
            visitedCount,
            bestScore[player]
        );
    }

    /**
     * @dev Get game statistics
     */
    function getGameStats() external view returns (uint256 players, uint256 winners, uint256 winRate) {
        uint256 rate = totalPlayers > 0 ? (totalWinners * 100) / totalPlayers : 0;
        return (totalPlayers, totalWinners, rate);
    }

    /**
     * @dev Get hint for the treasure hunt
     */
    function getHint() external view returns (string memory) {
        return string(
            abi.encodePacked(
                "Find ",
                _toString(TREASURES_NEEDED),
                " treasures, then search for the Golden Key in the SECRET_ROOM to win!"
            )
        );
    }

    /**
     * @dev Convert uint to string (simple implementation)
     */
    function _toString(uint256 value) private pure returns (string memory) {
        if (value == 0) return "0";

        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }

        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
}
