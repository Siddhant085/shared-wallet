// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/math/SafeMath.sol";

contract wallet {
    using SafeMath for uint;
    
    address payable public owner;
    struct user {
        uint allowance;
        uint balance;
        bool active;
    }
    mapping(address => user) record;
    
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
        return record[msg.sender].balance;
    }
    
    function withdrawOwner(uint _amount) public onlyOwner {
        require(_amount < address(this).balance);
        owner.transfer(_amount);
    }
    
    function withdrawUser(uint _amount) public {
        _amount = _amount * 1 ether;
        require(_amount < record[msg.sender].balance);
        record[msg.sender].balance = record[msg.sender].balance.sub(_amount);
        msg.sender.transfer(_amount);
        
    }
    
    function setAllowance(address _user, uint _amount) public onlyOwner {
        user memory u;
        u.allowance = _amount * 1 ether;
        u.balance = _amount * 1 ether;
        u.active = true;
        record[_user] = u;
    }
    
    function pauseUser(address _user) public onlyOwner {
        record[_user].active = false;
    }
    
    function getAllowance(address _user) public onlyOwner view returns(uint) {
        return record[_user].allowance;
    }
    
    
    // Accept whatever funds are sent.
    receive() payable external {}
    
    fallback() external{}

    
    // This is only for test purpose. Remove it before deploymemt.
    function receiveFunds() public payable {
        
    }
}