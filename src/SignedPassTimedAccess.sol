// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

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
        address signer = _recoverSignerFromSignedPass(
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

    function _recoverSignerFromSignedPass(
        string memory prefix,
        address addr,
        bytes memory signedMessage
    ) private pure returns (address) {
        bytes32 message = _getHash(prefix, addr);
        return _recover(message, signedMessage);
    }

    function _getHash(string memory prefix, address addr)
        private
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(prefix, addr));
    }

    function _recover(bytes32 hash, bytes memory signedMessage)
        private
        pure
        returns (address)
    {
        return hash.toEthSignedMessageHash().recover(signedMessage);
    }
}
