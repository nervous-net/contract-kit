// SPDX-License-Identifier: MIT
pragma solidity >0.7.0;

abstract contract WalletMintLimit {
    error ExceedsWalletMintLimit();

    mapping(address => uint256) public walletMints;
    uint256 public walletMintLimit;

    function _setWalletMintLimit(uint256 _limit) internal {
        walletMintLimit = _limit;
    }

    function _limitWalletMints(address wallet, uint256 count) internal {
        uint256 currentCount = walletMints[wallet];
        uint256 newCount = currentCount + count;
        if (newCount > walletMintLimit) {
            revert ExceedsWalletMintLimit();
        } else {
            walletMints[wallet] = newCount;
        }
    }

    modifier limitWalletMints(address wallet, uint256 count) {
        _limitWalletMints(wallet, count);
        _;
    }
}
