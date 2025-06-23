// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract NumberGuesser {
    bytes32 private secretHash;
    address public winner;
    bool public gameActive = true;

    constructor(uint256 _secretNumber) {
        secretHash = keccak256(abi.encodePacked(_secretNumber));
    }

    function guess(uint256 _guess) external {
        require(gameActive, "Game over");

        if (keccak256(abi.encodePacked(_guess)) == secretHash) {
            winner = msg.sender;
            gameActive = false;
        }
    }
}
