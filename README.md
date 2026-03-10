# Verification Proof: Augur REP Crowdsale

**Contract:** [`0xe28e72fcf78647adce1f1252f240bbfaebd63bcc`](https://etherscan.io/address/0xe28e72fcf78647adce1f1252f240bbfaebd63bcc)
**Block:** 88,090 (August 15, 2015)
**Deployer:** `0x1c11aa45c792e202e9ffdc2f12f99d0d209bef70`
**Creation tx:** `0x68113bfbab5de60bca362a887d46b7dfe461b71b640fb9315ce1f297abffa57a`

## What is this?

The ETH-side crowdsale contract for Augur's REP token sale in August 2015 — one of the earliest and largest Ethereum token sales. Augur raised approximately 2,000 ETH in this sale, which funded development of the first decentralized prediction market protocol.

Contributors sent ETH to this contract via `buyRep()`. The contract forwarded funds to the Augur multisig wallet (`0xa04fc9bd2be8bcc6875d9ebb964e8f858bcc1b4f`) and recorded each contributor's address, amount, and block number. Contributions were accepted until block 432,015.

This contract predates Etherscan's automated verification tooling and was compiled with a version of Serpent that is no longer maintained.

## Source Code

See `AugurCrowdsale.se`.

## Compiler

**Language:** Serpent  
**Repo:** [ethereum/serpent](https://github.com/ethereum/serpent)  
**Commit:** `6ace8a6` (August 2015)  
**Optimizer:** N/A (Serpent does not have a separate optimizer flag)

## Verification

The compiled runtime bytecode matches the on-chain runtime exactly: **856 bytes**.

Key source details that affect bytecode:
- `buyRep()` uses `if/else` on the `block.number < endBlock` check (not a trailing return). This generates a `PUSH2+JUMP` trampoline between branches.
- `getAmountSent()` uses `address == self.funders[i].addr` (parameter on left side of `==`). Serpent evaluates the left operand first; reversing the order changes the bytecode.
- The Serpent `(lll code 0)` wrapper appends 4 bytes of init-code epilogue (`JUMPDEST PUSH1(0) RETURN`) after the runtime in the creation bytecode. These bytes are **not** deployed — the `CODECOPY` in the init section explicitly copies only 856 bytes.

## Running Verification

```bash
# Requires Docker (for x86 Serpent build) and Node.js
bash verify.sh
```

Or manually with Node.js:

```bash
node verify.js
```
