//SPDX - Identifier : Unlicensed
pragma solidity 0.8.23;

import {Test, console} from "forge-std/Test.sol";
import {Escrow} from "../contracts/Escrow.sol";
import {ArbitToken} from "../contracts/Token.sol";

contract TestEscrow is Test {
    ArbitToken private token;
    Escrow private escrow;
    address public admin;
    address public user1;
    address public user2;
    address public user3;

    function setUp() external {
        admin = vm.addr(1234);
        user1 = vm.addr(803280);
        user2 = vm.addr(899898);
        user3 = vm.addr(908777373);
        vm.prank(admin);
        token = new ArbitToken();
    }

    // function test_setUp() external view {
    //     assertEq(token.balanceOf(admin),2000e18);
    // }

    // function test_negative_updateTimePeriod() external {
    //     escrow = new Escrow(3,user1,user2,admin);
    //     vm.prank(user1);
    //     vm.expectRevert();
    //     escrow.updateTimePeriod(3);
    // }

    // function test_deposit()external{
    //     escrow = new Escrow(3,user1,user2,admin);
    //     vm.prank(admin);
    //     token.transfer(user1, 100e18);
    //     assertEq(token.balanceOf(user1),100e18);
    //     vm.startPrank(user1);
    //     token.approve(address(escrow),50e18);
    //     escrow.deposit(address(token),user1,address(escrow),50e18);
    //     vm.stopPrank();
    //     assertEq(token.balanceOf(address(escrow)),50e18);
    // }

    //    function test_withdraw()external{
    //     vm.startPrank(admin);
    //     escrow = new Escrow(4,user1,user2,admin);
    //     token.transfer(user1, 100e18);
    //     vm.stopPrank();
    //     vm.startPrank(user1);
    //     token.approve(address(escrow),50e18);
    //     escrow.deposit(address(token),user1,address(escrow),50e18);
    //     vm.stopPrank();
    //     vm.prank(user2);
    //     escrow.withdraw(address(token),40e18,address(escrow));
    //     assertEq(token.balanceOf(user2),40e18);
    //  }

    function test_setVerdict() external {
        vm.startPrank(admin);
        escrow = new Escrow(4, user1, user2, admin);
        token.transfer(user1, 100e18);
        vm.stopPrank();
        vm.startPrank(user1);
        token.approve(address(escrow), 50e18);
        escrow.deposit(address(token), user1, address(escrow), 50e18);
        vm.stopPrank();
        vm.startPrank(user2);
        escrow.setDisputeRaised(address(token), true);
        // vm.expectRevert();
        // escrow.withdraw(address(token),40e18,address(escrow));
        vm.stopPrank();
        vm.prank(admin);
        escrow.setVerdict(address(token));
    }
}
