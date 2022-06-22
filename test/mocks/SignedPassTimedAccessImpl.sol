// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
pragma experimental ABIEncoderV2;

import "../../src/SignedPassTimedAccess.sol";

contract SignedPassTimedAccessImpl is SignedPassTimedAccess {
    constructor() {}

    function timedSigners(uint256 index)
        external
        view
        returns (TimedSigner memory)
    {
        return _timedSigners[index];
    }

    function addTimedSigner(address signer, uint256 startTime) external {
        _addTimedSigner(signer, startTime);
    }

    function updateTimedSigner(
        uint256 index,
        address signer,
        uint256 startTime
    ) external {
        _updateTimedSigner(index, signer, startTime);
    }

    function checkTimedSigners(
        string memory prefix,
        address addr,
        bytes memory signedMessage
    ) external view returns (bool) {
        return _checkTimedSigners(prefix, addr, signedMessage);
    }
}
