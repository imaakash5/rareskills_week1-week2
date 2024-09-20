//SPDX - Identifier : Unlicensed
pragma solidity 0.8.23;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import {Test,console} from "forge-std/Test.sol";

contract Token is ERC20, Ownable, IERC721Receiver {
    mapping(address => uint256) private withdrawTokens;
    mapping(address => uint256) private lastWithdrawnTime;
    uint256 private completed24Hours = 86400;
    uint256 private dailyTokenLimit = 10;
    mapping(uint256 =>uint256) private timeWhenNFTDeposited;
    mapping(uint256 => address) private newOwner;
    constructor() ERC20("RewardingToken", "RTKN") Ownable(msg.sender) {}

    function mint() external onlyOwner{
        _mint(msg.sender, 3000e6);
    }

    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
        external
        returns (bytes4)
    {  timeWhenNFTDeposited[tokenId]= block.timestamp;
        newOwner[tokenId]=address(this);
        console.log(timeWhenNFTDeposited[tokenId], "deposit time of NFT in contract");
        return IERC721Receiver.onERC721Received.selector;
    }

    function withdrawERC20Tokens(uint256 tokenId) external {
        require(balanceOf(address(this)) > 10e6, "Insufficient balance");
        uint256 stakingTime = (block.timestamp - timeWhenNFTDeposited[tokenId]) / completed24Hours;
        require(stakingTime >= 1, "tokens can be withdrawn after 24 hours only");
        uint256 maxTokenAvailable = stakingTime * dailyTokenLimit;
        uint256 alreadyWithdrawn = withdrawTokens[msg.sender];
        uint256 tokensToWithdraw = maxTokenAvailable - alreadyWithdrawn;
        require(tokensToWithdraw > 0, "No tokens to withdraw");
        withdrawTokens[msg.sender] += tokensToWithdraw;
        //lastWithdrawalTime[msg.sender] = block.timestamp;
        transferFrom(address(this), msg.sender, tokensToWithdraw);
    }
}
