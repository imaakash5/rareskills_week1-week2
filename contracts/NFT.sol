//SPDX-Identifier : Unlicensed
pragma solidity 0.8.23;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFT is ERC721, Ownable {
    constructor() ERC721("FirstCollection", "RCKNROLL") Ownable(msg.sender) {}

    uint256 private constant maxSupply = 20;
    uint256 public totalSupply = 0;

    function mint() external onlyOwner {
        for (uint256 i = totalSupply; i < maxSupply; i++) {
            require(totalSupply < maxSupply);
            _mint(msg.sender, totalSupply);
            totalSupply++;
        }
    }
}
