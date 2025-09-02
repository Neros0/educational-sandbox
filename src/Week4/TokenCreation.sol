// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.19;

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";

// /**
//  * @title TokenCreation
//  * @dev Basic ERC20 token that can be deployed by the factory
//  */
// contract TokenCreation is ERC20, Ownable {
//     uint8 private _decimals;
//     uint256 public maxSupply;
//     string private _description;
//     string private _imageUrl;
//     address public creator;

//     event TokenCreated(address indexed token, address indexed creator, string name, string symbol, uint256 totalSupply);

//     constructor(
//         string memory name,
//         string memory symbol,
//         uint8 decimals_,
//         uint256 totalSupply,
//         string memory description,
//         string memory imageUrl,
//         address creator_
//     ) ERC20(name, symbol) Ownable(creator_) {
//         _decimals = decimals_;
//         maxSupply = totalSupply;
//         _description = description;
//         _imageUrl = imageUrl;
//         creator = creator_;

//         // Mint total supply to creator
//         _mint(creator_, totalSupply);

//         emit TokenCreated(address(this), creator_, name, symbol, totalSupply);
//     }

//     function decimals() public view override returns (uint8) {
//         return _decimals;
//     }

//     function description() public view returns (string memory) {
//         return _description;
//     }

//     function imageUrl() public view returns (string memory) {
//         return _imageUrl;
//     }

//     function burn(uint256 amount) public {
//         _burn(msg.sender, amount);
//     }

//     function burnFrom(address account, uint256 amount) public {
//         _spendAllowance(account, msg.sender, amount);
//         _burn(account, amount);
//     }
// }

// /**
//  * @title TokenFactory
//  * @dev Factory contract for creating new tokens
//  */
// contract TokenFactory {
//     struct TokenInfo {
//         address tokenAddress;
//         address creator;
//         string name;
//         string symbol;
//         uint256 totalSupply;
//         string description;
//         string imageUrl;
//         uint256 createdAt;
//     }

//     mapping(address => TokenInfo) public tokens;
//     address[] public allTokens;
//     mapping(address => address[]) public creatorTokens;

//     uint256 public creationFee = 0 ether; // Fee to create a token
//     address public feeRecipient;

//     event TokenCreated(
//         address indexed token,
//         address indexed creator,
//         string name,
//         string symbol,
//         uint256 totalSupply,
//         string description,
//         string imageUrl
//     );

//     event CreationFeeUpdated(uint256 newFee);
//     event FeeRecipientUpdated(address newRecipient);

//     constructor(address _feeRecipient) {
//         feeRecipient = _feeRecipient;
//     }

//     modifier onlyOwner() {
//         require(msg.sender == feeRecipient, "Not authorized");
//         _;
//     }

//     /**
//      * @dev Creates a new token
//      * @param name Token name
//      * @param symbol Token symbol
//      * @param decimals Token decimals
//      * @param totalSupply Total supply of tokens
//      * @param description Token description
//      * @param imageUrl Token image URL
//      */
//     function createToken(
//         string memory name,
//         string memory symbol,
//         uint8 decimals,
//         uint256 totalSupply,
//         string memory description,
//         string memory imageUrl
//     ) external payable returns (address) {
//         require(msg.value >= creationFee, "Insufficient fee");
//         require(bytes(name).length > 0, "Name cannot be empty");
//         require(bytes(symbol).length > 0, "Symbol cannot be empty");
//         require(totalSupply > 0, "Total supply must be greater than 0");

//         // Deploy new token
//         TokenCreation newToken =
//             new TokenCreation(name, symbol, decimals, totalSupply, description, imageUrl, msg.sender);

//         address tokenAddress = address(newToken);

//         // Store token info
//         tokens[tokenAddress] = TokenInfo({
//             tokenAddress: tokenAddress,
//             creator: msg.sender,
//             name: name,
//             symbol: symbol,
//             totalSupply: totalSupply,
//             description: description,
//             imageUrl: imageUrl,
//             createdAt: block.timestamp
//         });

//         allTokens.push(tokenAddress);
//         creatorTokens[msg.sender].push(tokenAddress);

//         // Send fee to recipient
//         if (msg.value > 0) {
//             payable(feeRecipient).transfer(msg.value);
//         }

//         emit TokenCreated(tokenAddress, msg.sender, name, symbol, totalSupply, description, imageUrl);

//         return tokenAddress;
//     }

//     /**
//      * @dev Get all tokens created by a specific creator
//      */
//     function getTokensByCreator(address creator) external view returns (address[] memory) {
//         return creatorTokens[creator];
//     }

//     /**
//      * @dev Get total number of tokens created
//      */
//     function getTotalTokens() external view returns (uint256) {
//         return allTokens.length;
//     }

//     /**
//      * @dev Get token info by address
//      */
//     function getTokenInfo(address tokenAddress) external view returns (TokenInfo memory) {
//         return tokens[tokenAddress];
//     }

//     /**
//      * @dev Get paginated list of all tokens
//      */
//     function getTokens(uint256 offset, uint256 limit) external view returns (TokenInfo[] memory) {
//         uint256 totalTokens = allTokens.length;

//         if (offset >= totalTokens) {
//             return new TokenInfo[](0);
//         }

//         uint256 end = offset + limit;
//         if (end > totalTokens) {
//             end = totalTokens;
//         }

//         TokenInfo[] memory result = new TokenInfo[](end - offset);

//         for (uint256 i = offset; i < end; i++) {
//             result[i - offset] = tokens[allTokens[i]];
//         }

//         return result;
//     }

//     /**
//      * @dev Update creation fee (only owner)
//      */
//     function updateCreationFee(uint256 newFee) external onlyOwner {
//         creationFee = newFee;
//         emit CreationFeeUpdated(newFee);
//     }

//     /**
//      * @dev Update fee recipient (only owner)
//      */
//     function updateFeeRecipient(address newRecipient) external onlyOwner {
//         require(newRecipient != address(0), "Invalid recipient");
//         feeRecipient = newRecipient;
//         emit FeeRecipientUpdated(newRecipient);
//     }
// }
