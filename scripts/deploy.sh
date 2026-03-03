#!/bin/bash

echo "🚀 Deploying BitShield to Starknet..."

# Build contracts
echo "📦 Building contracts..."
cd contracts
scarb build

# Deploy contracts (requires starkli or sncast)
echo "🔧 Deploying contracts..."

# Deploy Privacy Prover
echo "Deploying PrivacyProver..."
# starkli deploy target/dev/bitshield_PrivacyProver.contract_class.json

# Deploy BTC Bridge
echo "Deploying BTCBridge..."
# starkli deploy target/dev/bitshield_BTCBridge.contract_class.json --constructor-args <operator_address>

# Deploy BitShield Vault
echo "Deploying BitShieldVault..."
# starkli deploy target/dev/bitshield_BitShieldVault.contract_class.json --constructor-args <owner_address>

# Deploy Liquidator
echo "Deploying Liquidator..."
# starkli deploy target/dev/bitshield_Liquidator.contract_class.json --constructor-args <vault_address>

echo "✅ Deployment complete!"
echo "📝 Update frontend/src/config.ts with deployed addresses"
