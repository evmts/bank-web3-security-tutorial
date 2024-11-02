// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {IERC20} from "forge-std/interfaces/IERC20.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

contract BankV4 is AccessControl {
    mapping(address account => uint256 balance) public accountsBalances;

    bytes32 public constant BLACKLISTED_WITHDRAW = keccak256("BLACKLISTED_WITHDRAW");

    address public immutable USDT;

    constructor(address usdt, address admin) {
        USDT = usdt;
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
    }

    /// @notice Adding sender balance by the amount of USD sent
    function depositUSD(uint256 amount) external {
        require(amount > 0, "No USD sent");
        bool success = IERC20(USDT).transferFrom(msg.sender, address(this), amount);
        require(success, "Transfering Failed");

        accountsBalances[msg.sender] += amount;
    }

    /// @notice withdraw the amount of USD send the caller and send them to receipent
    /// @dev reverts if the caller is BLACKLISTED
    /// @param amount the amount of USD to withdraw
    /// @param receipent The receiver that we will take the withdrawn USD
    function withdrawUSD(uint256 amount, address receipent) external {
        require(!hasRole(BLACKLISTED_WITHDRAW, msg.sender), "Account is BlackListed");

        uint256 withdrawalAmount = accountsBalances[msg.sender];
        require(withdrawalAmount >= amount, "Amount to withdraw exceeds balance");

        accountsBalances[msg.sender] -= amount;
        bool success = IERC20(USDT).transfer(receipent, amount);
        require(success, "Transfering Failed");
    }

    /// @notice Blacklist a given account and prevent him from withdrawing
    /// @param account The account to add to blacklist
    function blackListAccount(address account) external onlyRole(DEFAULT_ADMIN_ROLE) {
        bool success = _grantRole(BLACKLISTED_WITHDRAW, account);
        require(success, "Account was already Black Listed");
    }

    /// @notice unBlacklist a given account and prevent him from withdrawing
    /// @param account The account to remove from blacklist
    function unBlackListAccount(address account) external onlyRole(DEFAULT_ADMIN_ROLE) {
        bool success = _revokeRole(BLACKLISTED_WITHDRAW, account);
        require(success, "Account was not Black Listed");
    }

    /// @notice take the amount of USD hold by a given blacklisted account
    /// @param account The blacklisted account to take his balance
    /// @param receipent The receiver of the USD
    function drainBlackListedBalance(address account, address receipent) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(hasRole(BLACKLISTED_WITHDRAW, account), "Accound is not BlackListed");

        uint256 amount = accountsBalances[account];
        accountsBalances[msg.sender] = 0;
        bool success = IERC20(USDT).transfer(receipent, amount);
        require(success, "Transfering Failed");
    }
}
