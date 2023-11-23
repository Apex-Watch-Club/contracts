// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Pledge} from "../src/Pledge.sol";
import {TestToken} from "../src/TestToken.sol";

contract PledgeTest is Test {
	address constant OWNER = address(143);
	address constant USER1 = address(1);
	address constant USER2 = address(2);
	address constant USER3 = address(2);
	uint256 constant PRICE = 10_000;

	TestToken usdt = new TestToken("USDT", "USDT");
	TestToken usdc  = new TestToken("USDC", "USDC");
	Pledge pledge = new Pledge(address(usdt), address(usdc), 150, PRICE);

    function setUp() public {
		usdt.mint(OWNER, PRICE);
		usdc.mint(OWNER, PRICE);

		vm.prank(OWNER);
		usdt.transfer(USER1, PRICE);

		vm.prank(OWNER);
		usdc.transfer(USER1, PRICE);

		pledge.unfreeze();
    }

    function test_PledgeUsdt() public {
		vm.startPrank(USER1);
		usdt.approve(address(pledge), PRICE);
		pledge.pledgeUsdt(1);
		vm.stopPrank();

		assertEq(usdt.balanceOf(USER1), 0);
		assertEq(pledge.getPledged(USER1), PRICE);
		assertEq(pledge.getTotalPledgedCount(), 1);
    }
}
