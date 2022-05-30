// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "forge-std/console.sol";
contract Waifu {

    uint _id;
    uint MAX = 666666;
    uint POINTS_PER = 6;
    struct Body {
        uint8 hair;
        uint8 face;
        uint8 eyeR;
        uint8 eyeL;
        uint8 earR;
        uint8 earL;
        uint8 eyebrows;
        uint8 nose;
        uint8 mouth;
        uint8 body;
        uint8 adonis;
    }
    struct Gear {
        uint8 neck;
        uint8 head;
        uint8 eyes;
        uint8 shoulderR;
        uint8 shoulderL;
        uint8 handR;
        uint8 handL;
        uint8 chest;
        uint8 waist;
        uint8 legs;
        uint8 footR;
        uint8 footL;
    }
    struct Stat {
        uint8 strength;
        uint8 agility;
        uint8 intelligence;
        uint8 mSpeed;
        uint8 aSpeed;
        uint8 mastery;
        uint8 ruthless;
        uint8 mischief;
    } 
    struct Profession {
        uint8 tailoring;
        uint8 cooking;
        uint8 blacksmithing;
        uint8 mining;
        uint8 alchemy;
        uint8 jewelry;
        uint8 engineering;
        uint8 pizzazz;
    }
  


    mapping(uint => uint8[12]) _body;
    mapping(uint => uint8[12]) _gear;
    mapping(uint => uint8[8]) _stat;
    mapping(uint => uint8[8]) _profession;
    mapping(uint => uint[8]) _progress;
    mapping(uint => uint) _progressStart;
    mapping(uint => uint8) _trainingIndex;

    uint8[8][8] _trainingCoefs;

    constructor(uint i_){
        console.logString("FOOO");
        for(uint i = 0 ; i < 8; i++){
            _progress[0][i] = block.number;
        }

        _trainingCoefs = [
            [255,255,255,255,255,255,255,255],
            [255,255,255,255,255,255,255,255],
            [255,255,255,255,255,255,255,255],
            [255,255,255,255,255,255,255,255],
            [255,255,255,255,255,255,255,255],
            [255,255,255,255,255,255,255,255],
            [255,255,255,255,255,255,255,255],
            [255,255,255,255,255,255,255,255]
        ];
    }

    function mint() public returns (uint){
        require(_id < MAX, "Waifu: MAX SUPPLY REACHED.");
        uint id = _id;
        _stat[id] = [1,1,1,1,1,1,1,1];
        _id += 1;
        return id;
    }
    function getTrainingProgress(uint id_) public view returns (uint[8] memory){
        return _progress[id_];
    } 
    function getCurrentProgress(uint id_, uint8 o_) public view returns (uint){
        if(o_ >= _trainingCoefs.length){
            return 0;
        }
        uint bProgress = _progress[id_][o_];
        uint bLevel = _profession[id_][o_];
        uint aLevel = (bLevel + 1) ** 2;

        uint c;
        uint8[8] memory stat = _stat[id_];
        uint8[8] memory coefs = _trainingCoefs[o_];
        for(uint i = 0 ; i < stat.length; i++){
            c += stat[i] * (coefs[i] / 256);
        }
        if(c < 1){
            c = 1;
        }
        uint t = getProgressTimeElapsed(id_);
        uint p = c*t;
        if(p > aLevel){
            p = aLevel;
        }
        return p;
    }
    function getProgressTimeElapsed(uint id_) public view returns (uint){
        uint t;
        if(block.number > _progressStart[id_]){
            t = block.number - _progressStart[id_];
        }
        return t;
    }

    function setTraining(uint id_, uint8 o_) public {
        require(o_ <= _trainingCoefs.length, "Waifu: 404 Training");
        uint currentProgress = getCurrentProgress(id_, o_);
        uint t = getProgressTimeElapsed(id_);
        uint bLevel = _profession[id_][o_];
        uint aLevel = (bLevel + 1) ** 2;

        if(currentProgress >= aLevel){
            currentProgress = aLevel;
        }


        _progress[id_][_trainingIndex[id_]]  = currentProgress;
        _setTraining(id_, o_);
    }

    function lvlUp(uint id_, uint8[8] calldata points_) public {
        uint8 o = _trainingIndex[id_];
        uint currentProgress = getCurrentProgress(id_, o);
        uint t = getProgressTimeElapsed(id_);
        uint bLevel = _profession[id_][o];
        uint aLevel = (bLevel + 1) ** 2;

        require(currentProgress >= aLevel, "Waifu: NOT ENOUGH XP");

        uint8[8] memory stat = _stat[id_];
        uint tp;
        for(uint i = 0; i < stat.length; i++){
            tp += points_[i];
        }
        
        require(tp <= POINTS_PER, "Waifu: Overstimulating");
        for(uint i = 0; i < stat.length; i++){
            stat[i] += points_[i];
        }
        _stat[id_] = stat;
        _progress[id_][o]  = 0;
        _profession[id_][o] += 1;
        _setTraining(id_, o);
    }

    function _setTraining(uint id_, uint8 o_) internal {
        _progressStart[id_]  = block.number;
        _trainingIndex[id_] = o_;
    }

    function getBody(uint id_) public view returns (uint8[12][2] memory){
        return [_body[id_], _gear[id_]];
    }
    function getStats(uint id_) public view returns (uint8[8][2] memory){
        return [_stat[id_], _profession[id_]];
    }

}
