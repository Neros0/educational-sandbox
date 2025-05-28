// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title CertificateStorage
 * @dev A decentralized certificate/credential storage system for issuing and verifying certificates
 */
contract CertificateStorage {
    struct Certificate {
        uint256 id;
        address issuer;
        address recipient;
        string title;
        string description;
        string metadataHash; // IPFS hash or other metadata reference
        uint256 issuedAt;
        uint256 expiresAt; // 0 for non-expiring certificates
        bool revoked;
        uint256 revokedAt;
    }

    // Storage
    Certificate[] public certificates;
    mapping(uint256 => bool) public certificateExists;
    mapping(address => uint256[]) public issuerCertificates;
    mapping(address => uint256[]) public recipientCertificates;
    mapping(address => bool) public authorizedIssuers;

    // Stats
    uint256 public totalCertificates;
    uint256 private nextCertificateId;

    // Admin
    address public admin;

    event CertificateIssued(
        uint256 indexed certificateId, address indexed issuer, address indexed recipient, string title
    );

    event CertificateRevoked(uint256 indexed certificateId, address indexed issuer, uint256 revokedAt);

    event IssuerAuthorized(address indexed issuer);
    event IssuerRevoked(address indexed issuer);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    modifier onlyAuthorizedIssuer() {
        require(authorizedIssuers[msg.sender], "Not an authorized issuer");
        _;
    }

    modifier validCertificate(uint256 _certificateId) {
        require(certificateExists[_certificateId], "Certificate does not exist");
        _;
    }
}
