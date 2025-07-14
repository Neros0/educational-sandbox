// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title AuctionHouse
 * @dev English auction system with bidding, withdrawal, and settlement
 * Educational contract for learning auction mechanics
 */
contract AuctionHouse {
    enum AuctionState {
        ACTIVE,
        ENDED,
        CANCELLED
    }

    struct Auction {
        address payable seller;
        string itemName;
        string description;
        uint256 startingPrice;
        uint256 reservePrice;
        uint256 highestBid;
        address payable highestBidder;
        uint256 startTime;
        uint256 endTime;
        AuctionState state;
        bool settled;
        uint256 totalBids;
    }

    mapping(uint256 => Auction) public auctions;
    mapping(uint256 => mapping(address => uint256)) public pendingReturns;
    uint256 public auctionCounter;
    uint256 public constant AUCTION_FEE_PERCENT = 2; // 2% fee
    address public owner;

    event AuctionCreated(
        uint256 indexed auctionId,
        address indexed seller,
        string itemName,
        uint256 startingPrice,
        uint256 reservePrice,
        uint256 duration
    );

    event BidPlaced(uint256 indexed auctionId, address indexed bidder, uint256 amount, uint256 timestamp);

    event AuctionEnded(uint256 indexed auctionId, address winner, uint256 winningBid);
    event AuctionSettled(uint256 indexed auctionId, uint256 sellerAmount, uint256 fee);
    event AuctionCancelled(uint256 indexed auctionId);
    event BidWithdrawn(uint256 indexed auctionId, address indexed bidder, uint256 amount);

    modifier onlySeller(uint256 auctionId) {
        require(msg.sender == auctions[auctionId].seller, "Only seller can call");
        _;
    }

    modifier auctionExists(uint256 auctionId) {
        require(auctionId < auctionCounter, "Auction does not exist");
        _;
    }

    modifier auctionActive(uint256 auctionId) {
        require(auctions[auctionId].state == AuctionState.ACTIVE, "Auction not active");
        require(block.timestamp < auctions[auctionId].endTime, "Auction ended");
        _;
    }

    modifier auctionEnded(uint256 auctionId) {
        require(
            auctions[auctionId].state == AuctionState.ENDED || block.timestamp >= auctions[auctionId].endTime,
            "Auction not ended"
        );
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /**
     * @dev Create a new auction
     * @param itemName Name of the item being auctioned
     * @param description Description of the item
     * @param startingPrice Minimum starting bid
     * @param reservePrice Minimum price for sale (can be 0)
     * @param durationHours Duration of auction in hours
     */
    function createAuction(
        string memory itemName,
        string memory description,
        uint256 startingPrice,
        uint256 reservePrice,
        uint256 durationHours
    ) external returns (uint256) {
        require(bytes(itemName).length > 0, "Item name required");
        require(startingPrice >= 0, "Starting price must 0 or greater");
        require(reservePrice >= startingPrice, "Reserve price must be >= starting price");
        require(durationHours > 0 && durationHours <= 168, "Duration must be 1-168 hours"); // Max 1 week

        uint256 auctionId = auctionCounter++;
        uint256 endTime = block.timestamp + (durationHours * 1 hours);

        auctions[auctionId] = Auction({
            seller: payable(msg.sender),
            itemName: itemName,
            description: description,
            startingPrice: startingPrice,
            reservePrice: reservePrice,
            highestBid: 0,
            highestBidder: payable(address(0)),
            startTime: block.timestamp,
            endTime: endTime,
            state: AuctionState.ACTIVE,
            settled: false,
            totalBids: 0
        });

        emit AuctionCreated(auctionId, msg.sender, itemName, startingPrice, reservePrice, durationHours);

        return auctionId;
    }

    /**
     * @dev Place a bid on an active auction
     */
    function placeBid(uint256 auctionId) external payable auctionExists(auctionId) auctionActive(auctionId) {
        Auction storage auction = auctions[auctionId];

        require(msg.sender != auction.seller, "Seller cannot bid on own auction");
        require(msg.value > 0, "Bid must be greater than 0");
        require(msg.value >= auction.startingPrice, "Bid must be at least starting price");
        require(msg.value > auction.highestBid, "Bid must be higher than current highest bid");

        // If there was a previous highest bidder, add their bid to pending returns
        if (auction.highestBidder != address(0)) {
            pendingReturns[auctionId][auction.highestBidder] += auction.highestBid;
        }

        // Set new highest bid
        auction.highestBid = msg.value;
        auction.highestBidder = payable(msg.sender);
        auction.totalBids++;

        emit BidPlaced(auctionId, msg.sender, msg.value, block.timestamp);

        // Auto-extend auction if bid placed in last 10 minutes
        if (auction.endTime - block.timestamp < 10 minutes) {
            auction.endTime = block.timestamp + 10 minutes;
        }
    }

    /**
     * @dev End an auction (can be called by anyone after end time)
     */
    function endAuction(uint256 auctionId) external auctionExists(auctionId) {
        Auction storage auction = auctions[auctionId];

        require(auction.state == AuctionState.ACTIVE, "Auction not active");
        require(block.timestamp >= auction.endTime, "Auction still active");

        auction.state = AuctionState.ENDED;

        emit AuctionEnded(auctionId, auction.highestBidder, auction.highestBid);
    }

    /**
     * @dev Settle auction and transfer funds
     */
    function settleAuction(uint256 auctionId) external auctionExists(auctionId) auctionEnded(auctionId) {
        Auction storage auction = auctions[auctionId];

        require(!auction.settled, "Auction already settled");
        require(auction.state == AuctionState.ENDED, "Auction not ended");

        auction.settled = true;

        // If reserve price not met or no bids, refund highest bidder
        if (auction.highestBid < auction.reservePrice || auction.highestBid == 0) {
            if (auction.highestBidder != address(0)) {
                pendingReturns[auctionId][auction.highestBidder] += auction.highestBid;
            }
            return;
        }

        // Calculate fee and seller amount
        uint256 fee = (auction.highestBid * AUCTION_FEE_PERCENT) / 100;
        uint256 sellerAmount = auction.highestBid - fee;

        // Transfer funds
        auction.seller.transfer(sellerAmount);
        payable(owner).transfer(fee);

        emit AuctionSettled(auctionId, sellerAmount, fee);
    }

    /**
     * @dev Cancel auction (only seller, only if no bids)
     */
    function cancelAuction(uint256 auctionId) external auctionExists(auctionId) onlySeller(auctionId) {
        Auction storage auction = auctions[auctionId];

        require(auction.state == AuctionState.ACTIVE, "Auction not active");
        require(auction.totalBids == 0, "Cannot cancel auction with bids");

        auction.state = AuctionState.CANCELLED;

        emit AuctionCancelled(auctionId);
    }

    /**
     * @dev Withdraw failed bids
     */
    function withdrawBid(uint256 auctionId) external auctionExists(auctionId) {
        uint256 amount = pendingReturns[auctionId][msg.sender];
        require(amount > 0, "No funds to withdraw");

        pendingReturns[auctionId][msg.sender] = 0;
        payable(msg.sender).transfer(amount);

        emit BidWithdrawn(auctionId, msg.sender, amount);
    }

    /**
     * @dev Withdraw multiple failed bids at once
     */
    function withdrawMultipleBids(uint256[] calldata auctionIds) external {
        uint256 totalAmount = 0;

        for (uint256 i = 0; i < auctionIds.length; i++) {
            uint256 auctionId = auctionIds[i];
            require(auctionId < auctionCounter, "Invalid auction ID");

            uint256 amount = pendingReturns[auctionId][msg.sender];
            if (amount > 0) {
                pendingReturns[auctionId][msg.sender] = 0;
                totalAmount += amount;
            }
        }

        require(totalAmount > 0, "No funds to withdraw");
        payable(msg.sender).transfer(totalAmount);
    }

    /**
     * @dev Get auction details
     */
    function getAuction(uint256 auctionId)
        external
        view
        auctionExists(auctionId)
        returns (
            address seller,
            string memory itemName,
            string memory description,
            uint256 startingPrice,
            uint256 reservePrice,
            uint256 highestBid,
            address highestBidder,
            uint256 startTime,
            uint256 endTime,
            AuctionState state,
            bool settled,
            uint256 totalBids
        )
    {
        Auction storage auction = auctions[auctionId];
        return (
            auction.seller,
            auction.itemName,
            auction.description,
            auction.startingPrice,
            auction.reservePrice,
            auction.highestBid,
            auction.highestBidder,
            auction.startTime,
            auction.endTime,
            auction.state,
            auction.settled,
            auction.totalBids
        );
    }

    /**
     * @dev Get pending returns for a bidder in a specific auction
     */
    function getPendingReturns(uint256 auctionId, address bidder)
        external
        view
        auctionExists(auctionId)
        returns (uint256)
    {
        return pendingReturns[auctionId][bidder];
    }

    /**
     * @dev Check if auction is active
     */
    function isAuctionActive(uint256 auctionId) external view auctionExists(auctionId) returns (bool) {
        return auctions[auctionId].state == AuctionState.ACTIVE && block.timestamp < auctions[auctionId].endTime;
    }

    /**
     * @dev Get time remaining in auction
     */
    function getTimeRemaining(uint256 auctionId) external view auctionExists(auctionId) returns (uint256) {
        if (block.timestamp >= auctions[auctionId].endTime) {
            return 0;
        }
        return auctions[auctionId].endTime - block.timestamp;
    }

    /**
     * @dev Get total auctions created
     */
    function getTotalAuctions() external view returns (uint256) {
        return auctionCounter;
    }

    /**
     * @dev Get active auctions (limited to prevent gas issues)
     */
    function getActiveAuctions(uint256 limit) external view returns (uint256[] memory) {
        require(limit <= 100, "Limit too high");

        uint256[] memory activeAuctions = new uint256[](limit);
        uint256 count = 0;

        for (uint256 i = 0; i < auctionCounter && count < limit; i++) {
            if (auctions[i].state == AuctionState.ACTIVE && block.timestamp < auctions[i].endTime) {
                activeAuctions[count] = i;
                count++;
            }
        }

        // Resize array to actual count
        uint256[] memory result = new uint256[](count);
        for (uint256 i = 0; i < count; i++) {
            result[i] = activeAuctions[i];
        }

        return result;
    }
}
