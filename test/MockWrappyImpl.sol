// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../src/Wrappy.sol";

contract MockWrappyImpl is Wrappy {
    constructor() {}

    function wrapped(uint256 tokenId) public view returns (bool) {
        return _wrapped(tokenId);
    }

    function unwrapAll() public {
        _unwrapAll();
    }

    function setWrapped(uint256 tokenId, bool state) public {
        _setWrapped(tokenId, state);
    }
}
