// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TestToken is ERC20 {
	constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {}
	function mint(address _address, uint256 _amount) public {
		_mint(_address, _amount);
	}
}
