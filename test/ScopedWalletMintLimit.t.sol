// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/ScopedWalletMintLimit.sol";

contract ScopedWalletMintLimitTest is Test, ScopedWalletMintLimit {
    address MOCK_USER = address(0xaa);

    function setUp() public {}

    function testLimitZero() public {
        assertEq(scopedWalletMintLimits["test"].limit, 0);
    }

    function testSetLimit() public {
        _setWalletMintLimit("test", 10);
        assertEq(scopedWalletMintLimits["test"].limit, 10);
    }

    function testRevertMintLimitZero() public {
        vm.expectRevert("Exceeds wallet mint limit for test");
        _limitScopedWalletMints("test", MOCK_USER, 1);
    }

    function testRevertAfterLimitHit() public {
        _setWalletMintLimit("test", 3);
        _limitScopedWalletMints("test", MOCK_USER, 3);

        vm.expectRevert("Exceeds wallet mint limit for test");
        _limitScopedWalletMints("test", MOCK_USER, 1);
    }

    function testDifferentScopesDifferentLimits() public {
        _setWalletMintLimit("test", 3);
        _setWalletMintLimit("test2", 5);

        _limitScopedWalletMints("test", MOCK_USER, 3);
        _limitScopedWalletMints("test2", MOCK_USER, 5);

        vm.expectRevert("Exceeds wallet mint limit for test");
        _limitScopedWalletMints("test", MOCK_USER, 1);

        vm.expectRevert("Exceeds wallet mint limit for test2");
        _limitScopedWalletMints("test2", MOCK_USER, 1);
    }
}
