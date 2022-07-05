// SPDX-License-Identifier: GPL-3.0;
pragma solidity >=0.5.0 <0.9.0;

contract Lottery{

    address public manager;
    address payable[] public participant;

    // set manager address while deploying
    constructor(){
        manager=msg.sender;
    }

    function checkBalance() view public returns(uint){
        //only manager can check the balance
        require(msg.sender==manager);
        return address(this).balance;
    }

    receive() external payable{
        //lottery ticket = 0.1 ETH
        require(msg.value == 1 ether);
        participant.push(payable(msg.sender));
    }

    //this function will generate a randomized value
    function random() view public returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participant.length)));
    }

    function winner() public{

        require(msg.sender==manager);
        require(participant.length>=3);

        //calling random function
        uint randVal=random();

        //getting index of participant
        uint index= randVal % participant.length;

        participant[index].transfer(address(this).balance);
    }


}