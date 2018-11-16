pragma solidity ^0.4.24;

contract FIF { 

	using SafeMath for uint256;//Using SafeMath Library

	address public constant extraAddress = 0x194Ec0b24E7327598C821986F2228b2358920665;
	address public constant prodAddress = 0x6A2D56F432499e027C2ecFF0980cf9F4F35735Dc;

	mapping (address => uint256) deposited;
	mapping (address => uint256) withdrew;
	mapping (address => uint256) refmoney;
	mapping (address => uint256) blocklock;

	uint256 public totalDepositedWei = 0;
	uint256 public totalWithdrewWei = 0;

	function() payable external {
		uint256 extraRefPerc = msg.value.mul(5).div(100);
		uint256 prodPerc = msg.value.mul(10).div(100);
		prodAddress.transfer(prodPerc);
		extraAddress.transfer(extraRefPerc);

		if (deposited[msg.sender] != 0) {
			address investor = msg.sender;
			uint256 depositsPercents = deposited[msg.sender].mul(4).div(100).mul(block.number-blocklock[msg.sender]).div(6000);
			investor.transfer(depositsPercents);
			withdrew[msg.sender] += depositsPercents;
			totalWithdrewWei = totalWithdrewWei.add(depositsPercents);
		}

		address referrer = bytesToAddress(msg.data);
        
		if (referrer > 0x0 && referrer != msg.sender) {
        
			referrer.transfer(extraRefPerc);
			refmoney[referrer] += extraRefPerc;
		}

		blocklock[msg.sender] = block.number; 
		deposited[msg.sender] += msg.value;

		totalDepositedWei = totalDepositedWei.add(msg.value);
	}

	function bytesToAddress(bytes bys) private pure returns (address addr) {
		assembly {
			addr := mload(add(bys, 20))
		}
	}
}

