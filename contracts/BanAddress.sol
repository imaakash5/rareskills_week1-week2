//SPDX - Identifier : Unlicensed
pragma solidity 0.8.23;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BanAddress is Ownable, ERC20 {
    constructor() ERC20("Token", "TKN") Ownable(msg.sender) {
        _mint(msg.sender, 1000 * 1e18);
    }

    mapping(address => bool) public iswhiteListedToken;

    event addressNotBanned(address indexed user);

    function setWhiteListedToken(address user_, bool value_) external onlyOwner {
        iswhiteListedToken[user_] = value_;
    }

    function getWhiteListedToken(address user_) public returns (bool success_) {
        success_ = iswhiteListedToken[user_];
        if (success_) {
            emit addressNotBanned(user_);
        }
    }

    function safeTransferFrom(address from, address to, uint256 value) public {
        if (getWhiteListedToken(to) && getWhiteListedToken(from)) {
            super.transferFrom(from, to, value);
        }
    }
}
//token banned to send any tokens

contract Token2 is Ownable, ERC20 {
    constructor() ERC20("Token2", "TKN2") Ownable(msg.sender) {
        _mint(msg.sender, 2000 * 1e18);
    }
}

//Token accepted by main token
contract Token3 is Ownable, ERC20 {
    constructor() ERC20("Token3", "TKN3") Ownable(msg.sender) {
        _mint(msg.sender, 2000 * 1e18);
    }
}
