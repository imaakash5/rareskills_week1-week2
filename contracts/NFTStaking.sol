//SPDX - Identifier : Unlicensed
pragma solidity 0.8.23;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";


contract NFT is ERC721, Ownable {
    uint256 private MAX_SUPPLY = 20;
    uint256 private totalSupply = 0;
    address private token;
    mapping(uint256 => address) private originalOwner;

    constructor(address token_) ERC721("NFTGAME", "NFT") Ownable(msg.sender) {
        token = token_;
    }

    function withdrawNFT(uint256 tokenId) external {
        require(originalOwner[tokenId] == msg.sender, "not a original owner");
        safeTransferFrom(address(token), msg.sender, tokenId);
    }

    function sendTokens(uint256 tokenId, address from, address to) external {
        require(originalOwner[tokenId] == from, "not the owner");
        safeTransferFrom(from, to , tokenId);
    }

    function mint(uint256 tokenId) external onlyOwner {
        require(totalSupply < MAX_SUPPLY, "Supply limit crossed");
        originalOwner[tokenId] = msg.sender;
        _mint(msg.sender, tokenId);
        totalSupply++;
    }
}
