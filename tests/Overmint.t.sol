//SPDX - License - Identifier : Unlicensed
pragma solidity 0.8.23;
import {Test,console} from "forge-std/Test.sol";
import {Overmint} from "../contracts/OvermintRiddle.sol";

contract TestOvermint is Test{
    Overmint public overmint;
    address public admin;

    function setUp() external{
        admin = vm.addr(12345);
        overmint = new Overmint();
    }

    function test_mint() external{
            deal(admin, 1 ether);
            vm.startPrank(admin);
            overmint.mint{value : 1e6}();
    }

    receive() external payable{
            overmint.mint{value : 1e6}();
            overmint.mint{value : 1e6}();
            overmint.mint{value : 1e6}();
             overmint.mint{value : 1e6}();
             }

}