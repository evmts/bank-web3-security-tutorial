// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {IERC20} from "forge-std/interfaces/IERC20.sol";

contract BankV3 {
    mapping(address account => uint256 balance) private accountsBalances;

    address public immutable USDT;

    constructor(address usdt) {
        USDT = usdt;
    }

    /// @notice Adding sender balance by the amount of USD
    /// @param amount The amount to deposit to the caller
    function depositUSD(uint256 amount) external payable {
        require(amount > 0, "No USD sent");
        bool success = IERC20(USDT).transferFrom(msg.sender, address(this), amount);
        require(success, "Transfering Failed");

        accountsBalances[msg.sender] += amount;
    }

    /// @notice withdraw the amount of USD send the caller and send them to receipent
    /// @param amount the amount of USD to withdraw
    /// @param receipent The receiver that we will take the withdrawn USD
    function withdrawUSD(uint256 amount, address receipent) external {
        uint256 withdrawalAmount = accountsBalances[msg.sender];
        require(withdrawalAmount >= amount, "Amount to withdraw exceeds balance");

        accountsBalances[msg.sender] -= amount;
        bool success = IERC20(USDT).transfer(receipent, amount);
        require(success, "Transfering Failed");
    }

    /// @notice withdraw USD with calling a Fallcak function
    /// @param amount the amount of USD to withdraw
    /// @param receipent The receiver that we will take the withdrawn USD
    /// @param data The Fallback function signature we will call on receipent
    function withdrawFallbackUSD(uint256 amount, address receipent, bytes memory data) external {
        uint256 withdrawalAmount = accountsBalances[msg.sender];
        require(withdrawalAmount >= amount, "Amount to withdraw exceeds balance");

        accountsBalances[msg.sender] -= amount;
        bool success = IERC20(USDT).transfer(receipent, amount);
        require(success, "Transfering Failed");

        (bool fallbackSuccess,) = receipent.call(data);
        require(fallbackSuccess, "Fallback Function reverted");
    }
}
