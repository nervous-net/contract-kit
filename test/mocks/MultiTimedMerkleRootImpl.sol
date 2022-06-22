// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
pragma experimental ABIEncoderV2;

import "../../src/MultiTimedMerkleRoot.sol";

contract MultiTimedMerkleRootImpl is MultiTimedMerkleRoot {
    constructor(uint256 numLists) MultiTimedMerkleRoot(numLists) {}

    function timedMerkleRoots(uint256 index)
        external
        view
        returns (TimedRoot memory)
    {
        return _timedMerkleRoots[index];
    }

    function setTimedMerkleRoot(
        uint256 index,
        bytes32 root,
        uint256 startTime
    ) external {
        _setTimedMerkleRoot(index, root, startTime);
    }

    function checkTimedMerkleRoots(address addr, bytes32[] calldata proof)
        external
        view
        returns (bool)
    {
        return _checkTimedMerkleRoots(addr, proof);
    }
}
