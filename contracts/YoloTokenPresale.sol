pragma solidity ^0.4.18;

import './YoloToken.sol';
import './Crowdsale.sol';
import './CappedCrowdsale.sol';

import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import 'zeppelin-solidity/contracts/lifecycle/Pausable.sol';
import 'zeppelin-solidity/contracts/lifecycle/TokenDestructible.sol';

/**
 * @title YoloTokenPresale
 * @author UltraYOLO
 
 * Based on widely-adopted OpenZepplin project
 * A total of 200,000,000 YOLO tokens will be sold during presale at a discount rate of 25% ($0.00375)
 * Supporters who purchase more than 25 ETH worth of YOLO token will have a discount of 35%
 * Total supply of presale + mainsale will be 2,000,000,000
*/

contract YoloTokenPresale is CappedCrowdsale, Pausable, TokenDestructible {
  using SafeMath for uint256;

  uint256 public rateTierHigher;
  uint256 public rateTierNormal;

  function YoloTokenPresale (uint256 _cap, uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet,
  	address _tokenAddress) 
  CappedCrowdsale(_cap)
  Crowdsale(_startTime, _endTime, _rate, _wallet)
  {
    token = YoloToken(_tokenAddress);
    rateTierHigher = _rate.mul(27).div(20);
    rateTierNormal = _rate.mul(5).div(4);
  }

  function () external payable {
    buyTokens(msg.sender);
  }

  function buyTokens(address beneficiary) public payable {
    require(validPurchase());

    if (msg.value >= 25 ether) {
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
    rateTierHigher = _rate.mul(27).div(20);
    rateTierNormal = _rate.mul(5).div(4);
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
