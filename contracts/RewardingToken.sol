//SPDX - Identifier : Unlicensed
pragma solidity 0.8.23;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Token is ERC20,Ownable{
    constructor()ERC20("RewardingToken","RTKN") Ownable(msg.sender){}

    function mint() external {
        _mint(msg.sender,3000e18);
    }

}