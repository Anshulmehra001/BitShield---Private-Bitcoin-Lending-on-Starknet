# Deploy BitShield to Arbitrum Sepolia

## Step 1: Get Testnet ETH

Visit one of these faucets to get free testnet ETH:
- **Chainlink Faucet**: https://faucets.chain.link/arbitrum-sepolia
- **Alchemy Faucet**: https://www.alchemy.com/faucets/arbitrum-sepolia

You'll need about 0.01 ETH for deployment.

## Step 2: Setup Environment

1. Copy the example env file:
```bash
copy .env.example .env
```

2. Open `.env` and add your private key (without 0x prefix):
```
PRIVATE_KEY=your_private_key_here
```

To get your private key from MetaMask:
- Open MetaMask
- Click the 3 dots menu
- Account Details → Show Private Key
- Enter password and copy (remove the 0x prefix)

## Step 3: Deploy Contracts

```bash
npm run deploy
```

This will deploy all 3 contracts:
- MockUSDC (test stablecoin)
- BTCBridge (wrapped BTC)
- BitShieldVault (main lending contract)

## Step 4: Save Contract Addresses

After deployment, you'll see output like:
```
MockUSDC: 0x...
BTCBridge: 0x...
BitShieldVault: 0x...
```

Save these addresses! You'll need them to update the frontend.

## Step 5: Verify on Arbiscan

Visit the Arbiscan links shown in the deployment output to see your contracts live on the blockchain:
```
https://sepolia.arbiscan.io/address/YOUR_CONTRACT_ADDRESS
```

## Troubleshooting

**Error: insufficient funds**
- Get more testnet ETH from the faucets above

**Error: nonce too high**
- Reset your MetaMask account: Settings → Advanced → Clear Activity Tab Data

**Error: PRIVATE_KEY not found**
- Make sure you created the `.env` file and added your private key

## Network Details

- **Network**: Arbitrum Sepolia
- **Chain ID**: 421614
- **RPC URL**: https://sepolia-rollup.arbitrum.io/rpc
- **Explorer**: https://sepolia.arbiscan.io/
- **Faucets**: 
  - https://faucets.chain.link/arbitrum-sepolia
  - https://www.alchemy.com/faucets/arbitrum-sepolia
