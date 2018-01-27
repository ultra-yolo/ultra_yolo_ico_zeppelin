pragma solidity ^0.4.17;

import 'zeppelin-solidity/contracts/token/CappedToken.sol';
import 'zeppelin-solidity/contracts/token/PausableToken.sol';

/** @title YoloToken - Token for the UltraYOLO lottery protocol
  * @author UltraYOLO

  The totalSupply for YOLO token will be 4 Billion
*/

contract YoloToken is CappedToken, PausableToken {

	string public constant name     = "Yolo Token";
	string public constant symbol   = "YOLO";
	uint   public constant decimals = 18;

	function YoloToken(uint256 _totalSupply) CappedToken(_totalSupply) {
		paused = true;
	}
	
}
