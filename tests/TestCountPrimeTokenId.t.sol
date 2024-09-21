//SPDX - License - Identifier : Unlicensed
pragma solidity 0.8.23;

import {NFTEnumerableCount} from "../contracts/CountPrimeTokenId.sol";
import {Test, console} from "forge-std/Test.sol";
import {NFT} from "../contracts/NFT.sol";

contract TestPrime is Test {
    address public admin;
    address public user1;
    NFTEnumerableCount public NFTCount;
    NFT public NFTtoken;

    function setUp() external {
        admin = vm.addr(123456);
        vm.startPrank(admin);
        NFTCount = new NFTEnumerableCount();
        vm.stopPrank();
    }

    function test_countPrimeNFTAtAddress() external {
        (uint64 count) = NFTCount.countPrimeNFTAtAddress(admin);
        console.log(count, "tokenIds which are prime");
    }
}
