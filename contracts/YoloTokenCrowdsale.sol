pragma solidity ^0.4.18;

import './YoloToken.sol';

import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import 'zeppelin-solidity/contracts/lifecycle/Pausable.sol';
import 'zeppelin-solidity/contracts/crowdsale/Crowdsale.sol';
import 'zeppelin-solidity/contracts/crowdsale/CappedCrowdsale.sol';

/**
 * The YoloTokenCrowdsale contract conducts crowdsale for UltraYOLO project 
 */
contract YoloTokenCrowdsale is CappedCrowdsale, Pausable {
  using SafeMath for uint256;

  address public tokenAddress;
	function YoloTokenCrowdsale (uint256 _cap, uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet,
    address _tokenAddress) {
		
	}	
  
  /** Override  Crowdsale#createTokenContract method to mint YOLOTokens */
  function createTokenContract() internal returns (MintableToken) {
    return YoloToken(tokenAddress);
  }
  
  /** Override Crowdsale#validPurchase function to include paused parameter */
  function validPurchase() internal view returns (bool) {
      return super.validPurchase() && !paused;
  }

  /** Sets the token owner to contract owner */
  function resetTokenOwnership() onlyOwner public { 
    token.transferOwnership(owner);
  }
}

