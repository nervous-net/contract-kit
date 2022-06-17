// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../../src/WalletMintLimit.sol";

contract WalletMintLimitImpl is WalletMintLimit {
    constructor() {}

    function setLimit(uint256 limit) public {
        _setWalletMintLimit(limit);
    }

    function walletMintLimit() external returns (uint256) {
        return _walletMintLimit;
    }

    function mockMint(address wallet, uint256 num)
        public
        limitWalletMints(wallet, num)
    {}
}
