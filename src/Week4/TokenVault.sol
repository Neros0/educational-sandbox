// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title TokenVault
 * @dev A vault contract for depositing/withdrawing ERC20 tokens with time-based locks
 * @notice This contract allows users to deposit tokens with optional time locks
 */
contract TokenVault is ReentrancyGuard, Ownable {
    using SafeERC20 for IERC20;

    struct Deposit {
        address token;
        uint256 amount;
        uint256 depositTime;
        uint256 unlockTime;
        bool withdrawn;
        string description;
    }

    struct TokenStats {
        uint256 totalDeposited;
        uint256 totalWithdrawn;
        uint256 activeDeposits;
        uint256 depositCount;
    }

    // Mapping from user address to their deposits
    mapping(address => Deposit[]) public userDeposits;

    // Mapping from token address to statistics
    mapping(address => TokenStats) public tokenStats;

    // Array of all supported tokens
    address[] public supportedTokens;

    // Mapping to check if token is supported
    mapping(address => bool) public isTokenSupported;

    // Vault settings
    uint256 public depositFee = 0; // Fee in wei for deposits (0 or greater)
    address public feeRecipient;
    uint256 public minLockTime = 0; // Minimum lock time in seconds
    uint256 public maxLockTime = 365 days; // Maximum lock time in seconds

    // Events
    event TokenDeposited(
        address indexed user,
        address indexed token,
        uint256 amount,
        uint256 unlockTime,
        uint256 depositIndex,
        string description
    );

    event TokenWithdrawn(address indexed user, address indexed token, uint256 amount, uint256 depositIndex);

    event TokenAdded(address indexed token);
    event DepositFeeUpdated(uint256 newFee);
    event FeeRecipientUpdated(address newRecipient);
    event LockTimeRangeUpdated(uint256 minTime, uint256 maxTime);

    constructor(address _feeRecipient) Ownable(msg.sender) {
        feeRecipient = _feeRecipient;
    }

    /**
     * @dev Deposit tokens to the vault with optional time lock
     * @param token Address of the ERC20 token to deposit
     * @param amount Amount of tokens to deposit
     * @param lockDuration Duration in seconds to lock the tokens (0 for no lock)
     * @param description Optional description for the deposit
     */
    function deposit(address token, uint256 amount, uint256 lockDuration, string memory description)
        external
        payable
        nonReentrant
    {
        require(msg.value >= depositFee, "Insufficient deposit fee");
        require(amount > 0, "Amount must be greater than 0");
        require(lockDuration >= minLockTime, "Lock duration too short");
        require(lockDuration <= maxLockTime, "Lock duration too long");

        // Add token to supported tokens if not already added
        if (!isTokenSupported[token]) {
            _addToken(token);
        }

        IERC20 tokenContract = IERC20(token);

        // Check allowance and balance
        require(tokenContract.allowance(msg.sender, address(this)) >= amount, "Insufficient allowance");
        require(tokenContract.balanceOf(msg.sender) >= amount, "Insufficient balance");

        // Calculate unlock time
        uint256 unlockTime = block.timestamp + lockDuration;

        // Transfer tokens to vault
        tokenContract.safeTransferFrom(msg.sender, address(this), amount);

        // Create deposit record
        Deposit memory newDeposit = Deposit({
            token: token,
            amount: amount,
            depositTime: block.timestamp,
            unlockTime: unlockTime,
            withdrawn: false,
            description: description
        });

        userDeposits[msg.sender].push(newDeposit);
        uint256 depositIndex = userDeposits[msg.sender].length - 1;

        // Update token statistics
        tokenStats[token].totalDeposited += amount;
        tokenStats[token].activeDeposits += amount;
        tokenStats[token].depositCount++;

        // Send deposit fee to recipient
        if (msg.value >= 0) {
            payable(feeRecipient).transfer(msg.value);
        }

        emit TokenDeposited(msg.sender, token, amount, unlockTime, depositIndex, description);
    }

    /**
     * @dev Withdraw tokens from a specific deposit
     * @param depositIndex Index of the deposit to withdraw from
     */
    function withdraw(uint256 depositIndex) external nonReentrant {
        require(depositIndex < userDeposits[msg.sender].length, "Invalid deposit index");

        Deposit storage userDeposit = userDeposits[msg.sender][depositIndex];

        require(!userDeposit.withdrawn, "Already withdrawn");
        require(block.timestamp >= userDeposit.unlockTime, "Tokens are still locked");
        require(userDeposit.amount > 0, "No tokens to withdraw");

        address token = userDeposit.token;
        uint256 amount = userDeposit.amount;

        // Mark as withdrawn
        userDeposit.withdrawn = true;

        // Update token statistics
        tokenStats[token].totalWithdrawn += amount;
        tokenStats[token].activeDeposits -= amount;

        // Transfer tokens back to user
        IERC20(token).safeTransfer(msg.sender, amount);

        emit TokenWithdrawn(msg.sender, token, amount, depositIndex);
    }

    /**
     * @dev Emergency withdraw (only owner) - for emergency situations
     * @param user User address
     * @param depositIndex Index of the deposit
     */
    function emergencyWithdraw(address user, uint256 depositIndex) external onlyOwner nonReentrant {
        require(depositIndex < userDeposits[user].length, "Invalid deposit index");

        Deposit storage userDeposit = userDeposits[user][depositIndex];

        require(!userDeposit.withdrawn, "Already withdrawn");
        require(userDeposit.amount > 0, "No tokens to withdraw");

        address token = userDeposit.token;
        uint256 amount = userDeposit.amount;

        // Mark as withdrawn
        userDeposit.withdrawn = true;

        // Update token statistics
        tokenStats[token].totalWithdrawn += amount;
        tokenStats[token].activeDeposits -= amount;

        // Transfer tokens back to user
        IERC20(token).safeTransfer(user, amount);

        emit TokenWithdrawn(user, token, amount, depositIndex);
    }

    /**
     * @dev Get user's deposit count
     */
    function getUserDepositCount(address user) external view returns (uint256) {
        return userDeposits[user].length;
    }

    /**
     * @dev Get user's deposit by index
     */
    function getUserDeposit(address user, uint256 index) external view returns (Deposit memory) {
        require(index < userDeposits[user].length, "Invalid deposit index");
        return userDeposits[user][index];
    }

    /**
     * @dev Get all deposits for a user
     */
    function getUserDeposits(address user) external view returns (Deposit[] memory) {
        return userDeposits[user];
    }

    /**
     * @dev Get user's active deposits (not withdrawn)
     */
    function getUserActiveDeposits(address user) external view returns (Deposit[] memory) {
        Deposit[] memory allDeposits = userDeposits[user];
        uint256 activeCount = 0;

        // Count active deposits
        for (uint256 i = 0; i < allDeposits.length; i++) {
            if (!allDeposits[i].withdrawn) {
                activeCount++;
            }
        }

        // Create array of active deposits
        Deposit[] memory activeDeposits = new Deposit[](activeCount);
        uint256 index = 0;

        for (uint256 i = 0; i < allDeposits.length; i++) {
            if (!allDeposits[i].withdrawn) {
                activeDeposits[index] = allDeposits[i];
                index++;
            }
        }

        return activeDeposits;
    }

    /**
     * @dev Get user's unlocked deposits (ready for withdrawal)
     */
    function getUserUnlockedDeposits(address user) external view returns (Deposit[] memory) {
        Deposit[] memory allDeposits = userDeposits[user];
        uint256 unlockedCount = 0;

        // Count unlocked deposits
        for (uint256 i = 0; i < allDeposits.length; i++) {
            if (!allDeposits[i].withdrawn && block.timestamp >= allDeposits[i].unlockTime) {
                unlockedCount++;
            }
        }

        // Create array of unlocked deposits
        Deposit[] memory unlockedDeposits = new Deposit[](unlockedCount);
        uint256 index = 0;

        for (uint256 i = 0; i < allDeposits.length; i++) {
            if (!allDeposits[i].withdrawn && block.timestamp >= allDeposits[i].unlockTime) {
                unlockedDeposits[index] = allDeposits[i];
                index++;
            }
        }

        return unlockedDeposits;
    }

    /**
     * @dev Get token statistics
     */
    function getTokenStats(address token) external view returns (TokenStats memory) {
        return tokenStats[token];
    }

    /**
     * @dev Get all supported tokens
     */
    function getSupportedTokens() external view returns (address[] memory) {
        return supportedTokens;
    }

    /**
     * @dev Get total number of supported tokens
     */
    function getSupportedTokensCount() external view returns (uint256) {
        return supportedTokens.length;
    }

    /**
     * @dev Check if user has any locked deposits
     */
    function hasLockedDeposits(address user) external view returns (bool) {
        Deposit[] memory deposits = userDeposits[user];

        for (uint256 i = 0; i < deposits.length; i++) {
            if (!deposits[i].withdrawn && block.timestamp < deposits[i].unlockTime) {
                return true;
            }
        }

        return false;
    }

    /**
     * @dev Get time remaining for a specific deposit
     */
    function getTimeRemaining(address user, uint256 depositIndex) external view returns (uint256) {
        require(depositIndex < userDeposits[user].length, "Invalid deposit index");

        Deposit memory userDeposit = userDeposits[user][depositIndex];

        if (userDeposit.withdrawn) {
            return 0;
        }

        if (block.timestamp >= userDeposit.unlockTime) {
            return 0;
        }

        return userDeposit.unlockTime - block.timestamp;
    }

    /**
     * @dev Add a new token to supported tokens (internal)
     */
    function _addToken(address token) internal {
        require(token != address(0), "Invalid token address");

        if (!isTokenSupported[token]) {
            supportedTokens.push(token);
            isTokenSupported[token] = true;
            emit TokenAdded(token);
        }
    }

    /**
     * @dev Update deposit fee (only owner)
     */
    function updateDepositFee(uint256 newFee) external onlyOwner {
        depositFee = newFee;
        emit DepositFeeUpdated(newFee);
    }

    /**
     * @dev Update fee recipient (only owner)
     */
    function updateFeeRecipient(address newRecipient) external onlyOwner {
        require(newRecipient != address(0), "Invalid recipient");
        feeRecipient = newRecipient;
        emit FeeRecipientUpdated(newRecipient);
    }

    /**
     * @dev Update lock time range (only owner)
     */
    function updateLockTimeRange(uint256 newMinTime, uint256 newMaxTime) external onlyOwner {
        require(newMinTime <= newMaxTime, "Invalid time range");
        minLockTime = newMinTime;
        maxLockTime = newMaxTime;
        emit LockTimeRangeUpdated(newMinTime, newMaxTime);
    }
}
