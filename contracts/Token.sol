//SPDX - Identifier : Unlicensed
pragma solidity 0.8.23;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ArbitToken is ERC20, Ownable {
    constructor() ERC20("Arbitrary Token", "ARBTKN") Ownable(msg.sender) {
        _mint(msg.sender, 2000e18);
    }
}
