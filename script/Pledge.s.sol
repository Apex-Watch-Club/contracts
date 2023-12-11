// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import "../src/Pledge.sol";
import "../src/TestToken.sol";


contract PledgeScript is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("GOERLI_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Test Tokens 
        // TestToken usdt = new TestToken("USD Token", "USDT");
        // TestToken usdc = new TestToken("USD Coin", "USDC");

        Pledge pledge = new Pledge(address(0xb20303302b50632d77c33b056F4A30B6A658995D), address(0xe53e949eF30e5E725FCd7705701C810F87dEe8DF), 150, 10000 ether);

        // usdc.mint(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266, 100000 ether);
        // usdt.mint(0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC, 100000 ether);
        // usdc.mint(0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC, 100000 ether);
        //
        // console2.log('balance', usdt.balanceOf(0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC));
        //
        vm.stopBroadcast();
    }
}
