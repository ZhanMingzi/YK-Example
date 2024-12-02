// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract GrabRedEnvelope{

    uint public redEnvelopeLeft;
    bool public grabMode;
    //grabMode 
    //true : average
    //false ：random
    address public redEnvelopeSender;

    uint public initTotalAmount;
    uint public initRedEnvelopeCount;
    address public owner;

    constructor(bool _grabMode,uint _redEnvelopeCount) payable {
        require(_redEnvelopeCount <= msg.value,"Each grab should greater than or equal one wei.");
        redEnvelopeLeft = _redEnvelopeCount;
        initRedEnvelopeCount = _redEnvelopeCount;
        grabMode = _grabMode;
        redEnvelopeSender = msg.sender;
        initTotalAmount = msg.value;
        owner = msg.sender;
    }

    function CheckBalance() external view returns(uint) {
        return address(this).balance;
    }

    modifier Owner {
        require(msg.sender == owner,"not owner");
        _;
    }

    function GrabAction() external returns(
        address grabedUser,
        uint grabedAmount,
        uint ,
        uint totalAmount
    ) {
        require(address(this).balance > 0,"No balance now");

        grabedUser = msg.sender;
        totalAmount = address(this).balance;

        if(redEnvelopeLeft == 1)
        {
            grabedAmount = address(this).balance;
        }
        else
        {
            if(grabMode)
            {
                grabedAmount = initTotalAmount / initRedEnvelopeCount;
            }
            else
            {
                uint randomNumber = uint(keccak256(abi.encode(block.timestamp,msg.sender)))%10;
                grabedAmount = randomNumber * totalAmount / 10;
            }
        }

        payable(msg.sender).transfer(grabedAmount);
        redEnvelopeLeft--;

        return (grabedUser,grabedAmount,redEnvelopeLeft,initTotalAmount);


        

    }
    
    function kill() external payable Owner {
        selfdestruct(payable (msg.sender));
        
    }


}