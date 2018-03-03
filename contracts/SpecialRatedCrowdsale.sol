pragma solidity ^0.4.18;

import './Crowdsale.sol';

import 'zeppelin-solidity/contracts/lifecycle/TokenDestructible.sol';

/**
 * The SpecialRatedCrowdsale contract
 */
contract SpecialRatedCrowdsale is Crowdsale, TokenDestructible {
  mapping(address => uint) addressToSpecialRates;

  function SpecialRatedCrowdsale() { }

  function addToSpecialRatesMapping(address _address, uint specialRate) onlyOwner public {
    addressToSpecialRates[_address] = specialRate;
  }

  function removeFromSpecialRatesMapping(address _address) onlyOwner public {
    delete addressToSpecialRates[_address];
  }

  function querySpecialRateForAddress(address _address) onlyOwner public returns(uint) {
    return addressToSpecialRates[_address];
  }
  

  function buyTokens(address beneficiary) public payable {
    if (addressToSpecialRates[beneficiary] != 0) {
      rate = addressToSpecialRates[beneficiary];
    }

    super.buyTokens(beneficiary);
  }
}
