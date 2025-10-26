// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "../src/Crowdfunding.sol";
import "../src/CrowdFundingToken.sol";

contract Deploy {
    function run() external {
        address token = address(new CrowdFundingToken());
        uint256 goal = 500000 * 10 ** 18;
        uint256 duration = 30 days;
        new Crowdfund(goal, duration, IERC20(token));
    }
}
