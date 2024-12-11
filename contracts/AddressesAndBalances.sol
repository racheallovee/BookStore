// SPDX-License-Identifier: MIT
 pragma solidity ^0.8.7;

contract  myAddresses{
     address account = 0x5B4CBA0BdafFB8C8A24cEef4e86aF88bC5942255;

// function checkEqual(address _adr1, address _adr2) public pure returns(bool){
//     return (_adr1== _adr2);
// }
// }
function getBalance(address _account) public view returns(uint){
             return _account.balance;
      }

}

