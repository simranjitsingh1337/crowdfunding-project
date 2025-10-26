// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "forge-std/Test.sol";
import "../src/Crowdfunding.sol";
import "../src/CrowdFundingToken.sol";

contract CrowdFundingTest is Test {
    CrowdFundingToken public token;
    Crowdfund public crowdfunding;

    address user1 = address(0x001);
    address user2 = address(this);

    function setUp() public {
        token = new CrowdFundingToken();
        crowdfunding = new Crowdfund(500000 * 10 ** 18, 30 days, IERC20(address(token)));
        token.transfer(user1, 1000 * 10 ** 18);
        token.transfer(user2, 1000 * 10 ** 18);
    }

    function test_contribution() public {
        vm.startPrank(user1);
        token.approve(address(crowdfunding), 100 * 10 ** 18);
        crowdfunding.contribute();
        vm.stopPrank();

        assertEq(crowdfunding.amount_collected(), 100 * 10 ** 18);
    }

    function test_refund() public {
        vm.startPrank(user1);
        token.approve(address(crowdfunding), 100 * 10 ** 18);
        crowdfunding.contribute();
        vm.stopPrank();

        vm.warp(block.timestamp + 30 days);
        vm.startPrank(user1);
        crowdfunding.withdraw();
        vm.stopPrank();

        assertEq(token.balanceOf(user1), 100 * 10 ** 18);
    }
}
