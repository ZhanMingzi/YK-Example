// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract BoCai{

    address public owner;
    uint public totalSupply;
    uint public bitBigAmount;
    uint public bitSmallAmount;

    bool public isFinished;

    uint public duration;
    uint public startTime;
    uint public endTime;


    // struct User {
    //   address addr;
    //   uint amount;
    //   string bitType;
    // }
    
    // User[] internal user;

    address[] public userBittingBig;
    mapping(address => uint) public userBittingBigAmount;

    address[] public  userBittingSmall;
    mapping(address => uint) public userBittingSmallAmount;

    event trans(address addr,uint amount);

    constructor() {
        owner = msg.sender;
        totalSupply = 0;
        bitBigAmount = 0;
        bitSmallAmount = 0;
        isFinished = false;
        startTime = block.timestamp;
        duration = 2 minutes;
        endTime = startTime + duration;
    }

    function getBalance() external view returns(uint){
        return address(this).balance;
    }

    function bittingBig(uint _bitAmount) external payable returns(address Bitter,uint bitAmount,string memory bitType){
        require(block.timestamp < endTime,"not finished");
        //User memory _user = User({addr:msg.sender,amount:_bitAmount,bitType:"Big"});
        userBittingBig.push(msg.sender);
        userBittingBigAmount[msg.sender] += _bitAmount;
        totalSupply += _bitAmount;
        bitBigAmount += _bitAmount;
        return (msg.sender,_bitAmount,"Big");

    }

    function bittingSmall(uint _bitAmount) external payable returns(address,uint,string memory){
        require(block.timestamp < endTime,"not finished");
        //User memory _user = User({addr:msg.sender,amount:_bitAmount,bitType:"Small"});
        userBittingSmall.push(msg.sender);
        userBittingSmallAmount[msg.sender] += _bitAmount;
        totalSupply += _bitAmount;
        bitSmallAmount += _bitAmount;
        return (msg.sender,_bitAmount,"Small");
    }

    function open() external payable returns(string memory bigOrSmall,uint randomNumber){
        require(totalSupply == bitBigAmount + bitSmallAmount,"amount not equal");
        require(block.timestamp > endTime,"not finished");
        require(!isFinished,"not finished");

        randomNumber = uint(keccak256(abi.encode(block.timestamp,msg.sender)))%18;
        //small : 4  5  6  7  8  9  10
        //big :   11 12 13 14 15 16 17
        

        if(randomNumber >= 4 && randomNumber <= 10){
            bigOrSmall = "Small";
            for (uint i = 0; i < userBittingSmall.length; i++) 
            {
                payable(userBittingSmall[i]).transfer(
                    userBittingSmallAmount[userBittingSmall[i]] +
                    (userBittingSmallAmount[userBittingSmall[i]] * (bitBigAmount * 9 / 10) / bitSmallAmount)
                );
                emit trans(userBittingSmall[i],userBittingSmallAmount[userBittingSmall[i]] +
                    (userBittingSmallAmount[userBittingSmall[i]] * (bitBigAmount * 9 / 10) / bitSmallAmount));
            }
        }
        else if(randomNumber >= 11 && randomNumber <= 17)
        {
            bigOrSmall = "Big";
            for (uint i = 0; i < userBittingBig.length; i++) 
            {
                payable(userBittingBig[i]).transfer(
                    userBittingBigAmount[userBittingBig[i]] +
                    (userBittingBigAmount[userBittingBig[i]] * (bitSmallAmount * 9 / 10) / bitBigAmount)
                );
                emit trans(userBittingBig[i],userBittingBigAmount[userBittingBig[i]] +
                    (userBittingBigAmount[userBittingBig[i]] * (bitSmallAmount * 9 / 10) / bitBigAmount));
                
            }
        }

        payable(owner).transfer(address(this).balance);

        isFinished = true;

    }

}