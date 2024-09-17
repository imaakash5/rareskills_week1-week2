//SPDX - Identifier : Unlicensed
pragma solidity 0.8.23;

import {console,Test} from "forge-std/Test.sol";

contract testMerkleTree is Test{
    address public admin;
    address public user1;
    address public user2;
    address public user3;
    address public user4;

    function setUp() external{
        admin = vm.addr(1234567);
        user1 = vm.addr(943702042888484884);
        user2 = vm.addr(74473993793793);
        user3 = vm.addr(7463663636);
        user4 = vm.addr(6353343434);
        console.log(admin);
        console.log(user1);
        console.log(user2);
        console.log(user3);
        console.log(user4);
    }
    function test_setUp() external{
        assertEq(admin,address(admin));
        // console.log(admin);
        // console.log(user1);
        // console.log(user2);
        // console.log(user3);
        // console.log(user4);
    }


}