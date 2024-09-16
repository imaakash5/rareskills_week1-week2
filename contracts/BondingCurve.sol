//SPDX - Identifier : Unlicensed
pragma solidity ^0.8.23;

import "../contracts/BancorFormula.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {console} from "forge-std/Test.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BondingCurve is ERC20, BancorFormula {
    uint256 public supply_;
    uint256 public connectorBalance; //stable tokens balance in contract
    uint32 public connectorWeight; // defines the parts per million 1 to 1,000,000 - 100%
    IERC20 public usdc;

    constructor(uint256 connectorBalance_, uint32 connectorWeight_, address token_) ERC20("BondingCurve", "BCT") {
        usdc = IERC20(token_);
        connectorBalance = connectorBalance_;
        connectorWeight = connectorWeight_;
        _mint(msg.sender, 1000000e6);
        console.log(connectorBalance, "Initial tokens reserved in the contract");
        console.log(connectorWeight, "The weight is 50%");
    }

    function buy(uint256 amount_) external {
        require(msg.sender != address(0), "Zero address");
        require(amount_ <= usdc.balanceOf(msg.sender), "Insufficient balance");
        usdc.transferFrom(msg.sender, address(this), amount_);
        uint256 tokensToMint = calculatePurchaseReturn(totalSupply(), connectorBalance, connectorWeight, amount_);
        console.log(tokensToMint, "Purchased tokens");
        _mint(msg.sender, tokensToMint);
        console.log(totalSupply(), "total Supply after minting and transferring the tokens to the user");
        connectorBalance += amount_;
        console.log(connectorBalance, "Reserved tokens or stable coins present in the contract");
    }

    function sell(uint256 amount) external {
        require(msg.sender != address(0), "Seller is zero address");
        require(amount <= balanceOf(msg.sender), "User's Insufficient balance ");
        console.log(amount, "tokens return");
        console.log(balanceOf(msg.sender), "tokens user have");
        uint256 returnAmount = calculateSaleReturn(totalSupply(), connectorBalance, connectorWeight, amount);
        console.log(returnAmount, "USDC returned");
        usdc.approve(address(this), returnAmount);
        usdc.transferFrom(address(this), msg.sender, returnAmount);
        connectorBalance -= returnAmount;
        _burn(msg.sender, amount);
    }

    function getBalanceArbitraryToken(address addr) external view returns (uint256 balance_) {
        balance_ = balanceOf(addr);
    }

    function getUSDCBalUser(address addr) external view returns (uint256 balance_) {
        balance_ = usdc.balanceOf(addr);
    }

    receive() external payable {}
}
