// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DAO{

    //created structure for proposal
    struct Proposal {
        string description;
        uint voteCount;
        uint yesCount;
        uint noCount;
        bool executed;
    }

    //created structure for members
    struct Members {
        address memberAddress;
        uint memberSince;
        uint tokenBalance;
    }

    //created basic use varibles and mapped them to the entries.
    address[] public members;//takes all the addresses from members
    mapping(address => bool) public isMember;//checks each address to bool is if the person is member or not // this is like ismembers[address]=bool
    mapping(address => Members) public memberInfo;//if member then get the data. structure member // this is like memberinfo[address] = members
    mapping(address => mapping (uint => bool)) public votes;//it is like a 2d array line 95 first dimention will be the address and the second dimention will be id, the value will be bool format votes[address][int] = bool
    Proposal[] public proposals;//this is an array of objects of structure that was created above

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
        for(uint i=0; i<members.length; i++){//basic stack function to remve element , swap node with last node and then pop the last node
            if(members[i] == _member){
                members[i] = members[members.length - 1];
                members.pop();
                break;
            }
        }//initializing all the variables of sturcture to default
        isMember[_member] = false;
        balances[_member] = 0;
        totalSupply -=100;//decreasing the coin count.
    }

    //this function creates the default proposal data from structure and push it to proposals array and calles the event to register log
    function createProposal(string memory _description) public {
        proposals.push(Proposal({
            description : _description,
            voteCount : 0,
            yesCount : 0,
            noCount : 0,
            executed : false
        }));
        emit proposalCreated(proposals.length -1 , _description); // this will register th log that a proposal is created
    }

    //this function will add the votes to the main list // Yes vote count
    function voteYes(uint _proposalId, uint _tokenAmount) public { 
        //tokenAmount is amout required to caste 1 vote
        // all requirements are being checnd
        require(isMember[msg.sender] == true , "You have to be a member to vote");
        require(balances[msg.sender] >= _tokenAmount, "Not enough tokens to vote");
        require(votes[msg.sender][_proposalId] == false, "You have already voted");
        votes[msg.sender][_proposalId] = true;
        memberInfo[msg.sender].tokenBalance -= _tokenAmount; // costing the person the token to caste a vote
        proposals[_proposalId].voteCount += _tokenAmount;// adding the vote count. // not sure why is it not +1 but +token count, like token count is multiple to multiple votes from 1 person //doubt.
        proposals[_proposalId].yesCount += _tokenAmount;
        emit voteCaste(msg.sender, _proposalId, _tokenAmount);//creating log of vote casting
    }

    // this function is for No Vote count
    function voteNo(uint _proposalId, uint _tokenAmount) public{
        //same as above just for no.
        require(isMember[msg.sender] == true , "You have to be a member to vote"); // require is a conditional operator which gives as if require(condition, case if false)// so if the condition failes then it will exit the function stating the response else if condition comes true then only the program will move ahead.
        require(balances[msg.sender] >= _tokenAmount, "Not enough tokens to vote");
        require(votes[msg.sender][_proposalId] == false, "You have already voted");
        votes[msg.sender][_proposalId] = true;
        memberInfo[msg.sender].tokenBalance -= _tokenAmount; // costing the person the token to caste a vote
        proposals[_proposalId].voteCount += _tokenAmount;// adding the vote count. // not sure why is it not +1 but +token count, like token count is multiple to multiple votes from 1 person //doubt.
        proposals[_proposalId].noCount += _tokenAmount;
        emit voteCaste(msg.sender, _proposalId, _tokenAmount);//creating log of vote casting
    }

    //the function to execute proposal if the final result of voting is yes.
    function executeProposal(uint _proposalId) public {
        require(proposals[_proposalId].executed == false,"Proposal has already been executed");
        require(proposals[_proposalId].yesCount > proposals[_proposalId].noCount);// a require can also be held like this with no false response, thi will directly just exit the function.
        proposals[_proposalId].executed = true;// the proposal can be executed, data change fo the proposal
        emit proposalAccepted("Proposal has been approved");
    }
}