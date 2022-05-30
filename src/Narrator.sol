// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Narrator {
    uint _i;
    constructor(uint i){
        _i = i;
    }

    function getFoo() public view returns (uint){
        return _i;
    }
}
