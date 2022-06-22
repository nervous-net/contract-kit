// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract MerkleTimedAccess {
    error AccessDenied();

    event AddMerkleAccessList(uint256 index);
    event UpdateMerkleAccessList(uint256 index);

    struct AccessList {
        bytes32 root;
        uint256 startTime;
    }

    AccessList[] internal _merkleAccessLists;

    function _addMerkleAccessList(bytes32 root, uint256 startTime) internal {
        _merkleAccessLists.push(AccessList(root, startTime));
        emit AddMerkleAccessList(_merkleAccessLists.length - 1);
    }

    function _updateMerkleAccessList(
        uint256 index,
        bytes32 root,
        uint256 startTime
    ) internal {
        require(index < _merkleAccessLists.length, "Out of bounds");
        _merkleAccessLists[index].root = root;
        _merkleAccessLists[index].startTime = startTime;
        emit UpdateMerkleAccessList(index);
    }

    function _checkMerkleAccessList(address addr, bytes32[] calldata proof)
        internal
        view
        returns (bool)
    {
        for (uint256 i = 0; i < _merkleAccessLists.length; i++) {
            AccessList storage a = _merkleAccessLists[i];
            if (
                block.timestamp >= a.startTime &&
                MerkleProof.verify(
                    proof,
                    a.root,
                    keccak256(abi.encodePacked(addr))
                )
            ) {
                return true;
            }
        }
        return false;
    }
}
