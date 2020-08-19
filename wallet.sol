// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/math/SafeMath.sol";

contract wallet {
    using SafeMath for uint;
    
    address payable public owner;
    struct user {
        uint allowance;
        uint balance;
    }
    mapping(address => user) allowance;
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    constructor() public {
        owner = msg.sender;
    }
    
    // Try defining a separate function for owner and check if that is more efficient.
    function getBalance() public view returns(uint) {
        if (msg.sender == owner) {
            return address(this).balance;
        }
        return allowance[msg.sender].balance;
    }
    
    function withdrawOwner(uint _amount) public onlyOwner {
        require(_amount < address(this).balance);
        owner.transfer(_amount);
    }
    
    
    
    // Accept whatever funds are sent.
    receive() payable external {}
    
    fallback() external{}
}