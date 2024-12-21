//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


//Using Inheritance, a child contract can inherit the properties of a parent contract. 
//A contract is inherited into another contract using the “is” keyword


contract  Parent {
    uint public num;

    function increment() public{
        num++;
    }
    
}

contract Child is Parent {
    function decrement() public{
        num--;
    }

    function incrementAndDecrement () public{
        increment();
        decrement();
    }
    
}