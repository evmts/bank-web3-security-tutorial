// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract BankV2 {
    mapping(address account => uint256 balance) private accountsBalances;

    /// @notice Adding sender balance by the amount of ether sent
    function depositEther() external payable {
        require(msg.value > 0, "No Ether sent");
        accountsBalances[msg.sender] += msg.value;
    }

    /// @notice withdraw All ether hold by the caller and send them to him
    /// @dev reverts if there is no ether hold by the caller
    function withdrawEther() external {
        uint256 withdrawalAmount = accountsBalances[msg.sender];
        require(withdrawalAmount > 0, "No ether to withdraw");

        (bool success,) = msg.sender.call{value: withdrawalAmount}("");
        require(success, "Withdrawal Failed");

        accountsBalances[msg.sender] = 0;
    }
}
