// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "forge-std/Test.sol";
import "../src/Bank.sol";

contract BankTest is Test {
    Bank bank;

    function setUp() public {
        bank = new Bank();
    }

    function testDeposit() public {
        bank.deposit{value: 1 ether}(1 ether);
        assertEq(bank.checkBalance(address(this)), 1 ether);
    }
}
