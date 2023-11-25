// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DAO{

    //created structure for proposal
    struct Proposal {
        string description;
        uint voteCount;
        uint yesCount;
        uint noCount;
        bool execute;
    }

    //created structure for members
    struct Members {
        address memberAddress;
        uint memberSince;
        uint tokenBalance;
    }

    //created basic use varibles and mapped them to the entries.
    address[] public members;//takes all the addresses from members
    mapping(address => bool) public isMember;//checks each address to bool is if the person is member or not
    mapping(address => Members) public memberInfo;//if member then get the data. structure member
    mapping(address => mapping (uint => bool)) public votes;
    Proposal[] public proposals;

    uint public totalSupply;
    mapping (address => uint) public balances;

    //event is an inheritable member of the contract
    event proposalCreated(uint indexed proposalId, string description);
    event voteCaste(address indexed voter, uint indexed proposalId, uint tokenAmount);
    event proposalAccepted(string message);
    event proposalRejected(string rejected);

    //creating constructor to initialize owner to the system
    address public owner;
    constructor(){
        owner = msg.sender;
    }

    //creating the functions
    //adding member
    function addMember(address _member) public {
        require(msg.sender == owner);//check if it is being accessed by owner
        require(isMember[_member]==false,"Member already exists");//check if the member already exists
        memberInfo[_member] = Members({
            memberAddress: _member,
            memberSince: block.timestamp,
            tokenBalance: 100
        });//add member data to info variable stucture
        members.push(_member);//adding it to list
        isMember[_member] = true;
        balances[_member] = 100;
        totalSupply += 100;
    }

    //removing member
    function removeMember(address _member) public{
        require(isMember[_member] == true,"Member does not exist");
        memberInfo[_member] = Members({
            memberAddress: address(0),
            memberSince: 0,
            tokenBalance: 0
        });
        for(uint i=0; i<members.length; i++){
            if(members[i] == _member){
                members[i] = members[members.length - 1];
                members.pop();
                break;
            }
        }
        isMember[_member] = false;
        balances[_member] = 0;
        totalSupply -=100;
    }
}