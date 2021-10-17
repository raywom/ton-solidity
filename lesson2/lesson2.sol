pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract production {
    uint public prod = 1;

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }
    
    modifier checkOwnerAndAccept {
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
        _;
    }

    function multiply(uint256 value) public checkOwnerAndAccept
    {
        require(value >= 1 && value <= 10, 101, "Value should be in range [0, 10]");
        prod *= value;
    }
}