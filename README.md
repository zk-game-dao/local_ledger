# IC Ledger Canister Development Environment

A development environment for quickly deploying local Internet Computer (IC) ledger canisters, including ICP and various ICRC-1 tokens.

## Overview

This project provides a streamlined way to set up and deploy various token ledger canisters in your local Internet Computer development environment. It includes:

- ICP ledger (LICP for local testing)
- Chain Key USD (CKUSDC)
- Chain Key USDT (CKUSDT)
- Chain Key ETH (CKETH)
- DecideAI Token (DCD)

Each canister is configured with the appropriate decimals, transfer fees, and other parameters to match their mainnet counterparts, making local development and testing more realistic.

## Quick Start

### Prerequisites

- [DFX SDK](https://internetcomputer.org/docs/current/developer-docs/setup/install) (Internet Computer developer tools)
- Basic understanding of Internet Computer architecture and token models

### Deployment

The included `ez-deploy.sh` script makes it easy to deploy all canisters and distribute tokens to test accounts:

```bash
./ez-deploy.sh --principals principalA principalB principalC --account-ids accountA accountB accountC
```

This will:
1. Deploy all ledger canisters with their predefined canister IDs
2. Mint and distribute 1,000,000,000,000 tokens of each type to the specified principals and accounts
3. Configure the minter account with sufficient tokens
4. Set up the DecideAI DAO with its own token allocation

### Canister IDs

The following canister IDs are pre-configured in the project:

| Token | Canister ID | Local Name |
|-------|------------|------------|
| ICP | ryjl3-tyaaa-aaaaa-aaaba-cai | LICP (Local ICP) |
| CKUSDC | xevnm-gaaaa-aaaar-qafnq-cai | LCKUSDC |
| CKUSDT | cngnf-vqaaa-aaaar-qag4q-cai | LCKUSDT |
| CKETH | ss2fx-dyaaa-aaaar-qacoq-cai | LCKETH |
| DCD | xsi2v-cyaaa-aaaaq-aabfq-cai | DCD (DecideAI Token) |

## Token Specifications

- **LICP**: 8 decimals with a transfer fee of 10,000 e8s
- **LCKUSDC**: 6 decimals with a transfer fee of 10,000
- **LCKUSDT**: 6 decimals with a transfer fee of 10,000
- **LCKETH**: 18 decimals with a transfer fee of 10,000
- **DCD**: 8 decimals with a transfer fee of 10,000

## Advanced Usage

### Minting Additional Tokens

The default minter identity is set up during deployment. To mint additional tokens:

```bash
# Switch to minter identity
dfx identity use minter

# Mint tokens (example for ICP)
dfx ledger transfer --ledger-canister-id ryjl3-tyaaa-aaaaa-aaaba-cai --amount 1000000000 <destination-account-id>
```

### Working with Different Tokens

You can interact with any of the deployed token ledgers using standard ICRC-1 methods or ICP ledger methods as appropriate:

```bash
# Check ICP balance
dfx ledger --ledger-canister-id ryjl3-tyaaa-aaaaa-aaaba-cai balance <account-id>

# Check ICRC-1 token balance (example for CKUSDC)
dfx ledger --ledger-canister-id xevnm-gaaaa-aaaar-qafnq-cai icrc1_balance_of '(record { owner = principal "<principal-id>"; subaccount = null })'
```

## Development

### Project Structure

- `dfx.json`: Configuration file for the Internet Computer developer tools
- `ez-deploy.sh`: Helper script for easily deploying all canisters with test tokens

### Modifying Token Parameters

If you need to modify token parameters (such as fees, decimals, etc.), edit the corresponding sections in the `ez-deploy.sh` script.

## Troubleshooting

### Common Issues

**Error: The replica returned an error: Entity already exists**
- The specified canister ID is already in use. Clear your local state with `dfx stop && dfx start --clean`

**Error: Ledger transfer failed**
- Check that you have sufficient token balance and that the transfer fee is accounted for

### Logs

To view canister logs for debugging:

```bash
dfx canister call <canister-id> icrc1_name
```

## Additional Resources

- [ICRC-1 Token Standard](https://github.com/dfinity/ICRC-1)
- [Internet Computer Documentation](https://internetcomputer.org/docs)
- [DFX SDK Documentation](https://internetcomputer.org/docs/current/developer-docs/setup/install)
