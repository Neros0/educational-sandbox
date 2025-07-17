// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title LotteryContract
 * @dev Simple lottery system with ticket purchases and random winner selection
 * Educational contract for learning randomness and lottery mechanics
 */
contract LotteryContract {
    enum LotteryState {
        OPEN,
        CALCULATING,
        CLOSED
    }

    struct Lottery {
        uint256 id;
        uint256 ticketPrice;
        uint256 startTime;
        uint256 endTime;
        address[] players;
        address winner;
        uint256 prizePool;
        LotteryState state;
        bool prizeClaimed;
        uint256 maxTickets;
        mapping(address => uint256) ticketCount;
    }

    mapping(uint256 => Lottery) public lotteries;
    uint256 public currentLotteryId;
    uint256 public constant HOUSE_FEE_PERCENT = 5; // 5% house fee
    address public owner;
    uint256 public totalLotteries;

    event LotteryCreated(uint256 indexed lotteryId, uint256 ticketPrice, uint256 duration, uint256 maxTickets);

    event TicketPurchased(uint256 indexed lotteryId, address indexed player, uint256 ticketCount, uint256 totalCost);

    event LotteryEnded(uint256 indexed lotteryId, uint256 totalPlayers, uint256 prizePool);
    event WinnerSelected(uint256 indexed lotteryId, address indexed winner, uint256 prize);
    event PrizeClaimed(uint256 indexed lotteryId, address indexed winner, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call");
        _;
    }

    modifier lotteryExists(uint256 lotteryId) {
        require(lotteryId <= currentLotteryId, "Lottery does not exist");
        _;
    }

    modifier lotteryOpen(uint256 lotteryId) {
        require(lotteries[lotteryId].state == LotteryState.OPEN, "Lottery not open");
        require(block.timestamp < lotteries[lotteryId].endTime, "Lottery ended");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /**
     * @dev Create a new lottery
     * @param ticketPrice Price per ticket in wei
     * @param durationHours Duration of lottery in hours
     * @param maxTickets Maximum number of tickets (0 for unlimited)
     */
    function createLottery(uint256 ticketPrice, uint256 durationHours, uint256 maxTickets) external returns (uint256) {
        require(ticketPrice >= 0, "Ticket price must 0 or greater");
        require(durationHours > 0 && durationHours <= 168, "Duration must be 1-168 hours");

        // End current lottery if it exists and is open
        if (currentLotteryId > 0) {
            Lottery storage currentLottery = lotteries[currentLotteryId];
            if (currentLottery.state == LotteryState.OPEN) {
                _endLottery(currentLotteryId);
            }
        }

        currentLotteryId++;
        totalLotteries++;

        Lottery storage newLottery = lotteries[currentLotteryId];
        newLottery.id = currentLotteryId;
        newLottery.ticketPrice = ticketPrice;
        newLottery.startTime = block.timestamp;
        newLottery.endTime = block.timestamp + (durationHours * 1 hours);
        newLottery.state = LotteryState.OPEN;
        newLottery.maxTickets = maxTickets;

        emit LotteryCreated(currentLotteryId, ticketPrice, durationHours, maxTickets);

        return currentLotteryId;
    }

    /**
     * @dev Purchase lottery tickets
     * @param lotteryId ID of the lottery
     * @param ticketCount Number of tickets to purchase
     */
    function buyTickets(uint256 lotteryId, uint256 ticketCount)
        external
        payable
        lotteryExists(lotteryId)
        lotteryOpen(lotteryId)
    {
        require(ticketCount > 0, "Must buy at least 1 ticket");
        require(ticketCount <= 100, "Cannot buy more than 100 tickets at once");

        Lottery storage lottery = lotteries[lotteryId];
        uint256 totalCost = lottery.ticketPrice * ticketCount;
        require(msg.value >= totalCost, "Insufficient payment");

        // Check max tickets limit
        if (lottery.maxTickets > 0) {
            require(lottery.players.length + ticketCount <= lottery.maxTickets, "Would exceed max tickets");
        }

        // Add tickets for the player
        for (uint256 i = 0; i < ticketCount; i++) {
            lottery.players.push(msg.sender);
        }

        lottery.ticketCount[msg.sender] += ticketCount;
        lottery.prizePool += totalCost;

        emit TicketPurchased(lotteryId, msg.sender, ticketCount, totalCost);

        // Refund excess payment
        if (msg.value > totalCost) {
            payable(msg.sender).transfer(msg.value - totalCost);
        }
    }

    /**
     * @dev End the lottery
     * @param lotteryId ID of the lottery
     */
    function endLottery(uint256 lotteryId) external onlyOwner lotteryExists(lotteryId) lotteryOpen(lotteryId) {
        _endLottery(lotteryId);
    }

    function _endLottery(uint256 lotteryId) internal {
        Lottery storage lottery = lotteries[lotteryId];
        require(lottery.state == LotteryState.OPEN, "Lottery not open");

        lottery.state = LotteryState.CALCULATING;
    }

    /**
     * @dev Select a winner for the lottery
     * @param lotteryId ID of the lottery
     */
    function selectWinner(uint256 lotteryId) external onlyOwner lotteryExists(lotteryId) lotteryOpen(lotteryId) {
        _endLottery(lotteryId);
    }

    /**
     * @dev Withdraw the winnings for the lottery
     * @param lotteryId ID of the lottery
     */
    function withdrawWinnings(uint256 lotteryId) external onlyOwner lotteryExists(lotteryId) lotteryOpen(lotteryId) {
        _endLottery(lotteryId);
    }

    /**
     * @dev Fallback function to accept ether for ticket purchases
     * This allows the contract to receive ether directly, which can be used for ticket purchases.
     */
    receive() external payable {
        // Accept ether for ticket purchases
    }
}
