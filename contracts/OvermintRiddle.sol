//SPDX - License - Identifier : Unlicensed
pragma solidity 0.8.23;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Test, console} from "forge-std/Test.sol";

contract Overmint is ERC721{
    constructor()ERC721("OVERMINT","AT"){}
    uint256 public totalSupply;
    mapping(address=>uint256) public amountMinted;
    uint256 public price = 1e6;

    function mint() external payable{
        require(amountMinted[msg.sender]<=3,"max 3 NFTs");
         totalSupply++;
         require(msg.value>=price,"Insufficient funds");
         (bool success_,)=msg.sender.call{value: msg.value}("");
         require(success_, "transfer failed");
        _mint(msg.sender,totalSupply);
        amountMinted[msg.sender]++;
        console.log(amountMinted[msg.sender]);
    }

    function success(address attacker_) external view returns (bool){
        return balanceOf(attacker_)==5;
    }
}