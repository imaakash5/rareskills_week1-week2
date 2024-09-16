//SPDX- Identifier : Unlicensed
pragma solidity 0.8.23;

import {console, Test} from "forge-std/Test.sol";
import {BanAddress, Token2, Token3} from "../contracts/BanAddress.sol";

contract Testcontract is Test {
    BanAddress private token;
    Token2 private token2;
    Token3 private token3;
    address public admin;
    address public user1;
    address public user2;

    function setUp() external {
        admin = vm.addr(1234);
        user1 = vm.addr(5833428);
        user2 = vm.addr(70320321423);
        vm.startPrank(admin);
        token = new BanAddress();
        token2 = new Token2();
        token3 = new Token3();
        vm.stopPrank();
    }

    function testSetUp() external view {
        assertEq(token.owner(), admin);
        assertEq(token.balanceOf(admin), 1000e18);
    }

    function test_setWhiteListedToken() external {
        vm.startPrank(admin);
        token.setWhiteListedToken(user2, false);
        assertEq(token.getWhiteListedToken(user2), false);
    }

    function test_safeTransferFrom() external {
        vm.startPrank(admin);
        token.setWhiteListedToken(user2, false);
        token.approve(user2, 20e18);
        token.safeTransferFrom(user2, address(this), 20e18);
        assertEq(token.balanceOf(user2), 0);
        token.setWhiteListedToken(user1, true);
        token.setWhiteListedToken(address(this), true);
        //token.approve(msg.sender,20e18);
        token.safeTransferFrom(msg.sender, user1, 20e18);
    }
}
