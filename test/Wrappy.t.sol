// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "./mocks/WrappyImpl.sol";

contract WrappableTest is Test {
    WrappyImpl presents;

    function setUp() public {
        presents = new WrappyImpl();
    }

    function testAllWrapped(uint256 tokenId) public {
        assertTrue(presents.wrapped(tokenId));
    }

    function testUnwrapAll(uint256 tokenId) public {
        presents.unwrapAll();
        assertFalse(presents.wrapped(tokenId));
    }

    function testWrapUnwrap(uint256 tokenId) public {
        presents.unwrapAll();
        presents.setWrapped(tokenId, true);
        assertTrue(presents.wrapped(tokenId));
        presents.setWrapped(tokenId, false);
        assertFalse(presents.wrapped(tokenId));
    }

    function testRevertIfUnwrapEarly(uint256 tokenId) public {
        vm.expectRevert(abi.encodeWithSignature("WrapUnwrapNotEnabled()"));
        presents.setWrapped(tokenId, false);

        vm.expectRevert(abi.encodeWithSignature("WrapUnwrapNotEnabled()"));
        presents.setWrapped(tokenId, true);
    }
}
