
/**
 * This file was generated by TONDev.
 * TONDev is a part of TON OS (see http://ton.dev).
 */
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'GameObject.sol';

contract BaseStation is GameObject{
    uint private healthPoints=200;
    uint private armorPoints = 0;

    GameObject[] public units;

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    function setArmor(uint _armorPoints) override public checkOwnerAndAccept{
        armorPoints+=_armorPoints;
    }

    function getAttack(uint damageValue) virtual external override checkOwnerAndAccept{
        healthPoints -= damageValue;
        if(damageValue>healthPoints+armorPoints){
            healthPoints=0;
            sendMoneyAndSelfDestroy(msg.sender);
        }
        if(isDead()){
            sendMoneyAndSelfDestroy(msg.sender);
        }

    }
    function addUnit(GameObject unit) public checkOwnerAndAccept {
        units.push(unit);
    }

    function delUnit(address unit) public checkOwnerAndAccept {
        for (uint i = 0; i < units.length; i++) {
            units[i] = units[i];
        }
        units.pop();
    }
    function sendMoneyAndSelfDestroy(address dest) override public checkOwnerAndAccept {
        for (uint i = 0; i < units.length; i++) {
            units[i].sendMoneyAndSelfDestroy(dest);
        }
        dest.transfer(1, true, 160);
    }
    function getHP() public checkOwnerAndAccept returns (uint) {
        return healthPoints;
    }
    function isDead() override public checkOwnerAndAccept returns (bool) {
        if(healthPoints <= 0){
            return true;
        } 
        return false;
    }
}
