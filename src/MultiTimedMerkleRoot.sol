// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "./MerkleUtil.sol";

contract MultiTimedMerkleRoot {
    struct TimedRoot {
        bytes32 root;
        uint256 startTime;
    }

    TimedRoot[] internal _timedMerkleRoots;

    constructor(uint256 numRoots) {
        for (uint256 i = 0; i < numRoots; i++) {
            _timedMerkleRoots.push(TimedRoot(0, type(uint256).max));
        }
    }

    function _setTimedMerkleRoot(
        uint256 index,
        bytes32 root,
        uint256 startTime
    ) internal {
        require(index < _timedMerkleRoots.length, "Out of bounds");
        _timedMerkleRoots[index].root = root;
        _timedMerkleRoots[index].startTime = startTime;
    }

    function _checkTimedMerkleRoots(address addr, bytes32[] calldata proof)
        internal
        view
        returns (bool)
    {
        for (uint256 i = 0; i < _timedMerkleRoots.length; i++) {
            TimedRoot storage a = _timedMerkleRoots[i];
            if (
                block.timestamp >= a.startTime &&
                MerkleUtil.verifyAddressProof(addr, a.root, proof)
            ) {
                return true;
            }
        }
        return false;
    }
}
