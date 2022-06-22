// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "./mocks/MultiTimedSignedPassesImpl.sol";

contract SignedPassTimedAccessTest is Test {
    MultiTimedSignedPassesImpl impl;

    address MOCK_USER = address(0xaa);
    string constant PREFIX = "NERVOUS";
    address USER = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
    bytes SIGNED_MESSAGE =
        hex"65714667e2687d1fd85f5f3ac45c732f3e356d8b8dbf5d8c01c9fa114b10271c5faecb08f89c276743eb350ca31817c9764f8d722e0807e23c3b72500265badd1b";
    address SIGNER = 0x1301044Ef935AE71a97fAd3cBa745846a4761B4c;

    function setUp() public {
        impl = new MultiTimedSignedPassesImpl(2);
    }

    function testSetSigner() public {
        impl.setTimedSigner(0, address(0xac), 2);

        MultiTimedSignedPassesImpl.TimedSigner memory t = impl.timedSigners(0);
        assertEq(t.signer, address(0xac));
        assertEq(t.startTime, 2);
    }

    function testSetAndCheck() public {
        assertFalse(impl.checkTimedSigners(PREFIX, USER, SIGNED_MESSAGE));
        impl.setTimedSigner(0, SIGNER, 1);
        assertTrue(impl.checkTimedSigners(PREFIX, USER, SIGNED_MESSAGE));
        assertFalse(impl.checkTimedSigners(PREFIX, MOCK_USER, SIGNED_MESSAGE));
    }

    function testAddFutureAndCheck() public {
        uint256 future = block.timestamp + 100;
        impl.setTimedSigner(0, SIGNER, future);
        assertFalse(impl.checkTimedSigners(PREFIX, USER, SIGNED_MESSAGE));
        vm.warp(future);
        assertTrue(impl.checkTimedSigners(PREFIX, USER, SIGNED_MESSAGE));
    }

    function testMultiple() public {
        uint256 future1 = block.timestamp + 100;
        uint256 future2 = block.timestamp + 200;

        impl.setTimedSigner(0, SIGNER, future1);
        impl.setTimedSigner(1, SIGNER, future2);
        assertFalse(impl.checkTimedSigners(PREFIX, USER, SIGNED_MESSAGE));
        assertFalse(impl.checkTimedSigners(PREFIX, MOCK_USER, SIGNED_MESSAGE));

        vm.warp(future1);
        assertTrue(impl.checkTimedSigners(PREFIX, USER, SIGNED_MESSAGE));
        assertFalse(impl.checkTimedSigners(PREFIX, MOCK_USER, SIGNED_MESSAGE));

        impl.setTimedSigner(0, address(0), future1);
        assertFalse(impl.checkTimedSigners(PREFIX, USER, SIGNED_MESSAGE));

        vm.warp(future2);
        assertTrue(impl.checkTimedSigners(PREFIX, USER, SIGNED_MESSAGE));
        assertFalse(impl.checkTimedSigners(PREFIX, MOCK_USER, SIGNED_MESSAGE));
    }
}
