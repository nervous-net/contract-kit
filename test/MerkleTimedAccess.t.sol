// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "./mocks/MerkleTimedAccessImpl.sol";

contract WrappableTest is Test {
    MerkleTimedAccessImpl impl;
    bytes32 MOCK_ROOT = bytes32(bytes("hello"));

    bytes32 SAMPLE_ROOT_1 =
        0x078c4cd50969531f1be32b76c73cc6d998fe3407e0f0dcbb6c10c340994bd2c0;
    bytes32[] SAMPLE_PROOF_1;
    address SAMPLE_ADDR_1 = 0x0000000000000000000000000000000000000200;

    bytes32 SAMPLE_ROOT_2 =
        0xec03645aab28382123db2ede9045137c20d12c516d96ea0ccd25478e90c5de43;
    bytes32[] SAMPLE_PROOF_2;
    address SAMPLE_ADDR_2 = 0x1234123412341234123412341234123412341234;

    function setUp() public {
        SAMPLE_PROOF_1 = new bytes32[](2);
        SAMPLE_PROOF_1[
            0
        ] = 0xd3b5b90cebf74d639049264c331b8cfaadb9a1b2ec320816b39e30081310200a;
        SAMPLE_PROOF_1[
            1
        ] = 0x364632aeb6ffa6a08cafd55ed7a8a810eb4ac9455295558cc6a764605528d713;

        SAMPLE_PROOF_2 = new bytes32[](3);
        SAMPLE_PROOF_2[
            0
        ] = 0xaef7ee2d453c6169bbf4b613aa1ec64a89bab8247e7795fe09dd8a615623fa26;
        SAMPLE_PROOF_2[
            1
        ] = 0x7e1a10033cdfb92649ae62a8591ae96b6cb65cb90911f66b024de2b589605bcb;
        SAMPLE_PROOF_2[
            2
        ] = 0x19ab5000d741e94ab1dee2000f9ae27a768293f3ef786dcab3477ff4288e0917;

        impl = new MerkleTimedAccessImpl();
    }

    event AddMerkleAccessList(uint256 index);

    function testAdd() public {
        vm.expectEmit(false, false, false, true);
        emit AddMerkleAccessList(0);
        impl.addMerkleAccessList(MOCK_ROOT, 0);
    }

    function testFailUpdate() public {
        impl.updateMerkleAccessList(0, MOCK_ROOT, 0);
    }

    function testRevertUpdate() public {
        vm.expectRevert("Out of bounds");
        impl.updateMerkleAccessList(0, MOCK_ROOT, 0);
    }

    event UpdateMerkleAccessList(uint256 index);

    function testAddAndUpdateList() public {
        impl.addMerkleAccessList(MOCK_ROOT, 0);
        vm.expectEmit(false, false, false, true);
        emit UpdateMerkleAccessList(0);
        impl.updateMerkleAccessList(0, MOCK_ROOT, 1);
        assertEq(impl.merkleAccessLists(0).startTime, 1);
    }

    function testAddAndVerify() public {
        impl.addMerkleAccessList(SAMPLE_ROOT_1, 0);
        assertTrue(impl.checkMerkleAccessList(SAMPLE_ADDR_1, SAMPLE_PROOF_1));
    }

    function testAddAndVerify2() public {
        impl.addMerkleAccessList(SAMPLE_ROOT_2, 0);
        assertTrue(impl.checkMerkleAccessList(SAMPLE_ADDR_2, SAMPLE_PROOF_2));
    }

    function testFalseVerify() public {
        assertFalse(impl.checkMerkleAccessList(SAMPLE_ADDR_1, SAMPLE_PROOF_1));
    }

    function testAddFutureFailedVerify() public {
        impl.addMerkleAccessList(SAMPLE_ROOT_1, uint32(block.timestamp) + 10);
        assertFalse(impl.checkMerkleAccessList(SAMPLE_ADDR_1, SAMPLE_PROOF_1));
    }

    function testFuture() public {
        uint32 futureTimestamp = uint32(block.timestamp) + 100;
        impl.addMerkleAccessList(SAMPLE_ROOT_1, futureTimestamp);
        assertFalse(impl.checkMerkleAccessList(SAMPLE_ADDR_1, SAMPLE_PROOF_1));
        vm.warp(futureTimestamp + 10);
        assertTrue(impl.checkMerkleAccessList(SAMPLE_ADDR_1, SAMPLE_PROOF_1));
    }

    function testMultipleListsOverTime() public {
        uint256 accessListTime1 = block.timestamp + 100;
        uint256 accessListTime2 = block.timestamp + 120;

        impl.addMerkleAccessList(SAMPLE_ROOT_1, accessListTime1);
        impl.addMerkleAccessList(SAMPLE_ROOT_2, accessListTime2);

        assertFalse(impl.checkMerkleAccessList(SAMPLE_ADDR_1, SAMPLE_PROOF_1));
        assertFalse(impl.checkMerkleAccessList(SAMPLE_ADDR_2, SAMPLE_PROOF_2));

        vm.warp(accessListTime1);
        assertTrue(impl.checkMerkleAccessList(SAMPLE_ADDR_1, SAMPLE_PROOF_1));
        assertFalse(impl.checkMerkleAccessList(SAMPLE_ADDR_2, SAMPLE_PROOF_2));

        vm.warp(accessListTime2);
        assertTrue(impl.checkMerkleAccessList(SAMPLE_ADDR_1, SAMPLE_PROOF_1));
        assertTrue(impl.checkMerkleAccessList(SAMPLE_ADDR_2, SAMPLE_PROOF_2));
    }
}
