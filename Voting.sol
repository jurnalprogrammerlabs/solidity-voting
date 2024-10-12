// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    address public owner;
    string[] public candidates;
    mapping(string => uint) public votes;
    mapping(address => bool) public hasVoted;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action.");
        _;
    }

    function addCandidate(string memory _name) public onlyOwner {
        candidates.push(_name);
    }

    function vote(string memory _candidate) public {
        require(!hasVoted[msg.sender], "You have already voted.");
        require(isValidCandidate(_candidate), "Not a valid candidate.");
        
        votes[_candidate] += 1;
        hasVoted[msg.sender] = true;
    }

    function isValidCandidate(string memory _name) private view returns (bool) {
        for (uint i = 0; i < candidates.length; i++) {
            if (keccak256(abi.encodePacked(candidates[i])) == keccak256(abi.encodePacked(_name))) {
                return true;
            }
        }
        return false;
    }

    function getWinner() public view returns (string memory) {
        string memory winner;
        uint highestVotes = 0;
        
        for (uint i = 0; i < candidates.length; i++) {
            if (votes[candidates[i]] > highestVotes) {
                highestVotes = votes[candidates[i]];
                winner = candidates[i];
            }
        }
        return winner;
    }

}


