// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Event Logger contract for tracking user-submitted messages/events with timestamps
contract EventLogger {
    // Structure to store event data
    struct LoggedEvent {
        address submitter;      // Address of the user who submitted the event
        string message;         // The event message
        uint256 timestamp;      // When the event was logged
        string category;        // Optional category for organizing events
        bool isActive;          // Flag to mark if event is still active/relevant
    }
    
    // State variables
    address public owner;                           // Contract owner
    uint256 public eventCount;                      // Total number of events logged
    uint256 public constant MAX_MESSAGE_LENGTH = 500; // Maximum message length
    
    // Mappings
    mapping(uint256 => LoggedEvent) public events;  // Event ID to LoggedEvent
    mapping(address => uint256[]) public userEvents; // User address to their event IDs
    mapping(string => uint256[]) public categoryEvents; // Category to event IDs
    
    // Events (for blockchain event logging)
    event EventLogged(
        uint256 indexed eventId,
        address indexed submitter,
        string message,
        string category,
        uint256 timestamp
    );
    
    event EventUpdated(
        uint256 indexed eventId,
        address indexed submitter,
        bool isActive
    );
    
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    
    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }
    
    modifier validEventId(uint256 _eventId) {
        require(_eventId < eventCount, "Event does not exist");
        _;
    }
    
    modifier onlyEventSubmitter(uint256 _eventId) {
        require(
            events[_eventId].submitter == msg.sender,
            "Only the event submitter can perform this action"
        );
        _;
    }
    
    // Constructor
    constructor() {
        owner = msg.sender;
        eventCount = 0;
    }
    
    // Log a new event
    function logEvent(string memory _message, string memory _category) external {
        require(bytes(_message).length > 0, "Message cannot be empty");
        require(bytes(_message).length <= MAX_MESSAGE_LENGTH, "Message too long");
        
        // Create new event
        events[eventCount] = LoggedEvent({
            submitter: msg.sender,
            message: _message,
            timestamp: block.timestamp,
            category: _category,
            isActive: true
        });
        
        // Update mappings
        userEvents[msg.sender].push(eventCount);
        if (bytes(_category).length > 0) {
            categoryEvents[_category].push(eventCount);
        }
        
        // Emit event
        emit EventLogged(eventCount, msg.sender, _message, _category, block.timestamp);
        
        // Increment event count
        eventCount++;
    }
    
    // Get event details by ID
    function getEvent(uint256 _eventId) 
        external 
        view 
        validEventId(_eventId) 
        returns (
            address submitter,
            string memory message,
            uint256 timestamp,
            string memory category,
            bool isActive
        ) 
    {
        LoggedEvent memory loggedEvent = events[_eventId];
        return (
            loggedEvent.submitter,
            loggedEvent.message,
            loggedEvent.timestamp,
            loggedEvent.category,
            loggedEvent.isActive
        );
    }
    
    // Get all event IDs submitted by a specific user
    function getUserEvents(address _user) external view returns (uint256[] memory) {
        return userEvents[_user];
    }
    
    // Get all event IDs in a specific category
    function getCategoryEvents(string memory _category) external view returns (uint256[] memory) {
        return categoryEvents[_category];
    }
    
    // Get the latest N events
    function getLatestEvents(uint256 _count) 
        external 
        view 
        returns (uint256[] memory) 
    {
        require(_count > 0, "Count must be greater than 0");
        
        uint256 actualCount = _count > eventCount ? eventCount : _count;
        uint256[] memory latestEventIds = new uint256[](actualCount);
        
        for (uint256 i = 0; i < actualCount; i++) {
            latestEventIds[i] = eventCount - 1 - i;
        }
        
        return latestEventIds;
    }
    
    // Toggle event active status (only by event submitter)
    function toggleEventStatus(uint256 _eventId) 
        external 
        validEventId(_eventId) 
        onlyEventSubmitter(_eventId) 
    {
        events[_eventId].isActive = !events[_eventId].isActive;
        emit EventUpdated(_eventId, msg.sender, events[_eventId].isActive);
    }
    
    // Get events within a time range
    function getEventsByTimeRange(uint256 _startTime, uint256 _endTime) 
        external 
        view 
        returns (uint256[] memory) 
    {
        require(_startTime <= _endTime, "Start time must be before end time");
        
        // First pass: count matching events
        uint256 matchCount = 0;
        for (uint256 i = 0; i < eventCount; i++) {
            if (events[i].timestamp >= _startTime && events[i].timestamp <= _endTime) {
                matchCount++;
            }
        }
        
        // Second pass: collect matching event IDs
        uint256[] memory matchingEvents = new uint256[](matchCount);
        uint256 currentIndex = 0;
        
        for (uint256 i = 0; i < eventCount; i++) {
            if (events[i].timestamp >= _startTime && events[i].timestamp <= _endTime) {
                matchingEvents[currentIndex] = i;
                currentIndex++;
            }
        }
        
        return matchingEvents;
    }
    
    // Get total number of events by a user
    function getUserEventCount(address _user) external view returns (uint256) {
        return userEvents[_user].length;
    }
    
    // Get total number of events in a category
    function getCategoryEventCount(string memory _category) external view returns (uint256) {
        return categoryEvents[_category].length;
    }
    
    // Emergency function to transfer ownership (only owner)
    function transferOwnership(address _newOwner) external onlyOwner {
        require(_newOwner != address(0), "New owner cannot be zero address");
        require(_newOwner != owner, "New owner must be different from current owner");
        
        address previousOwner = owner;
        owner = _newOwner;
        
        emit OwnershipTransferred(previousOwner, _newOwner);
    }
    
    // Get contract stats
    function getContractStats() 
        external 
        view 
        returns (
            uint256 totalEvents,
            uint256 activeEvents,
            address contractOwner
        ) 
    {
        uint256 activeCount = 0;
        for (uint256 i = 0; i < eventCount; i++) {
            if (events[i].isActive) {
                activeCount++;
            }
        }
        
        return (eventCount, activeCount, owner);
    }
    
    // Check if an event exists and is active
    function isEventActive(uint256 _eventId) external view returns (bool) {
        if (_eventId >= eventCount) {
            return false;
        }
        return events[_eventId].isActive;
    }
}
