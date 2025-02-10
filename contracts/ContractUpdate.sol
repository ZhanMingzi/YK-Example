// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

//定义数据合约

contract storageStructureContract{
    address public implementation; //实现合约的地址，逻辑合约地址
    mapping(address => uint) public point;
    uint public totalPlayers;
    address public owner;
}

//定义逻辑合约
contract implementationContract is storageStructureContract{

    modifier onlyOwner() {
        require(msg.sender == owner,"not owner");
        _;
    }

    function addPlayer(address player,uint points) public virtual  onlyOwner {
        require(point[player] == 0,'player already exists');
        point[player] = points;
    }
    
    function setPlayer(address player,uint points) public {
        require(point[player] != 0,'player is not exists');
        point[player] = points;
    }

}

//代理合约

contract proxyContract is storageStructureContract{

    modifier onlyOwner() {
        require(msg.sender == owner,"not owner");
        _;
    }

    constructor(){
        owner = msg.sender;
    }

    function setImp(address ImpAddress) public onlyOwner {
        require(ImpAddress != address(0),'invalid address');
        implementation = ImpAddress;
    }

    fallback() external payable {
        address impl = implementation;
        assembly{
            let ptr := mload(0x40)
            calldatacopy(ptr,0,calldatasize())
            let result := delegatecall(gas(),impl,ptr,calldatasize(),0,0)
            let size := returndatasize()

            returndatacopy(ptr,0,size)

            switch result
                case 0 { revert(ptr,size) }
                default { return(ptr,size) } 
        }
    }

}

contract implementationContractV2 is implementationContract {

    function addPlayer(address player, uint points) public onlyOwner override {
        require(point[player] == 0,'player already exists');
        point[player] = points;
        totalPlayers ++;
    }
}