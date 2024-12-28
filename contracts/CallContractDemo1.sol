// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Callee{
 string public Name;

 function setName(string calldata _Name) external {
    Name = _Name;
 }

 function getName() external view returns(string memory){
    return Name;
 }

}

contract caller {

    Callee c;

    constructor(address _addr){
        c = Callee(_addr);
    }

    function callSetName(string calldata _Name) external {
        c.setName(_Name);
    }

    function callGetName() external view returns(string memory){
        return c.getName();
    }
}