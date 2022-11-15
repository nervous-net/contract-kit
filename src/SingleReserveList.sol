// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

error ReserveLimitExceeded();
error ReserveWalletLimitExceeded();
error ReserveMintUnauthorized();

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

abstract contract SingleReserveList {
    mapping(address => uint256) internal _reserveWalletMintCounts;
    bytes32 internal _reserveMerkleRoot;
    uint256 internal _reserveLimit;
    uint256 internal _reserveWalletLimit;
    uint256 internal _reserveMinted;

    function _reserveUpdate(
        bytes32 merkleRoot,
        uint256 limit,
        uint256 walletLimit
    ) internal {
        _reserveMerkleRoot = merkleRoot;
        _reserveLimit = limit;
        _reserveWalletLimit = walletLimit;
    }

    function _reserveRedeemMint(
        address addr,
        bytes32[] memory proof,
        uint256 amount
    ) internal {
        if (_reserveMinted + amount > _reserveLimit) {
            revert ReserveLimitExceeded();
        }

        if (_reserveWalletMintCounts[addr] + amount > _reserveWalletLimit) {
            revert ReserveWalletLimitExceeded();
        }

        if (
            !MerkleProof.verify(
                proof,
                _reserveMerkleRoot,
                keccak256(abi.encodePacked(addr))
            )
        ) {
            revert ReserveMintUnauthorized();
        }
        _reserveWalletMintCounts[addr] += amount;
        _reserveMinted += amount;
    }
}
