pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "WarriorUnit.sol";


contract FootmanUnit is WarriorUnit {
    uint private damage = 40;
    uint private healthPoints = 100;
    uint private armorPoints = 0;

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


    function sendMoneyAndSelfDestroy(address dest) virtual public checkOwnerAndAccept override {
        base.popUnit(msg.sender);
        dest.transfer(1, true, 160);
    }

    function isDead() override public checkOwnerAndAccept returns (bool) {
        if(healthPoints <= 0){
            return true;
        } 
        return false;
    }
}