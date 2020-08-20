// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/access/Ownable.sol";

contract Allowance is Ownable {
    using SafeMath for uint;
    
    struct user {
        uint allowance;
        uint balance;
        bool active;
    }
    
    mapping(address => user) record;
    
    event AllowanceChanged(address indexed _user, uint _newAllowance);

    modifier allowWithdraw(uint _amount) {
        require(owner() == msg.sender || record[msg.sender].balance >= _amount, "Operation not allowed");
        _;
    }

    
    function setAllowance(address _user, uint _amount) public onlyOwner {
        user memory u;
        u.allowance = _amount;
        u.balance = _amount;
        u.active = true;
        record[_user] = u;
        emit AllowanceChanged(_user, _amount);
    }
    
    function pauseUser(address _user) public onlyOwner {
        record[_user].active = false;
    }
    
    function getAllowance(address _user) public onlyOwner view returns(uint) {
        return record[_user].allowance;
    }
    
    // Try defining a separate function for owner and check if that is more efficient.
    function getBalance() public view returns(uint) {
        if (msg.sender == owner()) {
            return address(this).balance;
        }
        return record[msg.sender].balance;
    }
}