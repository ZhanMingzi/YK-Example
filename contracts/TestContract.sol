// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract testContract {

    uint8 public age = 15;

    function getAge() external view returns (uint){
        return age;
    }
}