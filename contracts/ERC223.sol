pragma solidity ^0.4.18;

import './ERC223ReceivingContract.sol';

import 'zeppelin-solidity/contracts/token/BasicToken.sol';

contract ERC223 is BasicToken {

  function transfer(address _to, uint _value, bytes _data) public returns (bool) {
    super.transfer(_to, _value);

    // Standard function transfer similar to ERC20 transfer with no _data .
    // Added due to backwards compatibility reasons .
    uint codeLength;

    assembly {
      // Retrieve the size of the code on target address, this needs assembly .
      codeLength := extcodesize(_to)
    }
    if (codeLength > 0) {
      ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
      receiver.tokenFallback(msg.sender, _value, _data);
    }
    Transfer(msg.sender, _to, _value, _data);
  }

  function transfer(address _to, uint _value) public returns (bool) {
    super.transfer(_to, _value);

    // Standard function transfer similar to ERC20 transfer with no _data .
    // Added due to backwards compatibility reasons .
    uint codeLength;
    bytes memory empty;

    assembly {
      // Retrieve the size of the code on target address, this needs assembly .
      codeLength := extcodesize(_to)
    }
    if (codeLength > 0) {
      ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
      receiver.tokenFallback(msg.sender, _value, empty);
    }
    Transfer(msg.sender, _to, _value, empty);
  }

  event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
}
