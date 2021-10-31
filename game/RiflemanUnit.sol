pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "WarriorUnit.sol";


contract Archer is WarriorUnit {
    uint private damage = 60;
    uint private healthPoints = 80;
    uint private armorPoints;

    BaseStation private base;
    address private baseAddress = address(base);

    constructor(BaseStation _base) public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
        base = _base;
        base.addUnit(this);
    }

    function attack(IGameObject enemy) override virtual public checkOwnerAndAccept {
        require(enemy != base, 101);
        enemy.getAttack(damage);
    }

    function setDamage(uint damageValue) virtual public checkOwnerAndAccept override {
        damage += damageValue;
    }

    function setArmor(uint _armorPoints) override public checkOwnerAndAccept{
        armorPoints += _armorPoints;
    }

    function getAttack(uint damageValue) virtual external override checkOwnerAndAccept{
        if(damageValue!=0){
            healthPoints -= damageValue - armorPoints;
        }
        else {
            armorPoints-=damageValue;
        }
        if(isDead()){
            sendMoneyAndSelfDestroy(msg.sender);
        }

    }

    function sendMoneyAndSelfDestroy(address dest) virtual public checkOwnerAndAccept override {
        base.delUnit(msg.sender);
        dest.transfer(1, true, 160);
    }

    function isDead() override public checkOwnerAndAccept returns (bool) {
        if(healthPoints < 0){
            return false;
        } 
        return true;
    }
}