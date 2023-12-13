// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import "../src/Pledge.sol";
import "../src/TestToken.sol";


contract PledgeScript is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("GOERLI_PRIVATE_KEY");
        // uint256 deployerPrivateKey = vm.envUint("MAINNET_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Test Tokens 
        // TestToken usdt = new TestToken("USD Token", "USDT");
        // TestToken usdc = new TestToken("USD Coin", "USDC");

        // GOERLI
        Pledge pledge = new Pledge(address(0x767fb9B61166c8b98578f3E875B237B3aF7FF59d), address(0x32CFFaDC2AcEaf527C95d3F4243D97E6ec1d9Cd9), 150, 10_000_000_000);
        
        // MAINNET
        // Pledge pledge = new Pledge(address(0xdAC17F958D2ee523a2206206994597C13D831ec7), address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48), 150, 10000 ether);

        // usdc.mint(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266, 100000 ether);
        // usdt.mint(0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC, 100000 ether);
        // usdc.mint(0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC, 100000 ether);
        //
        // console2.log('balance', usdt.balanceOf(0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC));
        //
        vm.stopBroadcast();
    }
}

// ##### goerli
// USDT: 0x767fb9B61166c8b98578f3E875B237B3aF7FF59d
// USDC: 0x32CFFaDC2AcEaf527C95d3F4243D97E6ec1d9Cd9
// Pledge: 0x25195eAd6085B49dC978C28F0d9a793872932060

