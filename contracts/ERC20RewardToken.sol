//SPDX - Identifier : Unlicensed
pragma solidity 0.8.23;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract Token is ERC20, Ownable, IERC721Receiver {
    mapping(address => uint256) private withdrawTokens;
    mapping(address => uint256) private lastWithdrawnTime;
    mapping(uint256 => address) private originalOwner;
    uint256 private completed24Hours = 86400;
    uint256 private dailyTokenLimit = 10e6;
    mapping(uint256 => uint256) private timeWhenNFTDeposited;
    mapping(uint256 => address) private newOwner;

    constructor() ERC20("RewardingToken", "RTKN") Ownable(msg.sender) {}

    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
        external
        returns (bytes4)
    {
        timeWhenNFTDeposited[tokenId] = block.timestamp;
        originalOwner[tokenId] = from;
        return IERC721Receiver.onERC721Received.selector;
    }

    function withdrawERC20Tokens(uint256 tokenId) external {
        require(originalOwner[tokenId] != address(0), "tokenId not present in this contract");
        require(originalOwner[tokenId] == msg.sender, "not a original NFT token owner");
        require(
            block.timestamp - lastWithdrawnTime[msg.sender] >= completed24Hours, "one withdrawal per day is allowed"
        );
        uint256 stakingTime = (block.timestamp - timeWhenNFTDeposited[tokenId]) / completed24Hours;
        require(stakingTime >= 1, "tokens can be withdrawn after 24 hours only");
        uint256 maxTokenAvailable = stakingTime * dailyTokenLimit;
        uint256 alreadyWithdrawn = withdrawTokens[msg.sender];
        uint256 tokensToWithdraw = maxTokenAvailable - alreadyWithdrawn;
        require(tokensToWithdraw > 0, "No tokens to withdraw");
        withdrawTokens[msg.sender] += tokensToWithdraw;
        lastWithdrawnTime[msg.sender] = block.timestamp;
        _mint(msg.sender, tokensToWithdraw);
    }
}
