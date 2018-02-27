var SafeMath = artifacts.require('zeppelin-solidity/contracts/math/SafeMath.sol');
var YoloToken = artifacts.require("./YoloToken.sol");
var YoloTokenPresale = artifacts.require("./YoloTokenPresale.sol");
var YoloTokenPresaleRound2 = artifacts.require("./YoloTokenPresaleRound2.sol");
var YoloTokenCrowdsale = artifacts.require("./YoloTokenCrowdsale.sol");

let settings = require("../tokenSettings.json");

module.exports = function(deployer, network, accounts) {

  // deployer.deploy(SafeMath);
  // deployer.link(SafeMath, YoloTokenPresale);
  deployer.link(SafeMath, YoloTokenPresaleRound2);

  var presaleRatioETH = new web3.BigNumber(settings.presaleRatioETH);
  /**
   deployer.deploy(YoloToken, settings.maxTokenSupply).then(function() {
     return deployer.deploy(YoloTokenPresale, settings.presaleCap, settings.presaleStartTimestamp,
       settings.presaleEndTimestamp, presaleRatioETH, settings.ultraYOLOWallet, YoloToken.address);
   });
  */
 deployer.deploy(YoloTokenPresaleRound2, settings.presaleRound2Cap, settings.presaleRound2StartTimestamp,
  settings.presaleRound2EndTimestamp, presaleRatioETH, settings.ultraYOLOWallet, YoloToken.address);
}
