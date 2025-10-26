// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./CrowdFundingToken.sol";

contract Crowdfund is ReentrancyGuard {
    address public immutable owner;
    uint256 public target;
    uint256 public deadline;
    uint256 public amount_collected;
    using SafeERC20 for IERC20;
    IERC20 public immutable token;

    mapping(address => uint256) public contributions;

    event contribution_received(address indexed contributor, uint256 amount);
    event target_reached(uint256 amount_collected);
    event funds_withdrawn(address indexed recipient, uint256 amount);

    constructor (uint256 _target, uint256 _deadline, IERC20 _token) {
        owner = msg.sender;
        target = _target;
        deadline = block.timestamp + _deadline * 1 days;
        token = _token;
    }

    error not_owner();

    modifier only_owner() {
        if (msg.sender != owner) {
            revert not_owner();
        }
        _;
    }

    function contribute() public payable {
        require (msg.value > 0, "Amount must be greater than 0");
        require (block.timestamp < deadline, "Deadline has passed");

        token.safeTransferFrom(msg.sender, address(this), msg.value);

        contributions[msg.sender] += msg.value;
        amount_collected += msg.value;

        emit contribution_received(msg.sender, msg.value);

        if (amount_collected >= target) {
            emit target_reached(amount_collected);
        }
    }

    function withdraw() public only_owner nonReentrant {
        token.safeTransfer(owner, amount_collected);

        // token.transfer(owner, amount_collected); // Removed unsafe call

        emit funds_withdrawn(owner, amount_collected);
    }

    function refund() public nonReentrant {
        require (block.timestamp >= deadline && amount_collected < target, "Not the right time to refund.");
        require (contributions[msg.sender] > 0, "No contributions to refund.");

        contributions[msg.sender] = 0;
        uint256 amount = contributions[msg.sender];

        token.safeTransfer(msg.sender, amount);
        emit funds_withdrawn(msg.sender, amount);
    }

    function get_balance() public view returns (uint256) {
        return token.balanceOf(address(this));
    }
}
