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

    struct Event {
        uint256 id;
        address organizer;
        string title;
        string description;
        string location;
        uint256 startTime;
        uint256 endTime;
        uint256 maxAttendees;
        uint256 confirmedCount;
        uint256 waitlistCount;
        bool requiresApproval;
        EventStatus status;
        uint256 createdAt;
    }

    struct RSVP {
        address attendee;
        uint256 eventId;
        RSVPStatus status;
        uint256 timestamp;
        string message; // Optional message from attendee
        bool checkedIn;
        uint256 checkedInAt;
    }
}
