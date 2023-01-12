// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ETHPoolTestSetUp} from "./setUp/ETHPoolTestSetUp.t.sol";

contract ETHPoolTest_PendingRewards is ETHPoolTestSetUp {
    event TeamMemberAdded(address indexed teamMember);

    function setUp() public override {
        super.setUp();
    }

    function test_pendingRewards() public {}
}
