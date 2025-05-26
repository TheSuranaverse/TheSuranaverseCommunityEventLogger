# TheSuranaverse Community Event Logger Smart Contract

A decentralized event logging system built on blockchain technology that allows users to submit and track messages/events with immutable timestamps for public history tracking.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Contract Architecture](#contract-architecture)
- [Getting Started](#getting-started)
- [Deployment Guide](#deployment-guide)
- [Usage Examples](#usage-examples)
- [API Reference](#api-reference)
- [Security Features](#security-features)
- [Testing](#testing)
- [Contributing](#contributing)
- [License](#license)

## 🌟 Overview

The Event Logger smart contract provides a transparent, immutable way to log events and messages on the blockchain. Each entry is timestamped and publicly accessible, making it perfect for audit trails, historical records, or any application requiring tamper-proof event tracking.

**Live Contract**: [View on Core DAO Testnet Explorer](https://scan.test.btcs.network)

## ✨ Features

### Core Functionality
- **📝 Event Logging**: Submit messages with automatic timestamping
- **🏷️ Categorization**: Organize events with custom categories
- **👤 User Tracking**: Track all events submitted by specific users
- **⏰ Time-based Queries**: Retrieve events within specific time ranges
- **🔍 Public Access**: All events are publicly viewable and verifiable

### Advanced Features
- **📊 Statistics Dashboard**: Get contract-wide statistics
- **🔄 Event Status Management**: Toggle event active/inactive status
- **📈 Latest Events**: Retrieve most recent N events
- **🎯 Category Filtering**: Query events by category
- **📋 Comprehensive Analytics**: User and category event counts

## 🏗️ Contract Architecture

```
EventLogger
├── Structs
│   └── LoggedEvent (submitter, message, timestamp, category, isActive)
├── State Variables
│   ├── owner (contract owner)
│   ├── eventCount (total events)
│   └── MAX_MESSAGE_LENGTH (500 characters)
├── Mappings
│   ├── events (eventId → LoggedEvent)
│   ├── userEvents (user → eventIds[])
│   └── categoryEvents (category → eventIds[])
└── Functions
    ├── Core Functions
    │   ├── logEvent()
    │   ├── getEvent()
    │   └── toggleEventStatus()
    ├── Query Functions
    │   ├── getUserEvents()
    │   ├── getCategoryEvents()
    │   ├── getLatestEvents()
    │   ├── getEventsByTimeRange()
    │   └── getContractStats()
    └── Admin Functions
        └── transferOwnership()
```

## 🚀 Getting Started

### Prerequisites

- **Wallet**: MetaMask or compatible Web3 wallet
- **Network**: Core DAO Testnet configured
- **Tokens**: Test tCORE tokens for gas fees
- **Development**: Remix IDE or local development environment

### Network Configuration

Add Core DAO Testnet to your wallet:

```
Network Name: Core Blockchain Testnet
RPC URL: https://rpc.test.btcs.network
Chain ID: 1115
Currency Symbol: tCORE
Block Explorer: https://scan.test.btcs.network
```

### Get Test Tokens

Visit the [Core DAO Testnet Faucet](https://scan.test.btcs.network/faucet) to receive test tCORE tokens.

## 📦 Deployment Guide

### Using Remix IDE

1. **Setup Environment**
   ```
   1. Open https://remix.ethereum.org
   2. Create new file: EventLogger.sol
   3. Copy contract code
   4. Set compiler version: ^0.8.0
   ```

2. **Compile Contract**
   ```
   1. Go to Solidity Compiler tab
   2. Click "Compile EventLogger.sol"
   3. Verify no compilation errors
   ```

3. **Deploy Contract**
   ```
   1. Go to Deploy & Run Transactions tab
   2. Environment: "Injected Provider - MetaMask"
   3. Connect MetaMask to Core DAO testnet
   4. Select EventLogger contract
   5. Gas Limit: 3,000,000 (recommended)
   6. Value: 0 (leave empty)
   7. Click Deploy
   8. Confirm transaction in MetaMask
   ```

### Using Hardhat

```javascript
// hardhat.config.js
module.exports = {
  networks: {
    coreTestnet: {
      url: "https://rpc.test.btcs.network",
      accounts: [process.env.PRIVATE_KEY],
      chainId: 1115
    }
  }
};
```

```bash
npx hardhat run scripts/deploy.js --network coreTestnet
```

## 💡 Usage Examples

### Basic Event Logging

```javascript
// Log a simple event
await eventLogger.logEvent("System maintenance completed", "Maintenance");

// Log with category
await eventLogger.logEvent("New user registered", "User Management");

// Log achievement
await eventLogger.logEvent("1000th transaction milestone reached", "Milestones");
```

### Querying Events

```javascript
// Get specific event
const event = await eventLogger.getEvent(0);
console.log(`Message: ${event.message}, Submitter: ${event.submitter}`);

// Get user's events
const userEventIds = await eventLogger.getUserEvents(userAddress);

// Get latest 10 events
const latestEvents = await eventLogger.getLatestEvents(10);

// Get events by category
const maintenanceEvents = await eventLogger.getCategoryEvents("Maintenance");
```

### Time-based Queries

```javascript
// Get events from last 24 hours
const now = Math.floor(Date.now() / 1000);
const yesterday = now - 86400;
const recentEvents = await eventLogger.getEventsByTimeRange(yesterday, now);
```

### Contract Statistics

```javascript
const stats = await eventLogger.getContractStats();
console.log(`Total Events: ${stats.totalEvents}`);
console.log(`Active Events: ${stats.activeEvents}`);
```

## 📚 API Reference

### Core Functions

#### `logEvent(string memory _message, string memory _category)`
Logs a new event with message and optional category.
- **Parameters**: 
  - `_message`: Event message (max 500 characters)
  - `_category`: Optional category for organization
- **Events**: Emits `EventLogged`
- **Requirements**: Message cannot be empty

#### `getEvent(uint256 _eventId)`
Retrieves event details by ID.
- **Returns**: `(address submitter, string message, uint256 timestamp, string category, bool isActive)`

#### `toggleEventStatus(uint256 _eventId)`
Toggles event active/inactive status (only by submitter).
- **Requirements**: Only event submitter can call

### Query Functions

#### `getUserEvents(address _user)`
Returns array of event IDs submitted by user.

#### `getCategoryEvents(string memory _category)`
Returns array of event IDs in specified category.

#### `getLatestEvents(uint256 _count)`
Returns array of latest N event IDs.

#### `getEventsByTimeRange(uint256 _startTime, uint256 _endTime)`
Returns event IDs within time range.

#### `getContractStats()`
Returns contract statistics: total events, active events, owner.

## 🔒 Security Features

### Access Control
- **Owner Functions**: Only contract owner can transfer ownership
- **Event Management**: Only event submitters can modify their events
- **Input Validation**: Message length limits and empty message checks

### Data Integrity
- **Immutable Timestamps**: Block timestamp ensures accuracy
- **Event Persistence**: Events cannot be deleted, only marked inactive
- **Address Verification**: All submissions tied to wallet addresses

### Gas Optimization
- **Efficient Storage**: Optimized struct packing
- **Batch Queries**: Multiple events retrieved in single call
- **View Functions**: Read operations consume no gas

## 🧪 Testing

### Test Scenarios

1. **Basic Functionality**
   ```solidity
   // Test event logging
   logEvent("Test message", "Test");
   
   // Verify event storage
   getEvent(0);
   
   // Check event count
   assert(eventCount == 1);
   ```

2. **User Management**
   ```solidity
   // Test user event tracking
   getUserEvents(msg.sender);
   
   // Test event status toggle
   toggleEventStatus(0);
   ```

3. **Query Functions**
   ```solidity
   // Test category filtering
   getCategoryEvents("Test");
   
   // Test time range queries
   getEventsByTimeRange(startTime, endTime);
   ```

### Running Tests

```bash
# Using Hardhat
npx hardhat test

# Using Truffle
truffle test

# Using Remix
# Use the built-in testing framework in Remix IDE
```

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **Fork the Repository**
   ```bash
   git fork https://github.com/yourusername/event-logger-contract
   ```

2. **Create Feature Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make Changes**
   - Add new features or fix bugs
   - Include comprehensive tests
   - Update documentation

4. **Submit Pull Request**
   - Describe your changes
   - Include test results
   - Reference any related issues

### Development Guidelines

- Follow Solidity best practices
- Include natspec comments for all functions
- Maintain gas efficiency
- Add comprehensive tests for new features
- Update README for significant changes

## 🛠️ Development Roadmap

- [ ] **Frontend Interface**: Web3 frontend for easy interaction
- [ ] **Event Search**: Full-text search capabilities
- [ ] **Event Reactions**: Like/dislike functionality
- [ ] **Moderation Tools**: Community moderation features
- [ ] **Export Features**: CSV/JSON export capabilities
- [ ] **Analytics Dashboard**: Advanced statistics and charts

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Links

- **Contract Source**: [EventLogger.sol](./contracts/EventLogger.sol)
- **Core DAO**: [Official Website](https://coredao.org/)
- **Testnet Explorer**: [Core DAO Testnet](https://scan.test.btcs.network)
- **Documentation**: [Core DAO Docs](https://docs.coredao.org/)

## ⚠️ Disclaimer

This smart contract is provided as-is for educational and development purposes. While security best practices have been followed, please conduct thorough testing and auditing before using in production environments.

---

**Built with ❤️ for the Core DAO ecosystem**
