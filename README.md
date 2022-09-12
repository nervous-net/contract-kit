# Nervous Contract Kit

This is a set of tested utilities for commmon NFT contract patterns.

## Overview

### Wrappy

Library for a single global unwrap then optional wrapping/rewrapping

### WalletMintLimit

Keep track of and limit mints for a given address

### MultiTimedSignedPasses

Create and manage timed access lists using signed passes

### SignedPass

Library for verifying that an address matches the one signed in a pass.

### MultiTimedMerkleRoot

Create and manage timed access lists using merkle trees and proofs

### MerkleUtil

Thin convenience library function for verifying an address with a root and proof.

## Install

Via forge:

```
forge install nervous-net/contract-kit
```

Via yarn etc:

```
yarn add github:nervous-net/contract-kit
```

## Development

Test

```
forge test
```
