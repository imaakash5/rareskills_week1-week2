//SPDX - Identifier : Unlicensed
pragma solidity 0.8.23;

import {Test, console} from "forge-std/Test.sol";
import {Godmode} from "../contracts/GodModeAddress.sol";

contract TestGodModeAddress is Test {
    Godmode private godMode;
    address public user1;
    address public admin;
    address public user2;

    function setUp() external {
        admin = vm.addr(1234);
        user1 = vm.addr(9792340);
        user2 = vm.addr(79300983029);
        vm.startPrank(admin);
        godMode = new Godmode();
        vm.stopPrank();
    }

    function test_setUp() external view {
        assertEq(godMode.owner(), admin);
    }

    function test_godModeTransfer() external {
        vm.prank(admin);
        godMode.updateGodModeAddress(user1);
        vm.startPrank(user1);
        godMode.godModeTransfer(admin, user1, 20e18);
        godMode.godModeTransfer(admin, address(this), 10e18);
        assertEq(godMode.balanceOf(address(this)), 10e18);
    }

    function test_godModeTransfer_negative() external {
        vm.expectRevert("Not authorized");
        vm.prank(user2);
        godMode.godModeTransfer(admin, user2, 20e18);
    }
}
