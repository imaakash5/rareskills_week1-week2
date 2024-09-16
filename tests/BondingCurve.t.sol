//SPDX -Identifier :Unlicensed
pragma solidity 0.8.23;

import {BondingCurve} from "../contracts/BondingCurve.sol";
import {Test, console} from "forge-std/Test.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TestBondingCurve is Test {
    address public admin;
    address public user1;
    address public user2;
    address public user3;
    address public user4;
    IERC20 public USDC;
    BondingCurve private bondingCurve;

    function setUp() external {
        admin = vm.addr(12345);
        user1 = vm.addr(994739);
        user2 = vm.addr(4019202390);
        user3 = vm.addr(773404830840380483084);
        user4 = vm.addr(84038080222243);
        USDC = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
        vm.prank(admin);
        bondingCurve = new BondingCurve(10000e6, 500000, address(USDC)); //50% - 500000
    }

    function test_setUp() external view {
        assertEq(bondingCurve.connectorWeight(), 500000);
        assertEq(bondingCurve.connectorBalance(), 10000e6);
        console.log(bondingCurve.balanceOf(admin));
    }

    function test_Buy() external {
        vm.prank(admin);
        bondingCurve.transfer(address(bondingCurve), 1000000e6);
        deal(address(USDC), user2, 10000e6);
        deal(address(USDC), user3, 10000e6);
        deal(address(USDC), user4, 10000e6);
        vm.startPrank(user2);
        USDC.approve(address(bondingCurve), 1000e6);
        bondingCurve.buy(1000e6);
        vm.stopPrank();
        vm.startPrank(user3);
        USDC.approve(address(bondingCurve), 2000e6);
        bondingCurve.buy(2000e6);
        vm.stopPrank();
        assertEq(bondingCurve.connectorBalance(), 13000e6);
        assertEq(USDC.balanceOf(user2), 9000e6);
        assertEq(USDC.balanceOf(user3), 8000e6);
    }

    function test_sell() external {
        vm.prank(admin);
        bondingCurve.transfer(address(bondingCurve), 1000000e6);
        deal(address(USDC), user2, 10000e6);
        deal(address(USDC), user3, 10000e6);
        deal(address(USDC), user4, 10000e6);
        vm.startPrank(user2);
        USDC.approve(address(bondingCurve), 4000e6);
        bondingCurve.buy(1000e6);
        bondingCurve.buy(2000e6);
        bondingCurve.approve(address(bondingCurve), 48808848170);
        bondingCurve.sell(48808848170);
        vm.stopPrank();
        assertEq(bondingCurve.connectorBalance(), 11910810053);
        vm.startPrank(user3);
        USDC.approve(address(bondingCurve), 3000e6);
        bondingCurve.buy(3000e6);
        vm.stopPrank();
        vm.startPrank(user2);
        bondingCurve.approve(address(bondingCurve), 48808848170);
        bondingCurve.sell(91366576928);
        vm.stopPrank();
        assertEq(bondingCurve.connectorBalance(), 12762937172);
    }
}
