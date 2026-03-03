# BitShield Solidity Contracts

Solidity implementation of BitShield for Arbitrum Sepolia deployment.

## Setup

```bash
npm install
```

## Configuration

1. Copy `.env.example` to `.env`
2. Add your private key (without 0x prefix)
3. Get testnet ETH from faucet

## Get Testnet ETH

Visit any of these faucets:
- https://faucets.chain.link/arbitrum-sepolia
- https://www.alchemy.com/faucets/arbitrum-sepolia

## Deploy

```bash
npm run deploy
```

## Contracts

- **BitShieldVault.sol** - Main lending vault
- **BTCBridge.sol** - Bitcoin bridge (WBTC)
- **MockUSDC.sol** - Test USDC token

## Network

- Chain: Arbitrum Sepolia
- Chain ID: 421614
- RPC: https://sepolia-rollup.arbitrum.io/rpc
- Explorer: https://sepolia.arbiscan.io/
