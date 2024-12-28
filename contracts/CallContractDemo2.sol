// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface IC {

    function setName(string calldata _Name) external;
    function getName() external view returns(string memory);
    
}

contract Callee is IC{
 string public Name;

 function setName(string calldata _Name) external override  {
    Name = _Name;
 }

 function getName() external override view returns(string memory) {
    return Name;
 }
}

contract caller {

    IC c;

    constructor(address _addr){
        c = IC(_addr);
    }

    function callSetName(string calldata _Name) external {
        c.setName(_Name);
    }

    function callGetName() external view returns(string memory){
        return c.getName();
    }
}