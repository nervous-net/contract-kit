// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "./mocks/SignedPassTimedAccessImpl.sol";

contract SignedPassTimedAccessTest is Test {
    SignedPassTimedAccessImpl impl;

    address MOCK_USER = address(0xaa);
    string constant PREFIX = "NERVOUS";
    address USER = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
    bytes SIGNED_MESSAGE =
        hex"65714667e2687d1fd85f5f3ac45c732f3e356d8b8dbf5d8c01c9fa114b10271c5faecb08f89c276743eb350ca31817c9764f8d722e0807e23c3b72500265badd1b";
    address SIGNER = 0x1301044Ef935AE71a97fAd3cBa745846a4761B4c;

    function setUp() public {
        impl = new SignedPassTimedAccessImpl();
    }

    event AddTimedSigner(uint256 index);

    function testAddSigner() public {
        vm.expectEmit(true, true, false, false);
        emit AddTimedSigner(0);
        impl.addTimedSigner(address(0xab), 1);

        SignedPassTimedAccessImpl.TimedSigner memory t = impl.timedSigners(0);
        assertEq(t.signer, address(0xab));
        assertEq(t.startTime, 1);
    }

    event UpdateTimedSigner(uint256 index);

    function testUpdateSigner() public {
        impl.addTimedSigner(address(0xab), 1);
        vm.expectEmit(true, true, false, false);
        emit UpdateTimedSigner(0);
        impl.updateTimedSigner(0, address(0xac), 2);

        SignedPassTimedAccessImpl.TimedSigner memory t = impl.timedSigners(0);
        assertEq(t.signer, address(0xac));
        assertEq(t.startTime, 2);
    }

    function testAddAndCheck() public {
        impl.addTimedSigner(SIGNER, 1);
        assertTrue(impl.checkTimedSigners(PREFIX, USER, SIGNED_MESSAGE));
        assertFalse(impl.checkTimedSigners(PREFIX, MOCK_USER, SIGNED_MESSAGE));
    }

    function testAddFutureAndCheck() public {
        uint256 future = block.timestamp + 100;
        impl.addTimedSigner(SIGNER, future);
        assertFalse(impl.checkTimedSigners(PREFIX, USER, SIGNED_MESSAGE));
        vm.warp(future);
        assertTrue(impl.checkTimedSigners(PREFIX, USER, SIGNED_MESSAGE));
    }
}
