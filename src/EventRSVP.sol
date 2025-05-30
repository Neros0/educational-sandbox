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

    // Storage
    Event[] public events;
    mapping(uint256 => mapping(address => RSVP)) public eventRSVPs;
    mapping(uint256 => address[]) public eventAttendees;
    mapping(uint256 => address[]) public eventWaitlist;
    mapping(address => uint256[]) public userEvents;
    mapping(address => uint256[]) public organizerEvents;

    uint256 public totalEvents;
    uint256 private nextEventId;

    // Configuration
    uint256 public constant MAX_EVENT_DURATION = 7 days;
    uint256 public constant MIN_ADVANCE_NOTICE = 1 hours;

    event EventCreated(
        uint256 indexed eventId, address indexed organizer, string title, uint256 startTime, uint256 maxAttendees
    );

    event RSVPSubmitted(uint256 indexed eventId, address indexed attendee, RSVPStatus status);

    event RSVPStatusChanged(
        uint256 indexed eventId, address indexed attendee, RSVPStatus oldStatus, RSVPStatus newStatus
    );

    event AttendeeCheckedIn(uint256 indexed eventId, address indexed attendee, uint256 timestamp);

    event EventStatusChanged(uint256 indexed eventId, EventStatus newStatus);
}
