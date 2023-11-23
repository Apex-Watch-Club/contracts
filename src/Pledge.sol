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
	bool _isFrozen = true;
	uint256 _pledgePrice;
	uint256 _totalPledgedCount;
	uint256 _totalSupply;
	IERC20 _tokenUsdc;
	IERC20 _tokenUsdt;

	// events
	event PledgeUsdt(address _from, address _to, uint256 _amount, uint256 timestamp);
	event PledgeUsdc(address _from, address _to, uint256 _amount, uint256 timestamp);
	event WithdrawUsdt(address _to, uint256 _amount, uint256 timestamp);
	event WithdrawUsdc(address _to, uint256 _amount, uint256 timestamp);
	event Freeze(bool _status, uint256 timestamp);
	event Unfreeze(bool _status, uint256 timestamp);
	event PriceSet(uint256 _old, uint256 _new, uint256 timestamp);
	event SupplySet(uint256 _old, uint256 _new, uint256 timestamp);

	// TODO: FUZZ TESTING
	// TODO: ADD SECURITY CHECKS FOR CONTRACTS EXECUTING FUNCTIONS

	constructor(address _usdt, address _usdc, uint256 _supply, uint256 _price) Ownable(address(msg.sender)) ReentrancyGuard() {
		_tokenUsdt = IERC20(_usdt);
		_tokenUsdc = IERC20(_usdc);
		_pledgePrice = _price;
		_totalSupply = _supply; 
	}

	function pledgeUsdt(uint256 _amount) public nonReentrant returns (bool) {
		// only admin can change state when frozen
		require(!_isFrozen || msg.sender == owner(), "All state changing transactions currently frozen.");
		// must be a multiple of _pledgePrice
		require(_amount % _pledgePrice == 0, 'Pledge amount must be a multiple of current price.');
		// must not exceed set supply
		uint256 _count = _amount / _pledgePrice;
		require(_totalPledgedCount + _count < _totalSupply, "Not enough supply. Consider reducing your pledge count.");
		// must have enough USDT
		require(_amount <= _tokenUsdt.balanceOf(msg.sender), "Insufficient USDT balance.");

		_pledged[msg.sender] = _pledged[msg.sender] + _amount;
		_totalPledgedCount = _totalPledgedCount + _count;

		emit PledgeUsdt(msg.sender, address(this), _amount, block.timestamp);
		return  _tokenUsdt.transferFrom(msg.sender, address(this), _amount);
	}

	function pledgeUsdc(uint256 _amount) public nonReentrant returns (bool) {
		// only admin can change state when frozen
		require(!_isFrozen || msg.sender == owner(), "All state changing transactions currently frozen.");
		// must be a multiple of _pledgePrice
		require(_amount % _pledgePrice == 0, 'Pledge amount must be a multiple of current price.');
		// must not exceed set supply
		uint256 _count = _amount / _pledgePrice;
		require(_totalPledgedCount + _count < _totalSupply, "Not enough supply. Consider reducing your pledge count.");
		// must have enough USDC
		require(_amount <= _tokenUsdc.balanceOf(msg.sender), "Insufficient USDT balance.");

		_pledged[msg.sender] = _pledged[msg.sender] + _amount;
		_totalPledgedCount = _totalPledgedCount + _count;

		emit PledgeUsdc(msg.sender, address(this), _amount, block.timestamp);
		return _tokenUsdc.transferFrom(msg.sender, address(this), _amount);
	}

	function getPledged(address _address) public view returns (uint256) {
		return _pledged[_address];
	}


	function getTotalPledgedCount() public view returns (uint256) {
		return _totalPledgedCount;
	}
	

	function setTotalSupply(uint256 _supply) public onlyOwner returns (uint256) {
		// only admin can change state when frozen
		require(!_isFrozen || msg.sender == owner(), "All state changing transactions currently frozen.");

		emit SupplySet(_totalSupply, _supply, block.timestamp);

		_totalSupply = _supply;
		return _totalSupply;
	}


	function getTotalSupply() public view returns (uint256) {
		return _totalSupply;
	}


	function setPrice(uint256 _newPrice) public onlyOwner returns (uint256) {
		require(!_isFrozen || msg.sender == owner(), "All state changing transactions currently frozen.");
		require(_newPrice > 0, "New price must be greater than 0.");

		emit PriceSet(_pledgePrice, _newPrice, block.timestamp);

		_pledgePrice = _newPrice;
		return _pledgePrice;
	}


	function getPrice() public view returns (uint256) {
		return _pledgePrice;
	}


	/// @dev Prevent all transactions in case of emergency
	function freeze() public onlyOwner {
		require(!_isFrozen, "Already frozen.");
		_isFrozen = true;
		emit Freeze(_isFrozen, block.timestamp);
	}

	function unfreeze() public onlyOwner {
		require(_isFrozen, "Not frozen.");
		_isFrozen = false;
		emit Unfreeze(_isFrozen, block.timestamp);
	}
	
	function withdrawUsdt() public onlyOwner nonReentrant returns (bool) {
		require(msg.sender == owner(), 'Only admin can withdraw USDT.');

		uint256 _amount = _tokenUsdt.balanceOf(address(this));

		emit WithdrawUsdt(msg.sender, _amount, block.timestamp);

		return _tokenUsdt.transfer(msg.sender, _amount);
	}


	function withdrawUsdc() public onlyOwner nonReentrant returns (bool) {
		require(msg.sender == owner(), 'Only admin can withdraw USDC.');

		uint256 _amount = _tokenUsdc.balanceOf(address(this));

		emit WithdrawUsdc(msg.sender, _amount, block.timestamp);

		return _tokenUsdc.transfer(msg.sender, _amount);
	}
}
