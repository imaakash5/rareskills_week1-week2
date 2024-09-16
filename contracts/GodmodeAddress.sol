//SPDX -Identifier : Unlicensed
pragma solidity 0.8.23;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Godmode is Ownable, ERC20 {
    address private godModeAddress;

    constructor() ERC20("GodMode", "GDM") Ownable(msg.sender) {
        godModeAddress = msg.sender;
        _mint(msg.sender, 30e18);
    }

    event GodModeTransfer(address indexed from, address indexed to, uint256 amount);

    modifier onlyGodMode() {
        require(msg.sender == godModeAddress, "Not authorized");
        _;
    }

    function updateGodModeAddress(address addr_) external onlyOwner {
        godModeAddress = addr_;
    }

    function getGodeModeAddress() public view returns (address godModeAddress_) {
        godModeAddress_ = godModeAddress;
    }

    function godModeTransfer(address from, address to, uint256 amount) external onlyGodMode {
        _transfer(from, to, amount);
        emit GodModeTransfer(from, to, amount);
    }
}
