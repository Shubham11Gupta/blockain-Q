// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DAO{
    struct Proposal {
        string description;
        uint voteCount;
        uint yesCount;
        uint noCount;
        bool execute;
    }
}