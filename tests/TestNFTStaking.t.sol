//SPDX - Identifier : Unlicensed
pragma solidity 0.8.23;

import {Token} from "../contracts/ERC20RewardToken.sol";
import {NFT} from "../contracts/NFTStaking.sol";
import {console, Test} from "forge-std/Test.sol";

contract TestNFTStaking is Test {
    Token public token;
    NFT public NFTToken;
    address public admin;
    address public user1;
    address public user2;

    function setUp() external {
        admin = vm.addr(12344546);
        user1 = vm.addr(3208888822);
        user2 = vm.addr(8899991991919919191);
        vm.startPrank(admin);
        token = new Token();
        NFTToken = new NFT(address(token));
        vm.stopPrank();
    }

    function test_mint() external {
        vm.startPrank(admin);
        NFTToken.mint(1);
        vm.stopPrank();
        assertEq(NFTToken.balanceOf(admin), 1);
    }

    function test_sendTokensAndWithdrawERC20Tokens() external {
        vm.startPrank(admin);
        NFTToken.mint(0);
        NFTToken.mint(1);
        NFTToken.mint(2);
        NFTToken.mint(3);
        NFTToken.mint(4);
        NFTToken.mint(5);
        NFTToken.sendTokens(1);
        assertEq(NFTToken.balanceOf(admin), 5);
        vm.stopPrank();
        vm.startPrank(user1);
        console.log(NFTToken.balanceOf(address(token)), "NFTTokens owned by ERC20 contract - 1");
        vm.warp(block.timestamp + 1 days);
        vm.stopPrank();
        vm.prank(admin);
        token.withdrawERC20Tokens(1);
        assertEq(token.balanceOf(admin), 10e6);
        //tokenId check if not exists
        vm.prank(user2);
        vm.expectRevert();
        token.withdrawERC20Tokens(234);
    }

    function test_withdrawNFTTokens() external {
        vm.startPrank(admin);
        NFTToken.mint(0);
        NFTToken.mint(1);
        NFTToken.mint(2);
        NFTToken.mint(3);
        NFTToken.mint(4);
        NFTToken.mint(5);
        vm.stopPrank();
        /*other than owner can not send token*/
        vm.startPrank(user2);
        vm.expectRevert();
        NFTToken.sendTokens(1);
        vm.stopPrank();
        vm.startPrank(admin);
        NFTToken.sendTokens(1);
        assertEq(NFTToken.balanceOf(admin), 5);
        vm.stopPrank();
        //other than owner could not withdraw NFT tokens
        vm.startPrank(user1);
        vm.expectRevert();
        NFTToken.withdrawNFT(1);
    }
}
