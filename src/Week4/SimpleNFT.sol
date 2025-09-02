// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.19;

// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/utils/Strings.sol";

// /**
//  * @title SimpleNFT
//  * @dev A basic ERC721 implementation for educational purposes
//  * Allows minting NFTs with duplicate metadata and includes basic transfer functionality
//  */
// contract SimpleNFT is ERC721, Ownable {
//     using Strings for uint256;

//     // Token counter for unique token IDs
//     uint256 private _tokenIdCounter;

//     // Mapping from token ID to token URI
//     mapping(uint256 => string) private _tokenURIs;

//     // Base URI for metadata
//     string private _baseTokenURI;

//     // Minting fee (can be 0 for free minting)
//     uint256 public mintingFee;

//     // Events
//     event TokenMinted(address indexed to, uint256 indexed tokenId, string tokenURI);
//     event BaseURIUpdated(string newBaseURI);
//     event MintingFeeUpdated(uint256 newFee);

//     constructor(string memory name, string memory symbol, string memory baseURI, uint256 _mintingFee)
//         ERC721(name, symbol)
//         Ownable(msg.sender)
//     {
//         _baseTokenURI = baseURI;
//         mintingFee = _mintingFee;
//     }

//     /**
//      * @dev Mint a new NFT to the specified address
//      * @param to Address to mint the NFT to
//      * @param tokenURI URI for the token metadata (can be duplicate)
//      */
//     function mint(address to, string memory tokenURI) public payable {
//         require(msg.value >= mintingFee, "Insufficient payment for minting");
//         require(to != address(0), "Cannot mint to zero address");

//         uint256 tokenId = _tokenIdCounter;
//         _tokenIdCounter++;

//         _safeMint(to, tokenId);
//         _setTokenURI(tokenId, tokenURI);

//         emit TokenMinted(to, tokenId, tokenURI);

//         // Refund excess payment
//         if (msg.value > mintingFee) {
//             payable(msg.sender).transfer(msg.value - mintingFee);
//         }
//     }

//     /**
//      * @dev Batch mint multiple NFTs to the same address
//      * @param to Address to mint the NFTs to
//      * @param tokenURIs Array of URIs for the token metadata
//      */
//     function batchMint(address to, string[] memory tokenURIs) public payable {
//         require(msg.value >= mintingFee * tokenURIs.length, "Insufficient payment for batch minting");
//         require(to != address(0), "Cannot mint to zero address");
//         require(tokenURIs.length > 0, "Must mint at least one token");
//         require(tokenURIs.length <= 20, "Cannot mint more than 20 tokens at once");

//         for (uint256 i = 0; i < tokenURIs.length; i++) {
//             uint256 tokenId = _tokenIdCounter;
//             _tokenIdCounter++;

//             _safeMint(to, tokenId);
//             _setTokenURI(tokenId, tokenURIs[i]);

//             emit TokenMinted(to, tokenId, tokenURIs[i]);
//         }

//         // Refund excess payment
//         uint256 totalCost = mintingFee * tokenURIs.length;
//         if (msg.value > totalCost) {
//             payable(msg.sender).transfer(msg.value - totalCost);
//         }
//     }

//     /**
//      * @dev Owner can mint for free (useful for educational demonstrations)
//      * @param to Address to mint the NFT to
//      * @param tokenURI URI for the token metadata
//      */
//     function ownerMint(address to, string memory tokenURI) public onlyOwner {
//         require(to != address(0), "Cannot mint to zero address");

//         uint256 tokenId = _tokenIdCounter;
//         _tokenIdCounter++;

//         _safeMint(to, tokenId);
//         _setTokenURI(tokenId, tokenURI);

//         emit TokenMinted(to, tokenId, tokenURI);
//     }

//     /**
//      * @dev Set the token URI for a specific token ID
//      * @param tokenId Token ID to set URI for
//      * @param tokenURI URI to set
//      */
//     function _setTokenURI(uint256 tokenId, string memory tokenURI) internal {
//         _tokenURIs[tokenId] = tokenURI;
//     }

//     /**
//      * @dev Get the token URI for a specific token ID
//      * @param tokenId Token ID to get URI for
//      * @return The token URI
//      */
//     function tokenURI(uint256 tokenId) public view override returns (string memory) {
//         _requireOwned(tokenId);

//         string memory _tokenURI = _tokenURIs[tokenId];
//         string memory base = _baseURI();

//         // If there is no base URI, return the token URI
//         if (bytes(base).length == 0) {
//             return _tokenURI;
//         }

//         // If both are set, concatenate the baseURI and tokenURI
//         if (bytes(_tokenURI).length > 0) {
//             return string(abi.encodePacked(base, _tokenURI));
//         }

//         // If only base URI is set, return baseURI + tokenId
//         return string(abi.encodePacked(base, tokenId.toString()));
//     }

//     /**
//      * @dev Get the base URI
//      * @return The base URI
//      */
//     function _baseURI() internal view override returns (string memory) {
//         return _baseTokenURI;
//     }

//     /**
//      * @dev Update the base URI (only owner)
//      * @param newBaseURI New base URI
//      */
//     function setBaseURI(string memory newBaseURI) public onlyOwner {
//         _baseTokenURI = newBaseURI;
//         emit BaseURIUpdated(newBaseURI);
//     }

//     /**
//      * @dev Update the minting fee (only owner)
//      * @param newFee New minting fee
//      */
//     function setMintingFee(uint256 newFee) public onlyOwner {
//         mintingFee = newFee;
//         emit MintingFeeUpdated(newFee);
//     }

//     /**
//      * @dev Get the total number of tokens minted
//      * @return The total supply
//      */
//     function totalSupply() public view returns (uint256) {
//         return _tokenIdCounter;
//     }

//     /**
//      * @dev Get all tokens owned by an address
//      * @param owner Address to check
//      * @return Array of token IDs
//      */
//     function tokensOfOwner(address owner) public view returns (uint256[] memory) {
//         uint256 tokenCount = balanceOf(owner);
//         uint256[] memory tokens = new uint256[](tokenCount);
//         uint256 index = 0;

//         for (uint256 tokenId = 0; tokenId < _tokenIdCounter; tokenId++) {
//             if (_ownerOf(tokenId) == owner) {
//                 tokens[index] = tokenId;
//                 index++;
//             }
//         }

//         return tokens;
//     }

//     /**
//      * @dev Withdraw contract balance (only owner)
//      */
//     function withdraw() public onlyOwner {
//         uint256 balance = address(this).balance;
//         require(balance > 0, "No funds to withdraw");

//         (bool success,) = payable(owner()).call{value: balance}("");
//         require(success, "Withdrawal failed");
//     }

//     /**
//      * @dev Emergency withdraw to specific address (only owner)
//      * @param to Address to send funds to
//      */
//     function emergencyWithdraw(address payable to) public onlyOwner {
//         require(to != address(0), "Cannot withdraw to zero address");
//         uint256 balance = address(this).balance;
//         require(balance > 0, "No funds to withdraw");

//         (bool success,) = to.call{value: balance}("");
//         require(success, "Emergency withdrawal failed");
//     }

//     /**
//      * @dev Check if contract supports an interface
//      * @param interfaceId Interface ID to check
//      * @return True if interface is supported
//      */
//     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
//         return super.supportsInterface(interfaceId);
//     }
// }
