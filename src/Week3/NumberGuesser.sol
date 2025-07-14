// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract NumberGuesser {
    address public admin;
    uint256 private secretNumber = 99999;
    address public winner;
    bool public gameActive = true;

    constructor() {
        admin = msg.sender;
    }

    function guess(uint256 _guess) external {
        require(gameActive, "Game over");

        if (_guess == secretNumber) {
            winner = msg.sender;
            gameActive = false;
        }
    }

    receive() external payable {}
}
