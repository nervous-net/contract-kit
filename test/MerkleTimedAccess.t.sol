// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "./mocks/MerkleTimedAccessImpl.sol";

contract WrappableTest is Test {
    MerkleTimedAccessImpl impl;
    bytes32 MOCK_ROOT = bytes32(bytes("hello"));

    bytes32 SAMPLE_ROOT =
        0x078c4cd50969531f1be32b76c73cc6d998fe3407e0f0dcbb6c10c340994bd2c0;
    bytes32[] SAMPLE_PROOF;
    address SAMPLE_ADDR = 0x0000000000000000000000000000000000000200;

    function setUp() public {
        SAMPLE_PROOF = new bytes32[](2);
        SAMPLE_PROOF[
            0
        ] = 0xd3b5b90cebf74d639049264c331b8cfaadb9a1b2ec320816b39e30081310200a;
        SAMPLE_PROOF[
            1
        ] = 0x364632aeb6ffa6a08cafd55ed7a8a810eb4ac9455295558cc6a764605528d713;

        impl = new MerkleTimedAccessImpl();
    }

    function testAddList() public {
        impl.addMerkleAccessList(MOCK_ROOT, 0);
    }

    function testFailUpdate() public {
        impl.updateMerkleAccessList(0, MOCK_ROOT, 0);
    }

    function testRevertUpdate() public {
        vm.expectRevert("Out of bounds");
        impl.updateMerkleAccessList(0, MOCK_ROOT, 0);
    }

    function testAddAndUpdateList() public {
        impl.addMerkleAccessList(MOCK_ROOT, 0);
        impl.updateMerkleAccessList(0, MOCK_ROOT, 1);
        assertEq(impl.merkleAccessLists(0).startTime, 1);
    }

    function testAddAndVerify() public {
        impl.addMerkleAccessList(SAMPLE_ROOT, 0);
        assertTrue(impl.checkMerkleAccessList(SAMPLE_ADDR, SAMPLE_PROOF));
    }

    function testAddAndVerifyWithModifier() public {
        impl.addMerkleAccessList(SAMPLE_ROOT, 0);
        impl.useModifier(SAMPLE_ADDR, SAMPLE_PROOF);
    }

    function testFalseVerify() public {
        assertFalse(impl.checkMerkleAccessList(SAMPLE_ADDR, SAMPLE_PROOF));
    }

    function testFalseVerifyWithModifier() public {
        vm.expectRevert(abi.encodeWithSignature("AccessDenied()"));
        impl.useModifier(SAMPLE_ADDR, SAMPLE_PROOF);
    }

    function testAddFutureFailedVerify() public {
        impl.addMerkleAccessList(SAMPLE_ROOT, uint32(block.timestamp) + 10);
        assertFalse(impl.checkMerkleAccessList(SAMPLE_ADDR, SAMPLE_PROOF));
    }

    function testFuture() public {
        uint32 futureTimestamp = uint32(block.timestamp) + 100;
        impl.addMerkleAccessList(SAMPLE_ROOT, futureTimestamp);
        assertFalse(impl.checkMerkleAccessList(SAMPLE_ADDR, SAMPLE_PROOF));
        vm.warp(futureTimestamp + 10);
        assertTrue(impl.checkMerkleAccessList(SAMPLE_ADDR, SAMPLE_PROOF));
    }
}
