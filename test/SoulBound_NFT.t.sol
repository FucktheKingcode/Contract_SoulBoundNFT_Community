// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/SoulBound_NFT.sol";  // Adjust the path as necessary
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockERC20 is ERC20 {
    constructor() ERC20("MockToken", "MTK") {
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }
}

contract SoulBoundNFTTest is Test {
    SoulBoundNFT soulBoundNFT;
    MockERC20 mockERC20;

    address owner = address(this);
    address minter1 = address(0x123);
    address minter2 = address(0x456);

    function setUp() public {
        soulBoundNFT = new SoulBoundNFT();
        mockERC20 = new MockERC20();
    }

    function testMinting() public {
        soulBoundNFT.safeMint(minter1, "https://example.com/token/1");
        uint256[] memory minter1Tokens = soulBoundNFT.getSoulboundNFTs(minter1);
        assertEq(minter1Tokens.length, 1);
        assertEq(minter1Tokens[0], 0);

        address[] memory minters = soulBoundNFT.getMinters();
        assertEq(minters.length, 1);
        assertEq(minters[0], minter1);
    }

    function testAirdropTokens() public {
        soulBoundNFT.safeMint(minter1, "https://example.com/token/1");
        soulBoundNFT.safeMint(minter2, "https://example.com/token/2");

        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 100;
        amounts[1] = 200;

        mockERC20.approve(address(soulBoundNFT), 300);
        soulBoundNFT.airdropTokens(address(mockERC20), amounts, 300);

        assertEq(mockERC20.balanceOf(minter1), 100);
        assertEq(mockERC20.balanceOf(minter2), 200);
    }

    function testPreventTransfers() public {
        soulBoundNFT.safeMint(minter1, "https://example.com/token/1");

        vm.prank(minter1);
        vm.expectRevert("Err: token transfer is BLOCKED");
        soulBoundNFT.transferFrom(minter1, minter2, 0);
    }
}

contract MockERC721 is ERC721 {
    uint256 private _nextTokenId;

    constructor() ERC721("MockNFT", "MNFT") {}

    function safeMint(address to, uint256 tokenId) public {
        _safeMint(to, tokenId);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return "https://example.com/token/";
    }
}
