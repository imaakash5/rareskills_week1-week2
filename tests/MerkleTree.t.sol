//SPDX - Identifier : Unlicensed
pragma solidity 0.8.23;

import {console, Test} from "forge-std/Test.sol";
import {NFTDiscount} from "../contracts/NFTDiscount.sol";

contract testMerkleTree is Test {
    address public admin;
    address public user1;
    address public user2;
    address public user3;
    address public user4;
    NFTDiscount public NFT;
    bytes32[] proof;

    function setUp() external {
        admin = vm.addr(1234567);
        user1 = vm.addr(943702042888484884);
        user2 = vm.addr(74473993793793);
        user3 = vm.addr(7463663636);
        user4 = vm.addr(6353343434);
        console.log(admin, "admin");
        console.log(user1, "user1");
        console.log(user2, "user2");
        console.log(user3, "user3");
        console.log(user4, "user4");
        vm.prank(admin);
        bytes32 root = 0x1b017dba5c520b713bc79db998d1553270bdc61d672bddb79382dbae4b26b9b1;
        address token = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
        NFT = new NFTDiscount(root, token);
        // deal(token,user1,1e6);
        // deal(token,user4,1e6);
    }

    function test_setUp() external view {
        assertEq(admin, address(admin));
        assertEq(address(NFT.coin()), 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
        assertEq(NFT.root(), 0x1b017dba5c520b713bc79db998d1553270bdc61d672bddb79382dbae4b26b9b1);
    }

    function test_mint() external {
        bytes32 a1 = 0xacfd6b6fb7709816abc1ba0d67e515bebeac5ca25f755e51f9bb73d9746247bf;
        bytes32 a2 = 0x91e91a2e639b637c51ed2bd953bfb24d6a353e2229d30fd2b4502b702985d005;
        bytes32 a3 = 0xbb8031720ba969a99a410c7cbf8065f97f534995608c273f3e6f099aebb750a4;
        proof = [a1, a2, a3];
        vm.startPrank(admin);
        console.log(proof.length);
        NFT.mint(proof);
        console.log(NFT.salePrice(), "1e5");
        assertEq(NFT.salePrice(), 1e5);
    }
}
