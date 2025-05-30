// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title EventRSVP
 * @dev An event RSVP system where people can register for events
 */
contract EventRSVP {
    enum RSVPStatus {
        PENDING,
        CONFIRMED,
        CANCELLED,
        WAITLISTED
    }
    enum EventStatus {
        UPCOMING,
        ONGOING,
        COMPLETED,
        CANCELLED
    }
}
