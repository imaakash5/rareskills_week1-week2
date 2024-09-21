//SPDX - License - Identifier : Unlicensed
pragma solidity 0.8.23;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";

contract NFTEnumerableCount is ERC721Enumerable {
    //IERC721 private NFTToken;
    constructor() ERC721("NFTEnumerbale", "SYMBL") {
        for (uint256 i = 1; i <= 40; i++) {
            _mint(msg.sender, i);
        }

        //NFTToken = IERC721(token);
    }

    function countPrimeNFTAtAddress(address addr) external returns (uint64) {
        uint64 count = 0;
        uint64 flag = 0;
        uint256 tokensOwned = balanceOf(addr);
        uint256[] memory arrOfTokenId = new uint256[](tokensOwned);
        //fetched all the tokens owned by address
        for (uint256 i = 0; i < tokensOwned; i++) {
            arrOfTokenId[i] = tokenOfOwnerByIndex(addr, i);
        }

        //count only the tokenIds which are prime number
        for (uint256 i = 0; i < arrOfTokenId.length; i++) {
            if (arrOfTokenId[i] != 1) {
                uint256 sqrtTokenId = Math.sqrt(arrOfTokenId[i]);
                for (uint256 j = 1; j <= sqrtTokenId; j++) {
                    if (arrOfTokenId[i] % j == 0) {
                        count += 1;
                    }
                }
            }
            if (count == 1) {
                flag++;
            }
            count = 0;
        }
        return flag;
    }
}
