pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract Queue {

    string[] public queue;

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    modifier checkOwnerAndAccept
    {
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
        _;
    }

    function enqueue(string name) public checkOwnerAndAccept
    {
        queue.push(name);
    }

    function dequeue() public checkOwnerAndAccept returns (string[]) {
        for (uint i = 1; i < queue.length; i++) {
            queue[i - 1] = queue[i];
        }
        queue.pop();
        return queue;
    }

}
