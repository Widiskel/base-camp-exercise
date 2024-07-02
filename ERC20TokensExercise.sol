// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/structs/EnumerableSet.sol";

contract WeightedVoting is ERC20{
    uint public maxSupply = 1000000;

    error TokensClaimed();
    error AllTokensClaimed();
    error NoTokensHeld();
    error QuorumTooHigh(uint quorum);
    error AlreadyVoted();
    error VotingClosed();

    using EnumerableSet for EnumerableSet.AddressSet;
    struct Issue {
        EnumerableSet.AddressSet voters;
        string issueDesc;
        uint votesFor;
        uint votesAgainst;
        uint votesAbstain;
        uint totalVotes;
        uint quorum;
        bool passed;
        bool closed;
    }

    struct IssueView {
        address[] voters;
        string issueDesc;
        uint votesFor;
        uint votesAgainst;
        uint votesAbstain;
        uint totalVotes;
        uint quorum;
        bool passed;
        bool closed;
    }

    Issue[] issues;
    enum Votes { AGAINST, FOR, ABSTAIN }

    constructor() ERC20("WeightedVotingToken", "WVT") {
        
    }

    function claim() public{
        if (balanceOf(msg.sender) > 0) {
            revert TokensClaimed();
        }
        if (totalSupply() >= maxSupply) {
            revert AllTokensClaimed();
        }
        _mint(msg.sender, 100);
    }

    function createIssue(string memory _issueDesc, uint _quorum) external returns(uint) {
        if(balanceOf(msg.sender) == 0){
            revert NoTokensHeld();
        }
        if(_quorum > totalSupply()){
            revert QuorumTooHigh(_quorum);
        }
        issues.push();
        Issue storage newIssue = issues[issues.length - 1];
        // newIssue.voters.add(msg.sender);
        newIssue.issueDesc = _issueDesc;
        newIssue.quorum = _quorum;

        return issues.length - 1;
    }

    function getIssue(uint _id) external view returns (IssueView memory) {
        Issue storage issue = issues[_id];

        EnumerableSet.AddressSet storage voters = issue.voters;
        address[] memory votersArray = new address[](EnumerableSet.length(voters));

        for(uint i = 0; i < EnumerableSet.length(voters); i++) {
            votersArray[i] = EnumerableSet.at(voters, i);
        }

        return (
            IssueView({
                voters: votersArray,
                issueDesc: issue.issueDesc,
                votesFor: issue.votesFor,
                votesAgainst: issue.votesAgainst,
                votesAbstain: issue.votesAbstain,
                totalVotes: issue.totalVotes,
                quorum: issue.quorum,
                passed: issue.passed,
                closed: issue.closed
            })
        );
    }

    function vote(uint _issueId, Votes _vote) public{
        if(balanceOf(msg.sender) == 0){
            revert NoTokensHeld();
        }
        if(issues[_issueId].closed){
            revert VotingClosed();
        }
        if(issues[_issueId].voters.contains(msg.sender)){
            revert AlreadyVoted();
        }
        issues[_issueId].voters.add(msg.sender);
        issues[_issueId].totalVotes += balanceOf(msg.sender);

        if (_vote == Votes.FOR) {
            issues[_issueId].votesFor += balanceOf(msg.sender);
        } else if (_vote == Votes.AGAINST) {
            issues[_issueId].votesAgainst += balanceOf(msg.sender);
        } else if (_vote == Votes.ABSTAIN) {
            issues[_issueId].votesAbstain += balanceOf(msg.sender);
        } else {
            revert("Invalid vote option");
        }

        if (issues[_issueId].totalVotes >= issues[_issueId].quorum) {
        issues[_issueId].closed = true;
            if (issues[_issueId].votesFor > issues[_issueId].votesAgainst) {
                issues[_issueId].passed = true;
            }
        }
    }
}