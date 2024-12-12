//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Bytes{
    bytes1 a = 0*12;
    bytes2 b = 0*1234;

    function compare() public view returns(bool){
        return a == b;
    }

    function bitOperations() public view returns(bytes2){
        return a & b;
    }

    function leftShit() public view returns(bytes1){
        return a << 1;
        
    }

    function returnAtIndex(uint _index) public view returns(bytes1){
        return a[_index];
    }

}
