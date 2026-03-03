#!/bin/bash

echo "🔧 Setting up BitShield development environment..."

# Check if scarb is installed
if ! command -v scarb &> /dev/null; then
    echo "❌ Scarb not found. Installing..."
    curl --proto '=https' --tlsv1.2 -sSf https://docs.swmansion.com/scarb/install.sh | sh
fi

# Check if starkli is installed
if ! command -v starkli &> /dev/null; then
    echo "❌ Starkli not found. Installing..."
    curl https://get.starkli.sh | sh
    starkliup
fi

echo "📦 Building contracts..."
cd contracts
scarb build

if [ $? -eq 0 ]; then
    echo "✅ Contracts built successfully!"
else
    echo "❌ Contract build failed"
    exit 1
fi

cd ..

echo "📦 Installing frontend dependencies..."
cd frontend
npm install

if [ $? -eq 0 ]; then
    echo "✅ Frontend dependencies installed!"
else
    echo "❌ Frontend installation failed"
    exit 1
fi

cd ..

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Get testnet ETH from: https://starknet-faucet.vercel.app/"
echo "2. Create a wallet: starkli signer keystore new ~/.starkli-wallets/deployer.json"
echo "3. Deploy contracts: ./scripts/deploy-testnet.sh"
echo "4. Update frontend/src/config.ts with deployed addresses"
echo "5. Run frontend: cd frontend && npm run dev"
