// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "./mocks/WalletMintLimitImpl.sol";

contract WalletMintLimitTest is Test {
    WalletMintLimitImpl m;

    address MOCK_USER = address(0xaa);

    function setUp() public {
        m = new WalletMintLimitImpl();
    }

    function testLimitZero() public {
        assertEq(m.walletMintLimit(), 0);
    }

    function testSetLimit() public {
        m.setLimit(10);
        assertEq(m.walletMintLimit(), 10);
    }

    function testRevertMintLimitZero() public {
        vm.expectRevert("Exceeds wallet mint limit");
        m.mockMint(MOCK_USER, 1);
    }

    function testRevertAfterLimitHit() public {
        m.setLimit(3);
        m.mockMint(MOCK_USER, 3);

        vm.expectRevert("Exceeds wallet mint limit");
        m.mockMint(MOCK_USER, 1);
    }
}
