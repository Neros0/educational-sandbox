# Smart Contracts Collection
A collection of basic, gas-efficient smart contracts built with Solidity and Foundry. These contracts are designed to be simple, educational, and require no ETH deposits (only gas fees for transactions).

## 🎯 Project Goals
- Create simple smart contracts for learning and portfolio purposes
- No complex DeFi mechanics or ETH deposits required
- Focus on core Solidity patterns and best practices
- Built using Foundry framework for testing and deployment

## 📋 Contract Categories
### Data Storage Contracts
Store and manage user information on-chain without requiring payments.
### Social/Community Contracts
Enable community interactions and social features.
### Utility/Registry Contracts
Provide useful registry and tracking functionality.
### Educational/Demo Contracts
Demonstrate core Solidity concepts and patterns.

## 🛠 Technology Stack

- Solidity ^0.8.19 - Smart contract language
- Foundry - Development framework
- OpenZeppelin (when needed) - Security standards

## 🚀 Getting Started
### Prerequisites

- Foundry
- Git

### Installation
```bash
# Clone the repository
git clone <your-repo-url>
cd simple-smart-contracts

# Install dependencies
forge install

# Build contracts
forge build

# Run tests
forge test
```

## 📁 Project Structure
```text
├── src/
│   ├── PersonalRegistry.sol
│   ├── Guestbook.sol
│   ├── CertificateStorage.sol
│   └── [additional contracts]
├── test/
│   ├── PersonalRegistry.t.sol
│   ├── Guestbook.t.sol
│   └── [test files]
├── script/
│   ├── Deploy.s.sol
│   └── [deployment scripts]
├── lib/
└── README.md
```

## 🔧 Contract Features
### Common Patterns Used

- Struct-based data organization
- Mapping for efficient lookups
- Event emission for frontend integration
- Input validation and error handling
- Gas-efficient storage patterns

### Security Considerations

- Input validation on all public functions
- Access control where appropriate
- Protection against common vulnerabilities
- Safe arithmetic operations

## 📊 Gas Efficiency
All contracts are optimized for gas efficiency:

- Minimal storage operations
- Efficient data structures
- Batch operations where possible
- No unnecessary computations

## 🤝 Contributing
Feel free to contribute additional simple contracts or improvements:

- Fork the repository
- Create a feature branch
- Add your contract with tests
- Update this README
- Submit a pull request

## 📜 License
This project is licensed under the MIT License - see the LICENSE file for details.

## 🎓 Educational Use
These contracts are perfect for:

- Learning Solidity fundamentals
- Understanding smart contract patterns
- Portfolio development
- Teaching blockchain development
- Foundry framework practice