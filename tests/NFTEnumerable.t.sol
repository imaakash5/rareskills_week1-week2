//SPDX - Identifier : Unlicensed
pragma solidity 0.8.23;

import {NFTEnumerable} from "../contracts/NFTEnumerable.sol";
import {console,Test} from "forge-std/Test.sol";

contract TestNFT is Test{
    address public admin;
    NFTEnumerable public NFTTokens;

    function setUp() external{
        admin = vm.addr(134556);
        vm.expectRevert();
        NFTTokens = new NFTEnumerable();
        vm.prank(admin);
        NFTTokens = new NFTEnumerable();
    }

    function test_setUp() view external{
        uint256 totalSupply = NFTTokens.totalSupply();
        assertEq(totalSupply, 20);
    }
}