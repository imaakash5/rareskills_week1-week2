//SPDX -Identifier : Unlicensed
pragma solidity 0.8.23;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";



contract NFTRoyalty is ERC721, ERC2981, Ownable {
    bytes32 root;
    IERC20 public coin;
    uint256 private salePrice = 10e6; //fixing at 10USDC
    uint256 private discount = 100; //1% - 1pm 
    uint256 private constant maxSupply = 20;
    uint256 public totalSupply = 0;
    mapping(address=>bool) hasMinted;

    constructor(bytes32  root_, address token) ERC721("NFT with Royalties", "NFT") Ownable(msg.sender) {
        coin = IERC20(token);
        root=root_;
        _setDefaultRoyalty(msg.sender,250);  //setting the reward rate as 2.5 %
         }
    
    function mint(bytes32 proof) public{
        require(msg.sender!=address(0),"Invalid caller");
         //require(!hasMinted[msg.sender],"Already minted"); //required when the same user can not mint again
         (bool isAddressEligibleForDiscount) =  MerkleProof.verify(proof,root,keccak256(abi.encodePacked(msg.sender)));
         if(isAddressEligibleForDiscount)
         {uint changedSalePrice = (discount/10000) * salePrice;
            salePrice = changedSalePrice;} 
        require(coin.balanceOf(msg.sender)>=salePrice,"Insufficient Balance");
        require(totalSupply < maxSupply);
        _mint(msg.sender, totalSupply);
        totalSupply++;
    }

    function setDiscount(uint256 discount_) external onlyOwner{
            discount = discount_;
    }

    function setRoyaltyInfo() external onlyOwner{
        for (uint256 i = 0; i < totalSupply; i++) {
         (address royaltyReceiver, uint256 royaltyAmount) = royaltyInfo(i, salePrice);
    }
    }

    function getSalePrice() external returns(uint256 salePrice_) {
        salePrice_=salePrice; 
    }

    function setSalePrice(uint256 salePrice_) external onlyOwner{
        salePrice = salePrice_;
    }


    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC2981) returns (bool) {
        return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
    }
}
