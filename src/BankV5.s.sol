// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {IERC20} from "forge-std/interfaces/IERC20.sol";

contract BankV5 {
    mapping(address account => uint256 balance) private accountsBalances;

    address public immutable WETH;

    constructor(address weth) {
        WETH = weth;
    }

    /// @notice Adding sender balance by the amount of WETH sent
    /// @param amount the amount of deposited WETH
    function depositWETH(uint256 amount) external payable {
        require(amount > 0, "No amount sent");
        bool success = IERC20(WETH).transferFrom(msg.sender, address(this), amount);
        require(success, "Transfering Failed");

        accountsBalances[msg.sender] += amount;
    }

    /// @notice withdraw the amount of WETH send the caller and send them to receipent
    /// @param amount the amount of WETH to withdraw
    /// @param receipent The receiver that we will take the withdrawn WETH
    function withdrawWETH(uint256 amount, address receipent) external {
        uint256 withdrawalAmount = accountsBalances[msg.sender];
        require(withdrawalAmount >= amount, "Amount to withdraw exceeds balance");

        accountsBalances[msg.sender] -= amount;
        bool success = IERC20(WETH).transferFrom(address(this), receipent, amount);
        require(success, "Transfering Failed");
    }
}
