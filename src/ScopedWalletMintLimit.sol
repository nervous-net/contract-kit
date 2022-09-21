// SPDX-License-Identifier: MIT
pragma solidity >0.7.0;

abstract contract ScopedWalletMintLimit {
    struct ScopedLimit {
        uint256 limit;
        mapping(address => uint256) walletMints;
    }

    mapping(string => ScopedLimit) public scopedWalletMintLimits;

    function _setWalletMintLimit(string memory scope, uint256 _limit) internal {
        scopedWalletMintLimits[scope].limit = _limit;
    }

    function scopedWalletMintLimit(string memory scope)
        external
        view
        returns (uint256)
    {
        return scopedWalletMintLimits[scope].limit;
    }

    function _limitScopedWalletMints(
        string memory scope,
        address wallet,
        uint256 count
    ) internal {
        uint256 newCount = scopedWalletMintLimits[scope].walletMints[wallet] +
            count;
        require(
            newCount <= scopedWalletMintLimits[scope].limit,
            string.concat("Exceeds limit for ", scope)
        );
        scopedWalletMintLimits[scope].walletMints[wallet] = newCount;
    }

    modifier limitScopedWalletMints(
        string memory scope,
        address wallet,
        uint256 count
    ) {
        _limitScopedWalletMints(scope, wallet, count);
        _;
    }
}
