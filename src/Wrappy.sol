// SPDX-License-Identifier: MIT
pragma solidity >0.8.0;

abstract contract Wrappy {
    error WrapUnwrapNotEnabled();

    mapping(uint256 => bool) private _isWrapped;
    bool private _unwrapped;

    constructor() {}

    function _wrapped(uint256 tokenId) internal view returns (bool) {
        if (_unwrapped) {
            return _isWrapped[tokenId];
        } else {
            return true;
        }
    }

    function _unwrapAll() internal {
        _unwrapped = true;
    }

    function _setWrapped(uint256 tokenId, bool state) internal {
        if (!_unwrapped) {
            revert WrapUnwrapNotEnabled();
        } else {
            _isWrapped[tokenId] = state;
        }
    }
}
