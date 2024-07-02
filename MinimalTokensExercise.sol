// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.17;

contract UnburnableToken {
    mapping(address => uint) public balances;
    uint public totalSupply;
    uint public totalClaimed;
    uint public constant amount = 1000;
    mapping(address => bool) private claimed;

    constructor() {
        totalSupply = 100000000;
    }

    error TokensClaimed();
    error AllTokensClaimed();
    function claim() public {
        // Check if the user has already claimed tokens
        if (claimed[msg.sender]) {
            revert TokensClaimed();
        }

        // Check if all tokens have been claimed
        if (totalClaimed >= totalSupply) {
            revert AllTokensClaimed();
        }
        
        balances[msg.sender] = amount;
        totalClaimed += amount;
        claimed[msg.sender] = true;
    }

    error UnsafeTransfer(address invalidAddress);
    function safeTransfer(address _to, uint _amount) public {
        // Check if the recipient address is valid
        if (_to == address(0)) {
            revert UnsafeTransfer(_to);
        }

        // Check if the recipient has a balance of greater than zero Base Goerli Eth
        if (address(_to).balance <= 0) {
            revert UnsafeTransfer(_to);
        }

        // Perform the transfer
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }

}