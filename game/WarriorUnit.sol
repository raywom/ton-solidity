pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "GameObject.sol";
import "BaseStation.sol";

contract WarriorUnit is GameObject {

    uint private damage;
    uint private healthPoints;
    uint private armorPoints;

    BaseStation private base;
    address private baseAddress = address(base);

    function attack(IGameObject enemy) virtual public checkOwnerAndAccept {
        require(enemy != base, 101);
        enemy.getAttack(damage);
    }

    function setDamage(uint damageValue) virtual public checkOwnerAndAccept {
        damage += damageValue;
    }

    function sendMoneyAndSelfDestroy(address dest) virtual public checkOwnerAndAccept override {
        base.delUnit(msg.sender);
        dest.transfer(1, true, 160);
    }

    function setArmor(uint _armorPoints) virtual override public checkOwnerAndAccept{
        armorPoints += _armorPoints;
    }

    function getAttack(uint damageValue) virtual external override checkOwnerAndAccept{
        if(damageValue>armorPoints){
            healthPoints -= damageValue - armorPoints;
        }
        else{
            armorPoints -= damageValue;
        }
        if(damageValue>healthPoints+armorPoints){
            healthPoints=0;
            sendMoneyAndSelfDestroy(msg.sender);
        }
        if(isDead()){
            sendMoneyAndSelfDestroy(msg.sender);
        }

    }

    function isDead() virtual override public checkOwnerAndAccept returns (bool) {
        if(healthPoints <= 0){
            return true;
        } 
        return false;
    }
}