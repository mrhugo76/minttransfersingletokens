pragma solidity ^0.4.25<0.8.6;

contract Ownable {

  address public owner;

  function Ownable() public {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    owner = newOwner;
  }
}

interface Token {
  function transfer(address _to, uint256 _value) public returns (bool);
  function balanceOf(address _owner) constant public returns (uint256 balance);
}

contract Register is Ownable {

  Token token;

  event TransferredToken(address indexed to, uint256 value);
  event FailedTransfer(address indexed to, uint256 value);

  modifier whenDropIsActive() {
    assert(isActive());

    _;
  }

  function Register () public {
      address _tokenAddr = "TDvjpjzd24K8HpMV4mERWiUvr4GcsRAHrQ"; 
      token = Token(_tokenAddr);
  }

  function isActive() public constant returns (bool) {
    return (
        tokensAvailable() > 0 
    );
  }
  function sendTokens(address[] dests, uint256[] values) whenDropIsActive onlyOwner external {
    uint256 i = 0;
    while (i < dests.length) {
        uint256 toSend = values[i];
        sendInternally(dests[i] , toSend, values[i]);
        i++;
    }
  }

  function sendTokensSingleValue(address[] dests, uint256 value) whenDropIsActive onlyOwner external {
    uint256 i = 0;
    uint256 toSend = value;
    while (i < dests.length) {
        sendInternally(dests[i] , toSend, value);
        i++;
    }
  }  

  function sendInternally(address recipient, uint256 tokensToSend, uint256 valueToPresent) internal {
    if(recipient == address(0)) return;

    if(tokensAvailable() >= tokensToSend) {
      token.transfer(recipient, tokensToSend);
      TransferredToken(recipient, valueToPresent);
    } else {
      FailedTransfer(recipient, valueToPresent); 
    }
  }   


  function tokensAvailable() public constant returns (uint256) {
    return token.balanceOf(this);
  }

  function destroy() public onlyOwner {
    uint256 balance = tokensAvailable();
    require (balance > 0);
    token.transfer(owner, balance);
    selfdestruct(owner);
  }
}
