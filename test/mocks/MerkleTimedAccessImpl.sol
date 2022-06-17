// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../../src/MerkleTimedAccess.sol";

contract MerkleTimedAccessImpl is MerkleTimedAccess {
    constructor() {}

    function merkleAccessLists(uint256 index)
        external
        view
        returns (AccessList memory)
    {
        return _merkleAccessLists[index];
    }

    function addMerkleAccessList(bytes32 root, uint256 startTime) external {
        _addMerkleAccessList(root, startTime);
    }

    function updateMerkleAccessList(
        uint256 index,
        bytes32 root,
        uint256 startTime
    ) external {
        _updateMerkleAccessList(index, root, startTime);
    }

    function checkMerkleAccessList(address addr, bytes32[] calldata proof)
        external
        view
        returns (bool)
    {
        return _checkMerkleAccessList(addr, proof);
    }

    function useModifier(address addr, bytes32[] calldata proof)
        external
        view
        requireMerkleProof(addr, proof)
    {}
}
