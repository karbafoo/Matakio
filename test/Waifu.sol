// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/Vm.sol";
import "forge-std/console.sol";
import "../src/Narrator.sol";
import "../src/Waifu.sol";
contract ContractTest is Test {
    Narrator narrator;
    Waifu waifu;
    function setUp() public {
        narrator = new Narrator(7);
        waifu = new Waifu(7);
        waifu.mint();
        vm.roll(100);
    }

    function testExample() public {
        require(narrator.getFoo() == 7);
        uint8[8] memory s = waifu.getStats(0)[0];
        uint[8] memory b = waifu.getTrainingProgress(0);
        for(uint i = 0 ; i < 8; i++){
            console.log(b[i]);
        }
        console.log("after");
        waifu.setTraining(0, 1);
        vm.roll(150);
        for(uint i = 0 ; i < 8; i++){
            console.log("stat", i, s[i]);
            console.log("saved progress", b[i]);
            console.log("current", waifu.getCurrentProgress(0, uint8(b[i])));
        }
        waifu.lvlUp(0, [1,1,1,1,1,1,0,0]);
        s = waifu.getStats(0)[0];
        for(uint i = 0 ; i < 8; i++){
            console.log("stat after lvlup 150", i, s[i]);
            console.log("saved progress", b[i]);
            console.log("current", waifu.getCurrentProgress(0, uint8(b[i])));
        }

        vm.roll(200);
        b = waifu.getTrainingProgress(0);
        for(uint i = 0 ; i < 8; i++){
            console.log("stat after lvlup 200", i, s[i]);
            console.log("saved progress", b[i]);
            console.log("current", waifu.getCurrentProgress(0, uint8(b[i])));
        }

        uint blockHeight = 200;
        waifu.lvlUp(0, [1,1,1,1,1,1,0,0]);
        blockHeight += 50;
        vm.roll(blockHeight);
        waifu.lvlUp(0, [1,1,1,1,1,1,0,0]);
        blockHeight += 50;
        vm.roll(blockHeight);
        waifu.lvlUp(0, [1,1,1,1,1,1,0,0]);
        blockHeight += 50;
        vm.roll(blockHeight);
        waifu.lvlUp(0, [1,1,1,1,1,1,0,0]);
        blockHeight += 50;
        vm.roll(blockHeight);
        waifu.lvlUp(0, [1,1,1,1,1,1,0,0]);
        blockHeight += 50;
        vm.roll(blockHeight);
        waifu.lvlUp(0, [1,1,1,1,1,1,0,0]);
        blockHeight += 64;
        vm.roll(blockHeight);
        waifu.lvlUp(0, [1,1,1,1,1,1,0,0]);
        blockHeight += 63;
        vm.roll(blockHeight);

        b = waifu.getTrainingProgress(0);
        s = waifu.getStats(0)[0];
        for(uint i = 0 ; i < 8; i++){
            console.log("stat after lvlup many", i, s[i]);
            console.log("saved progress", b[i]);
            console.log("current", waifu.getCurrentProgress(0, uint8(b[i])));
        }
        assertTrue(true);
    }
}
