// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {SoulBoundNFT} from "../src/SoulBound_NFT.sol";  // Adjust the path as necessary

contract SoulBoundNFTScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        // Deploy the SoulBoundNFT contract
        SoulBoundNFT soulBoundNFT = new SoulBoundNFT();
        console.log("SoulBoundNFT deployed at:", address(soulBoundNFT));

        // Mint an NFT to an address
        address to = address(0x123);
        soulBoundNFT.safeMint(to, "https://example.com/token/1");
        console.log("Minted NFT to:", to);

        // Fetch and log the minters
        address[] memory minters = soulBoundNFT.getMinters();
        console.log("Minters count:", minters.length);
        for (uint256 i = 0; i < minters.length; i++) {
            console.log("Minter:", minters[i]);
        }

        vm.stopBroadcast();
    }
}
