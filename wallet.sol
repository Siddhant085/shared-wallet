// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "./Allowance.sol";

contract wallet is Allowance {

    function withdrawMoney(address payable _to, uint _amount) public allowWithdraw(_amount) {
        require(_amount <= address(this).balance);
        record[msg.sender].balance = record[msg.sender].balance.sub(_amount);
        _to.transfer(_amount);
        
    }
    
    function renounceOwnership() override public onlyOwner {
        revert("Operation not allowed");
    }
    

    // Accept whatever funds are sent.
    receive() payable external {}
    
    fallback() external{}

    
    // This is only for test purpose. Remove it before deploymemt.
    function receiveFunds() public payable {
        
    }
}