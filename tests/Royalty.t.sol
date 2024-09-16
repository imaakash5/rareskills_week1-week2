//SPDX-Identifier : Unlicensed
pragma solidity 0.8.23;
import {NFTRoyalty} from "../contracts/Royalty.sol";
import {Test,console} from "forge-std/Test.sol";


contract testRoyalty is Test{
    address public admin;
    address public user1;
    NFTRoyalty public NFTtokens;

    function setUp() external{
        admin = vm.addr(123456);
        user1 = vm.addr(2439942);
        vm.startPrank(admin);
        NFTtokens = new NFTRoyalty();
    }

    function testsetUp() view external{
        string memory name_=NFTtokens.name();
        assertEq(name_,"NFT with Royalties");
    }
}