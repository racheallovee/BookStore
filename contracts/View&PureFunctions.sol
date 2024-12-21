//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract viewPure{

    uint x;

    function changeVariable() public {
        x= 100;
    }

    function getVariable() public view returns(uint) {//reading from the blockchain 
         return x;
    }

    function addNum() public pure returns(uint){// doesn't read or write anything on the blockchain, doesnt take state of the contract 
        return(1+2);
    }

}