//SPDX - Identifier : Unlicensed
pragma solidity 0.8.23;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Escrow is Ownable {
    using SafeERC20 for IERC20;

    uint64 private waitTimePeriod;
    uint64 private timeOfDispute;
    address private buyer;
    address private seller;
    address public resolver;
    mapping(address => bool) public approval;
    mapping(address => bool) private isDiputeRaised;
    uint64 private constant disputeResolutionTimelimit = 21600;

    constructor(uint64 waitTimePeriod_, address buyer_, address seller_, address resolver_) Ownable(msg.sender) {
        waitTimePeriod = waitTimePeriod_;
        buyer = buyer_;
        seller = seller_;
        approval[buyer] = true;
        approval[seller] = true;
        resolver = resolver_;
    }

    function updateTimePeriod(uint64 time_) external onlyOwner {
        waitTimePeriod = time_;
    }

    function getwaitTimePeriod() external view returns (uint64 time_) {
        time_ = waitTimePeriod;
    }

    function setDisputeRaised(address token_, bool value_) external {
        require(msg.sender == buyer || msg.sender == seller, "Not a buyer or seller");
        timeOfDispute = uint64(block.timestamp);
        isDiputeRaised[token_] = value_;
    }

    function deposit(address token_, address from, address to, uint256 amount) external {
        zeroCheck(to);
        require(msg.sender == buyer, "Invalid buyer");
        require(IERC20(token_).balanceOf(from) >= amount, "Insufficient balance");
        IERC20(token_).safeTransferFrom(from, to, amount);
    }

    function withdraw(address token_, uint256 amount, address from) external {
        require(msg.sender == seller, "Invalid seller");
        require(waitTimePeriod > 3, "Withdraw period less than 3 days");
        require(amount <= IERC20(token_).balanceOf(from), "Insufficient balance in contract");
        require(!isDiputeRaised[token_], "Dispute raised");
        IERC20(token_).safeTransfer(seller, amount);
    }

    function setVerdict(address token_) external {
        uint256 disputeTimePeriod_ = block.timestamp - timeOfDispute;
        require(msg.sender == resolver, "Invalid resolver");
        require(approval[buyer] && approval[seller], "Approval not given");
        require(disputeTimePeriod_ < disputeResolutionTimelimit, "Time exceeded");
        uint256 disbursedAmount = IERC20(token_).balanceOf(address(this));
        isDiputeRaised[token_] = false;
        IERC20(token_).safeTransfer(buyer, disbursedAmount);
    }

    function withdrawTokens(address token_, uint256 amount_) external onlyOwner {
        uint256 disputeTimePeriod = block.timestamp - timeOfDispute;
        if (disputeTimePeriod > 6) {
            require(amount_ <= IERC20(token_).balanceOf(address(this)), "Insufficient balance to withdraw");
            IERC20(token_).safeTransfer(buyer, amount_);
        }
    }

    function zeroCheck(address token_) internal pure {
        require(token_ != address(0), "Invalid address");
    }
}
