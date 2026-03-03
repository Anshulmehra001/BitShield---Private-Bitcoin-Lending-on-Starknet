#!/bin/bash

echo "🚀 Deploying BitShield to Starknet Sepolia Testnet..."

# Configuration
NETWORK="sepolia"
RPC_URL="https://starknet-sepolia.public.blastapi.io/rpc/v0_7"

# Check if wallet is set up
if [ ! -f ~/.starkli-wallets/deployer.json ]; then
    echo "❌ Wallet not found. Run: starkli signer keystore new ~/.starkli-wallets/deployer.json"
    exit 1
fi

# Build contracts
echo "📦 Building contracts..."
cd contracts
scarb build

if [ $? -ne 0 ]; then
    echo "❌ Build failed"
    exit 1
fi

cd ..

# Get deployer address
echo "📝 Getting deployer address..."
DEPLOYER_ADDRESS=$(starkli signer keystore inspect ~/.starkli-wallets/deployer.json | grep "Public key" | awk '{print $3}')

echo "Deployer address: $DEPLOYER_ADDRESS"

# Deploy MockUSDC
echo ""
echo "1️⃣ Deploying MockUSDC..."
USDC_CLASS_HASH=$(starkli declare contracts/target/dev/bitshield_MockUSDC.contract_class.json \
    --rpc $RPC_URL \
    --account ~/.starkli-wallets/deployer.json \
    --keystore ~/.starkli-wallets/deployer.json 2>&1 | grep "Class hash declared" | awk '{print $4}')

if [ -z "$USDC_CLASS_HASH" ]; then
    echo "❌ MockUSDC declaration failed"
    exit 1
fi

USDC_ADDRESS=$(starkli deploy $USDC_CLASS_HASH \
    --rpc $RPC_URL \
    --account ~/.starkli-wallets/deployer.json \
    --keystore ~/.starkli-wallets/deployer.json 2>&1 | grep "Contract deployed" | awk '{print $3}')

echo "✅ MockUSDC deployed at: $USDC_ADDRESS"

# Deploy BTCBridge
echo ""
echo "2️⃣ Deploying BTCBridge..."
BRIDGE_CLASS_HASH=$(starkli declare contracts/target/dev/bitshield_BTCBridge.contract_class.json \
    --rpc $RPC_URL \
    --account ~/.starkli-wallets/deployer.json \
    --keystore ~/.starkli-wallets/deployer.json 2>&1 | grep "Class hash declared" | awk '{print $4}')

if [ -z "$BRIDGE_CLASS_HASH" ]; then
    echo "❌ BTCBridge declaration failed"
    exit 1
fi

BRIDGE_ADDRESS=$(starkli deploy $BRIDGE_CLASS_HASH $DEPLOYER_ADDRESS \
    --rpc $RPC_URL \
    --account ~/.starkli-wallets/deployer.json \
    --keystore ~/.starkli-wallets/deployer.json 2>&1 | grep "Contract deployed" | awk '{print $3}')

echo "✅ BTCBridge deployed at: $BRIDGE_ADDRESS"

# Deploy BitShieldVault
echo ""
echo "3️⃣ Deploying BitShieldVault..."
VAULT_CLASS_HASH=$(starkli declare contracts/target/dev/bitshield_BitShieldVault.contract_class.json \
    --rpc $RPC_URL \
    --account ~/.starkli-wallets/deployer.json \
    --keystore ~/.starkli-wallets/deployer.json 2>&1 | grep "Class hash declared" | awk '{print $4}')

if [ -z "$VAULT_CLASS_HASH" ]; then
    echo "❌ BitShieldVault declaration failed"
    exit 1
fi

VAULT_ADDRESS=$(starkli deploy $VAULT_CLASS_HASH $DEPLOYER_ADDRESS \
    --rpc $RPC_URL \
    --account ~/.starkli-wallets/deployer.json \
    --keystore ~/.starkli-wallets/deployer.json 2>&1 | grep "Contract deployed" | awk '{print $3}')

echo "✅ BitShieldVault deployed at: $VAULT_ADDRESS"

# Save addresses
echo ""
echo "💾 Saving deployment addresses..."
cat > deployment-addresses.json << EOF
{
  "network": "$NETWORK",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "contracts": {
    "MockUSDC": "$USDC_ADDRESS",
    "BTCBridge": "$BRIDGE_ADDRESS",
    "BitShieldVault": "$VAULT_ADDRESS"
  }
}
EOF

echo ""
echo "✅ Deployment complete!"
echo ""
echo "📋 Contract Addresses:"
echo "   MockUSDC:        $USDC_ADDRESS"
echo "   BTCBridge:       $BRIDGE_ADDRESS"
echo "   BitShieldVault:  $VAULT_ADDRESS"
echo ""
echo "📝 Next steps:"
echo "1. Update frontend/src/config.ts with these addresses"
echo "2. Mint test tokens: starkli invoke $USDC_ADDRESS mint <your_address> <amount>"
echo "3. Run frontend: cd frontend && npm run dev"
echo ""
echo "🔗 View on Starkscan:"
echo "   https://sepolia.starkscan.co/contract/$VAULT_ADDRESS"
