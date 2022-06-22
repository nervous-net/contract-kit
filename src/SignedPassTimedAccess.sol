// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "./SignedPass.sol";

contract SignedPassTimedAccess {
    using ECDSA for bytes32;

    event AddTimedSigner(uint256);
    event UpdateTimedSigner(uint256);

    struct TimedSigner {
        address signer;
        uint256 startTime;
    }

    TimedSigner[] internal _timedSigners;

    function _addTimedSigner(address signer, uint256 startTime) internal {
        _timedSigners.push(TimedSigner(signer, startTime));
        emit AddTimedSigner(_timedSigners.length - 1);
    }

    function _updateTimedSigner(
        uint256 index,
        address signer,
        uint256 startTime
    ) internal {
        require(index < _timedSigners.length, "Out of bounds");
        _timedSigners[index].signer = signer;
        _timedSigners[index].startTime = startTime;
        emit UpdateTimedSigner(index);
    }

    function _checkTimedSigners(
        string memory prefix,
        address addr,
        bytes memory signedMessage
    ) internal view returns (bool) {
        address signer = SignedPass.recoverSignerFromSignedPass(
            prefix,
            addr,
            signedMessage
        );
        for (uint256 i = 0; i < _timedSigners.length; i++) {
            TimedSigner storage a = _timedSigners[i];
            if (a.signer == signer && block.timestamp >= a.startTime) {
                return true;
            }
        }
        return false;
    }
}
