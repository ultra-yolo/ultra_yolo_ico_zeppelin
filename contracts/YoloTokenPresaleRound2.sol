pragma solidity ^0.4.18;

import './YoloToken.sol';
import './Crowdsale.sol';
import './CappedCrowdsale.sol';

import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import 'zeppelin-solidity/contracts/lifecycle/Pausable.sol';
import 'zeppelin-solidity/contracts/lifecycle/TokenDestructible.sol';

/**
 * @title YoloTokenPresaleRound2
 * @author UltraYOLO
 
 * Based on widely-adopted OpenZepplin project
 * A total of 200,000,000 YOLO tokens will be sold during presale at a discount rate of 20%
 * Supporters who purchase more than 10 ETH worth of YOLO token will have a discount of 25%
 * Total supply of presale + presale_round_2 + mainsale will be 2,000,000,000
*/

contract YoloTokenPresaleRound2 is CappedCrowdsale, Pausable, TokenDestructible {
  using SafeMath for uint256;

  uint256 public rateTierHigher;
  uint256 public rateTierNormal;

  function YoloTokenPresaleRound2 (uint256 _cap, uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet,
  	address _tokenAddress) 
  CappedCrowdsale(_cap)
  Crowdsale(_startTime, _endTime, _rate, _wallet)
  {
    token = YoloToken(_tokenAddress);
    rateTierHigher = _rate.mul(5).div(4);
    rateTierNormal = _rate.mul(6).div(5);
  }

  function () external payable {
    buyTokens(msg.sender);
  }

  function buyTokens(address beneficiary) public payable {
    require(validPurchase());
    if (msg.value >= 10 ether) {
      rate = rateTierHigher;
    } else {
      rate = rateTierNormal;
    }
    super.buyTokens(beneficiary);
  }

  function validPurchase() internal view returns (bool) {
    return super.validPurchase() && !paused;
  }

  function setCap(uint256 _cap) onlyOwner public {
    cap = _cap;
  }

  function setStartTime(uint256 _startTime) onlyOwner public {
    startTime = _startTime;
  }

  function setEndTime(uint256 _endTime) onlyOwner public {
    endTime = _endTime;
  }

  function setRate(uint256 _rate) onlyOwner public {
    rate = _rate;
    rateTierHigher = _rate.mul(5).div(4);
    rateTierNormal = _rate.mul(6).div(5);
  }

  function setWallet(address _wallet) onlyOwner public {
    wallet = _wallet;
  }

  function withdrawFunds(uint256 amount) onlyOwner public {
    wallet.transfer(amount);
  }

  function resetTokenOwnership() onlyOwner public {
    token.transferOwnership(owner);
  }

}
