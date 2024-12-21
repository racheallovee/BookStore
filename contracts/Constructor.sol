//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


// A constructor is a special function that is executed during the deployment of the smart contract.
// used to initialise state variables of a contract
//Initialise only those variables that need to have a certain value after deployment.


contract ConstructorExample{
    uint public price;
    address public owner;

    constructor(uint _price){
        price = _price;
        owner = msg.sender;
    }

    function changePrice (uint _price ) public {
        require(msg.sender == owner);
        price = _price;
    }

    function getPrice() public view returns(uint){
        return  price;
    }
}