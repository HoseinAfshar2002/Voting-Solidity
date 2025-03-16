// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract Voting {
    struct Detailed {
        uint id;
        string name;
        uint vote;
        uint voteCount;
        uint count;
        address owner;
    }

    mapping(uint => Detailed) public Detailes;
    mapping(address => bool) public userCheckVote;

    address public owner;
    uint public count;

    constructor() {
        owner = msg.sender;
    }

    function addUserVote(string memory name) public returns (string memory) {
        require(msg.sender == owner, "You are not the owner.");
        count++;
        Detailes[count] = Detailed(count, name, 0, 0, count, msg.sender);
        return "success";
    }

    function vote(uint id) public returns (string memory) {
        require(id <= count && id > 0, "Not found.");
        require(!userCheckVote[msg.sender], "You have already voted.");
        Detailes[id].voteCount++;
        userCheckVote[msg.sender] = true;
        return "success";
    }

    function showVote() public view returns (string memory) {
        uint winnerId = 0;
        uint winerVote = 0;

        for (uint i = 1; i <= count; i++) {
            if (Detailes[i].voteCount >= winerVote) {
                winnerId = i;
                winerVote = Detailes[i].voteCount;
            }
        }

        return Detailes[winnerId].name;
    }
}
