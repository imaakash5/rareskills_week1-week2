//SPDX - Identifier : Unlicensed
pragma solidity 0.8.23;

import {Token} from "../contracts/ERC20RewardToken.sol";
import {NFT} from "../contracts/NFTStaking.sol";
import {console,Test} from "forge-std/Test.sol";

contract TestNFTStaking is Test{
    
    Token public token;
    NFT public NFTToken;
    address public admin;
    address public user1;
    address public user2;
    
    function setUp()  external{
        admin = vm.addr(12344546);
        user1 = vm.addr(3208888822);
        user2 = vm.addr(8899991991919919191);
        vm.startPrank(admin);
        token = new Token();
        NFTToken = new NFT(address(token));
        vm.stopPrank();
    }

    function test_setUp() external{
        vm.prank(admin);
        token.mint(); //3000USDC
        assertEq(token.balanceOf(admin),3000e6);
    }

    function test_mint() external{
        vm.startPrank(admin);
        NFTToken.mint(1);
    }

    function test_sendTokens() external{
        vm.startPrank(admin);
        NFTToken.mint(0);
        NFTToken.mint(1);
        NFTToken.mint(2);
        NFTToken.mint(3);
        NFTToken.mint(4);
        NFTToken.mint(5);
        
        NFTToken.sendTokens(1,admin, address(token));

        assertEq(NFTToken.balanceOf(admin),5);   

    }

}