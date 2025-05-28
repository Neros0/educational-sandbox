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
}
