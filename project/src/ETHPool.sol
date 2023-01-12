// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Address} from "openzeppelin-contracts/utils/Address.sol";
import {EnumerableSet} from "openzeppelin-contracts/utils/structs/EnumerableSet.sol";
import {Ownable} from "openzeppelin-contracts/access/Ownable.sol";

/**
 * @notice ETHPool is a contract that allows users to deposit ETH and earn
 *         interest on a weekly basis. New rewards are deposited manually into
 *         the pool by the ETHPool team each week.
 */
contract ETHPool is Ownable {
    using Address for address payable;
    using EnumerableSet for EnumerableSet.AddressSet;

    struct Withdrawals {
        uint256 amount;
        uint256 lastWithdrawlTime;
        // (2^16) / 52 = 1,260 years
        uint16 weeklyDepositIndex;
    }

    /*//////////////////////////////////////////////////////////////
                            ETHPool TEAM
    //////////////////////////////////////////////////////////////*/
    EnumerableSet.AddressSet private _teamMembers;
    uint256[] public weeklyRewardsDeposits;
    uint256 public totalRewardsDeposited;

    /*//////////////////////////////////////////////////////////////
                            TRACK USER'S DATA
    //////////////////////////////////////////////////////////////*/
    mapping(address => uint256) public usersDeposits;
    mapping(address => Withdrawals) public usersWithdrawals;

    /*//////////////////////////////////////////////////////////////
                            EVENTS
    //////////////////////////////////////////////////////////////*/
    event TeamMemberAdded(address indexed teamMember);
    event TeamMemberRemoved(address indexed teamMember);

    event Deposit(address indexed user, uint256 indexed amount);
    event Withdrawl(
        address indexed user,
        uint256 indexed amount,
        uint256 indexed weeklyDepositIndex
    );

    modifier onlyOwnerOrTeam() {
        require(
            msg.sender == owner() || isTeamMember(msg.sender),
            "Pool_OWNER_TEAM_ONLY"
        );
        _;
    }

    /**
     * @notice Manage team members.
     * @dev Only the owner or a team member can update team members.
     *      As we use an EnumerableSet, we don't need to check if the
     *      `teamMember` is already in the set.
     */
    function addTeamMember(address teamMember) external onlyOwnerOrTeam {
        require(_teamMembers.add(teamMember), "MEMBER_EXISTS");
        emit TeamMemberAdded(teamMember);
    }

    /**
     * @notice Manage team members.
     * @dev Only the owner or other team member can update team members.
     *      As we use an EnumerableSet, we don't need to check if the
     *      `teamMember` has already been removed from the set.
     */
    function removeTeamMember(address teamMember) external onlyOwnerOrTeam {
        require(_teamMembers.remove(teamMember), "MEMBER_NOT_FOUND");
        emit TeamMemberRemoved(teamMember);
    }

    function teamMembersLength() external view returns (uint256) {
        return _teamMembers.length();
    }

    function isTeamMember(address teamMember) public view returns (bool) {
        return _teamMembers.contains(teamMember);
    }

    /**
     * @notice Deposit ETH into the pool.
     * @dev Only ETHPool team can deposit rewards.
     */

    /**
     * @dev Withdraw all rewards.
     * @dev Withdraw only the last 52 weeks, to avoid over gas consumption.
     *         We make the asumption that the user will withdraw funds at the
     *         very least once per year.
     */
    // re-entreency guard / check effects interaction pattern

    /**
     * @notice Withdraw all deposits and rewards simultaneously.
     */
    // re-entreency guard / check effects interaction pattern
}
