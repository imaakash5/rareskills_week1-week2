//SPDX - Identifier : Unlicensed
pragma solidity 0.8.23;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTEnumerable is ERC721Enumerable {
    uint64 private MAX_SUPPLY = 20;

    constructor() ERC721("NFTEnumerableProMAX", "NFTENML") {
       for(uint64 i=1;i<=MAX_SUPPLY;i++){
        _safeMint(msg.sender, i);
        }
    }

}
