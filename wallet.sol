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

contract wallet is Allowance {

    function withdrawMoney(address payable _to, uint _amount) public allowWithdraw(_amount) {
        require(_amount <= address(this).balance);
        record[msg.sender].balance = record[msg.sender].balance.sub(_amount);
        _to.transfer(_amount);
        
    }
    

    // Accept whatever funds are sent.
    receive() payable external {}
    
    fallback() external{}

    
    // This is only for test purpose. Remove it before deploymemt.
    function receiveFunds() public payable {
        
    }
}