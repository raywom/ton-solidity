
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract nft {
    struct DotaAccount {
        string id;
        string name; 
        uint mmr;  
    }

    DotaAccount [] DotaAccounts;
    mapping (uint=>uint) DotaAccountToOwner;
    mapping (uint=>uint) DotaAccountPrice;

    modifier checkOwnerAndAccept(uint DotaAccountId) {
        require(msg.pubkey() == DotaAccountToOwner[DotaAccountId], 102);
        tvm.accept();
        _;
    }

    function addDotaAccount (string id, string name, uint mmr) public {
        for(DotaAccount account : DotaAccounts) {
            require(account.id != id);
        }
        tvm.accept();
        DotaAccounts.push(DotaAccount(id, name, mmr));
        uint key = DotaAccounts.length - 1;
        DotaAccountToOwner[key] = msg.pubkey();
    }

    function getDotaAccountOwner (uint DotaAccountId) public view returns (uint) {
        return DotaAccountToOwner[DotaAccountId];
    }

    function getDotaAccountInfo (uint DotaAccountId) public view returns (string DotaAccountid, string DotaAccountName, uint MMR) {
        DotaAccountid = DotaAccounts[DotaAccountId].id;
        DotaAccountName = DotaAccounts[DotaAccountId].name; 
        MMR = DotaAccounts[DotaAccountId].mmr;
    }

    function putOnSale (uint DotaAccountId, uint price) public checkOwnerAndAccept(DotaAccountId) {
        DotaAccountPrice[DotaAccountId] = price;
    }

    function changeDotaAccountId (uint DotaAccountId, uint newDotaAccountId) public checkOwnerAndAccept(DotaAccountId) {
        DotaAccountToOwner[DotaAccountId] = newDotaAccountId;
    }

}