// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/SingleReserveList.sol";

contract SingleReserveListTest is Test, SingleReserveList {
    bytes32 SAMPLE_ROOT_1 =
        0x078c4cd50969531f1be32b76c73cc6d998fe3407e0f0dcbb6c10c340994bd2c0;
    bytes32[] SAMPLE_PROOF_1;
    address SAMPLE_ADDR_1 = 0x0000000000000000000000000000000000000200;

    function setUp() public {
        SAMPLE_PROOF_1 = new bytes32[](2);
        SAMPLE_PROOF_1[
            0
        ] = 0xd3b5b90cebf74d639049264c331b8cfaadb9a1b2ec320816b39e30081310200a;
        SAMPLE_PROOF_1[
            1
        ] = 0x364632aeb6ffa6a08cafd55ed7a8a810eb4ac9455295558cc6a764605528d713;
    }

    function testSetup(
        bytes32 root,
        uint256 limit,
        uint256 walletLimit
    ) public {
        _reserveUpdate(root, limit, walletLimit);
        assertEq(_reserveMerkleRoot, root);
        assertEq(_reserveLimit, limit);
        assertEq(_reserveWalletLimit, walletLimit);
    }

    function testRevertOverLimit(uint256 limit) public {
        if (limit == type(uint256).max) {
            return;
        }
        _reserveUpdate(SAMPLE_ROOT_1, limit, limit);
        vm.expectRevert(abi.encodeWithSignature("ReserveLimitExceeded()"));
        _reserveRedeemMint(SAMPLE_ADDR_1, SAMPLE_PROOF_1, limit + 1);
    }

    function testRevertOverWalletLimit(uint256 walletLimit) public {
        if (walletLimit == type(uint256).max) {
            return;
        }
        _reserveUpdate(SAMPLE_ROOT_1, walletLimit + 1, walletLimit);
        vm.expectRevert(
            abi.encodeWithSignature("ReserveWalletLimitExceeded()")
        );
        _reserveRedeemMint(SAMPLE_ADDR_1, SAMPLE_PROOF_1, walletLimit + 1);
    }

    function testRevertUnauthorized(bytes32 root) public {
        if (root == SAMPLE_ROOT_1) {
            return;
        }
        _reserveUpdate(root, 10, 3);
        vm.expectRevert(abi.encodeWithSignature("ReserveMintUnauthorized()"));
        _reserveRedeemMint(SAMPLE_ADDR_1, SAMPLE_PROOF_1, 3);
    }

    function testSucceedWithinLimit() public {
        _reserveUpdate(SAMPLE_ROOT_1, 10, 3);
        _reserveRedeemMint(SAMPLE_ADDR_1, SAMPLE_PROOF_1, 3);
        assertEq(_reserveWalletMintCounts[SAMPLE_ADDR_1], 3);
        assertEq(_reserveMinted, 3);
    }
}
