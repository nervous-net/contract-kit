# Nervous Contract Kit

This is a set of tested utilities for commmon NFT contract patterns.

## Install

Via forge:

```
forge install nervous-net/contract-kit
```

Via yarn etc:

```
yarn add github:nervous-net/contract-kit
```

## Overview

### Wrappy

Library for a single global unwrap then optional wrapping/rewrapping

### WalletMintLimit

Keep track of and limit mints for a given address

### MultiTimedSignedPasses

Create and manage timed access lists using signed passes

### MultiTimedMerkleRoot

Create and manage timed access lists using merkle trees and proofs

### MerkleUtil

Thin convenience library function for verifying an address with a root and proof.
