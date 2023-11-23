// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/// @author Kristian Quirapas
/// @title Owned Pledge Contract
contract Pledge is Ownable, ReentrancyGuard {
	// mappings
    mapping(address => uint256) _pledged;
	// variables
	bool isFrozen = true;
	uint256 _pledgePrice;
	uint256 _totalPledgedCount;
	uint256 _totalSupply;
	IERC20 _tokenUsdc;
	IERC20 _tokenUsdt;

	// events
	// event PledgeUsdt();
	// event WithdrawUsdt();
	// event PledgeUsdc();
	// event WithdrawUsdc();

	// TODO: FUZZ TESTING
	// TODO: ADD SECURITY CHECKS FOR CONTRACTS EXECUTING FUNCTIONS

	constructor(address _usdt, address _usdc, uint256 _supply, uint256 _price) Ownable(address(msg.sender)) ReentrancyGuard() {
		_tokenUsdt = IERC20(_usdt);
		_tokenUsdc = IERC20(_usdc);
		_pledgePrice = _price;
		_totalSupply = _supply; 
	}

	function pledgeUsdt(uint256 _count) public nonReentrant returns (bool) {
		// only admin can change state when frozen
		require(!isFrozen || msg.sender == owner(), "All state changing transactions currently frozen.");
		require(_totalPledgedCount + _count < _totalSupply, "Not enough supply. Consider reducing your pledge count.");

		uint256 _amount = _count * _pledgePrice;

		require(_amount <= _tokenUsdt.balanceOf(msg.sender), "Insufficient USDT balance.");

		_pledged[msg.sender] = _pledged[msg.sender] + _amount;
		_totalPledgedCount = _totalPledgedCount + _count;

		_tokenUsdt.transferFrom(msg.sender, address(this), _amount);
	}
	

	function pledgeUsdc(uint256 _count) public nonReentrant returns (bool) {
		// only admin can change state when frozen
		require(!isFrozen || msg.sender == owner(), "All state changing transactions currently frozen.");
		require(_totalPledgedCount + _count < _totalSupply, "Not enough supply. Consider reducing your pledge count.");

		uint256 _amount = _count * _pledgePrice;

		require(_amount <= _tokenUsdc.balanceOf(msg.sender), "Insufficient USDC balance.");

		_pledged[msg.sender] = _pledged[msg.sender] + _amount;
		_totalPledgedCount = _totalPledgedCount + _count;

		_tokenUsdc.transferFrom(msg.sender, address(this), _amount);
	}


	function getPledged(address _address) public view returns (uint256) {
		return _pledged[_address];
	}


	function getTotalPledgedCount() public view returns (uint256) {
		return _totalPledgedCount;
	}
	

	function setTotalSupply(uint256 _supply) public onlyOwner returns (uint256) {
		// only admin can change state when frozen
		require(!isFrozen || msg.sender == owner(), "All state changing transactions currently frozen.");
		_totalSupply = _supply;
		return _totalSupply;
	}


	function getTotalSupply() public view returns (uint256) {
		return _totalSupply;
	}


	function setPrice(uint256 _newPrice) public onlyOwner returns (uint256) {
		require(!isFrozen || msg.sender == owner(), "All state changing transactions currently frozen.");
		require(_newPrice > 0, "New price must be greater than 0.");
		_pledgePrice = _newPrice;
		return _pledgePrice;
	}


	function getPrice() public view returns (uint256) {
		return _pledgePrice;
	}


	/// @dev Prevent all transactions in case of emergency
	function freeze() public onlyOwner {
		require(!isFrozen, "Already frozen.");
		isFrozen = true;
	}

	function unfreeze() public onlyOwner {
		require(isFrozen, "Not frozen.");
		isFrozen = false;
	}
	
	function withdrawUsdt() public onlyOwner nonReentrant returns (bool) {
		require(msg.sender == owner(), 'Only admin can withdraw USDT.');
		return _tokenUsdt.transferFrom(address(this), msg.sender, _tokenUsdt.balanceOf(address(this)));
	}


	function withdrawUsdc() public onlyOwner nonReentrant returns (bool) {
		require(msg.sender == owner(), 'Only admin can withdraw USDC.');
		return _tokenUsdc.transferFrom(address(this), msg.sender, _tokenUsdc.balanceOf(address(this)));
	}

	// fallback() {}
}
