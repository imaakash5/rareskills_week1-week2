//SPDX - Identified : Unlicensed
pragma solidity 0.8.23;

import {NFT} from "../contracts/NFT.sol";
import {console, Test} from "forge-std/Test.sol";

contract testNFT is Test {
    NFT private token;
    address private admin;

    function setUp() external {
        admin = vm.addr(12345);
        vm.prank(admin);
        //deployer
        token = new NFT();
    }

    function testMint() external {
        //owner minting the tokens
        vm.prank(admin);
        token.mint();
        vm.expectRevert();
        token.mint();
        assertEq(token.totalSupply(), 20);
    }
}
