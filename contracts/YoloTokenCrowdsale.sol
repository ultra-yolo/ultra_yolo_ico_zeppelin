pragma solidity ^0.4.18;

import './YoloToken.sol';

import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import 'zeppelin-solidity/contracts/lifecycle/Pausable.sol';
import 'zeppelin-solidity/contracts/crowdsale/Crowdsale.sol';
import 'zeppelin-solidity/contracts/crowdsale/CappedCrowdsale.sol';

/**
 * The YoloTokenCrowdsale contract conducts crowdsale for UltraYOLO project 

 * WIP
 */
contract YoloTokenCrowdsale is CappedCrowdsale, Pausable {
  using SafeMath for uint256;

  uint256 constant TOKEN_CAP = 4e27;

  address lotteryJackpot;
  address airdropFund;
  address bountyFund;
  address reserveFund;

	function YoloTokenCrowdsale (uint256 _cap, uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet,
    address _tokenAddress)
    CappedCrowdsale(_cap)
    Crowdsale(_startTime, _endTime, _rate, _wallet)
  {
    token = YoloToken(_tokenAddress);
	}

  function () external payable {
    buyTokens(msg.sender);
  }

  function buyTokens(address beneficiary) public payable {
    require(validPurchase());

    super.buyTokens(beneficiary);
  }

  /** Override Crowdsale#validPurchase function to include paused parameter */
  function validPurchase() internal view returns (bool) {
    return super.validPurchase() && !paused;
  }

  /** Sets the token owner to contract owner */
  function resetTokenOwnership() onlyOwner public {
    token.transferOwnership(owner);
  }

  /** only to be called once by the contract owner after token ends and allocates token based on whitepaper */
  function mintRemainingTokens() onlyOwner tokenSaleEnded public {
    mintRemainingYoloToJackpot();
    mintRemainingTokensAsDescribed();
  }

  /** mint unsold YOLO tokens to jackpot as described in whitepaper */
  function mintRemainingYoloToJackpot() internal {
    token.mint(lotteryJackpot, TOKEN_CAP.div(2).sub(token.totalSupply()));
  }

  /** mint rest of YOLO token for airdrops, bounty and reserve as described in whitepaper */
  function mintRemainingTokensAsDescribed() internal {
    token.mint(airdropFund, TOKEN_CAP.div(20));
    token.mint(bountyFund, TOKEN_CAP.div(20));
    token.mint(reserveFund, TOKEN_CAP.sub(token.totalSupply()));
  }

  modifier tokenSaleEnded() {
    if (now < endTime) throw; _;
  }

}
