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

    struct Deposit {
        uint256 newAmount;
        uint256 lastestTimestamp;
        uint256 prevWeekTotal;
        PreviousWeeksDeposit[] PreviousWeeksDeposits;
    }

    struct PreviousWeeksDeposit {
        uint256 added;
        uint256 timestamp;
        uint256 olderTotal;
    }

    struct RewardsDeposit {
        uint256 newAmount;
        uint256 latestTimestamp;
        uint256 prevWeekTotal;
    }

    struct Withdrawal {
        uint256 amount;
        uint256 lastWithdrawlTime;
        // (2^16) / 52 = 1,260 years
        uint16 weeklyDepositIndex;
    }

    /*//////////////////////////////////////////////////////////////
                            ETHPool TEAM
    //////////////////////////////////////////////////////////////*/
    EnumerableSet.AddressSet private _teamMembers;
    RewardsDeposit[] public weeklyRewardsDeposits;
    uint256 public totalRewardsDeposited;
    uint256 public totalAvailableRewards;
    uint16 public currentWeek;

    /*//////////////////////////////////////////////////////////////
                            TRACK USER'S DATA
    //////////////////////////////////////////////////////////////*/
    mapping(address => Deposit) public usersDeposits;
    mapping(address => Withdrawal) public usersWithdrawals;
    int256 public totalUsersDeposits;

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

    modifier canUpdateTeam() {
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
    function addTeamMember(address teamMember) external canUpdateTeam {
        require(_teamMembers.add(teamMember), "MEMBER_EXISTS");
        emit TeamMemberAdded(teamMember);
    }

    /**
     * @notice Manage team members.
     * @dev Only the owner or other team member can update team members.
     *      As we use an EnumerableSet, we don't need to check if the
     *      `teamMember` has already been removed from the set.
     */
    function removeTeamMember(address teamMember) external canUpdateTeam {
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
     * @notice Deposit ETH for rewards into the pool.
     * @dev Only ETHPool team can deposit rewards.
     */

    /**
     * @notice Users deposit ETH into the pool to earn rewards.
     * @dev For calculations simplicity, we authorize users to deposit only
     *      once a week.
     */

    /**
     * @notice Compute the pending rewards for a user taking into account:
     *         - if they deposited before the last team weekly deposit
                 timestamp 
               - how much shares they have in the pool based on what they
                 deposited
     */
    function pendingRewards() public view returns (uint256) {
        uint256 userLastestAmount = usersDeposits[msg.sender].newAmount;
        uint256 userLastestTime = usersDeposits[msg.sender].lastTimestamp;
        uint256 userPrevWeekTotal = usersDeposits[msg.sender].prevWeekTotal;

        uint256 lastestRewards = weeklyRewardsDeposits[currentWeek].newAmount;
        uint256 latestTimeRewards = weeklyRewardsDeposits[currentWeek]
            .lastTimestamp;
        uint256 prevWeekTotalRewards = weeklyRewardsDeposits[currentWeek]
            .prevWeekTotal;

        // partial rewards = only previous weeks
        uint256 partialRewards = (userPrevWeekTotal *
            (totalAvailableRewards - lastestRewards)) / totalUsersDeposits;

        // full rewards = all previous weeks + current week
        uint256 totalUserDeposits = userPrevWeekTotal + userLastestAmount;
        uint256 fullRewards = (totalUserDeposits * totalAvailableRewards) /
            totalUsersDeposits;

        /**
         * @dev if user deposited before the last team weekly deposit
         *      timestamp, they get full rewards, otherwise they get partial
         *      rewards
         */
        return
            userLastestTime <= latestTimeRewards
                ? fullRewards
                : partialRewards;
    }

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
