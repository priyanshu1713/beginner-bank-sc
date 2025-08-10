// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract Bank {
    //events
    event depositSuccessfull(address indexed account, uint256 amount);
    event withdrawSuccessfull(address indexed account, uint256 amount);

    //errors
    error depositMismatch();
    error amountCannotBeZero();
    error insufficientFunds();
    error withdrawFailed();
    error accountNotFound();

    // variables
    mapping(address => uint256) private accountBalances;

    function deposit(uint256 amount) public payable {
        if (amount <= 0) {
            revert amountCannotBeZero();
        }
        if (msg.value != amount) {
            revert depositMismatch();
        }
        accountBalances[msg.sender] += amount;
        emit depositSuccessfull(msg.sender, amount);
    }

    function withdraw(uint256 amount) public {
        if (accountBalances[msg.sender] < amount) {
            revert insufficientFunds();
        }

        accountBalances[msg.sender] -= amount;
        if (accountBalances[msg.sender] == 0) {
            delete accountBalances[msg.sender];
        }
        (bool success,) = msg.sender.call{value: amount}("");
        if (!success) {
            revert withdrawFailed();
        }

        emit withdrawSuccessfull(msg.sender, amount);
    }

    function checkBalance(address user) public view returns (uint256) {
        if (accountBalances[user] == 0) {
            revert insufficientFunds();
        }
        return accountBalances[user];
    }
}
