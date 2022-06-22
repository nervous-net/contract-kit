// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
pragma experimental ABIEncoderV2;

import "../../src/MultiTimedSignedPasses.sol";

contract MultiTimedSignedPassesImpl is MultiTimedSignedPasses {
    constructor(uint256 numSigners) MultiTimedSignedPasses(numSigners) {}

    function timedSigners(uint256 index)
        external
        view
        returns (TimedSigner memory)
    {
        return _timedSigners[index];
    }

    function setTimedSigner(
        uint256 index,
        address signer,
        uint256 startTime
    ) external {
        _setTimedSigner(index, signer, startTime);
    }

    function checkTimedSigners(
        string memory prefix,
        address addr,
        bytes memory signedMessage
    ) external view returns (bool) {
        return _checkTimedSigners(prefix, addr, signedMessage);
    }
}
