// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract Voting {
    struct Proposal {
        string name;
        string description;
        address creator;
        uint createTime;
        uint endTime;
        uint yesVotes;
        uint noVotes;
        mapping(address => bool) voteCheck;
    }

    Proposal[] public proposals;

    function addProposal(string memory _name, string memory _description, uint _duration) public {
        Proposal storage proposal = proposals.push();
        proposal.name = _name;
        proposal.description = _description;
        proposal.creator = msg.sender;
        proposal.createTime = block.timestamp;
        proposal.endTime = block.timestamp + (_duration * 1 minutes);
        proposal.yesVotes = 0;
        proposal.noVotes = 0;
    }

    function vote(uint index, bool _voteYes) public {
        require(index < proposals.length, "not found....");
        Proposal storage proposal = proposals[index];
        require(!proposal.voteCheck[msg.sender], "already voted this proposal");
        require(block.timestamp < proposal.endTime, "timed out");

        if (_voteYes) {
            proposal.yesVotes++;
        } else {
            proposal.noVotes++;
        }

        proposal.voteCheck[msg.sender] = true;
    }

    // function result(uint indexProposal) public view returns (uint yesVote, uint noVote) {
    //     require(indexProposal < proposals.length, "not found");
    //     Proposal storage proposal = proposals[indexProposal];
    //     return (proposal.yesVotes, proposal.noVotes);
    // }
}
