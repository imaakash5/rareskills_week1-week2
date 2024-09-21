// SPDX-License-Identifier: Unlicensed
pragma solidity 0.8.23;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTRoyalty is ERC721, ERC2981, Ownable {
    constructor() ERC721("NFT with Royalties", "NFT") Ownable(msg.sender) {
        _setDefaultRoyalty(msg.sender, 250);
    }

    uint256 private constant maxSupply = 20;
    uint256 public totalSupply = 0;
    mapping(uint256 => address) private tokenHolders;

    function mint() external onlyOwner {
        require(totalSupply < maxSupply);
        _mint(msg.sender, totalSupply);
        totalSupply++;
    }

    function checkRoyaltyForTokens() external view onlyOwner {
        for (uint256 i = 0; i < totalSupply; i++) {
            royaltyInfo(i, 10e6);
        }
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC2981) returns (bool) {
        return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
    }
}
