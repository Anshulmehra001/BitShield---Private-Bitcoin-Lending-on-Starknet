# BitShield - Private Bitcoin Lending on Starknet

A privacy-preserving Bitcoin lending protocol built on Starknet that enables users to deposit BTC as collateral and borrow stablecoins without revealing their identity, loan amounts, or collateral values.

## 🎯 Hackathon Tracks

- ✅ **Privacy Track**: ZK proofs for confidential lending
- ✅ **Bitcoin Track**: BTC-native DeFi on Starknet

## 🚀 Features

- **Private Deposits**: Bridge BTC to Starknet with encrypted balances
- **Confidential Borrowing**: Borrow against BTC collateral using ZK proofs
- **Hidden Positions**: Loan amounts and collateral values remain private
- **Automated Liquidations**: Privacy-preserving liquidation mechanism
- **On-chain Credit Score**: Build reputation without revealing history

## 🏗️ Architecture

```
┌─────────────┐      ┌──────────────┐      ┌─────────────┐
│   Bitcoin   │─────▶│   Bridge/    │─────▶│  Starknet   │
│   Network   │      │ Atomic Swap  │      │   L2        │
└─────────────┘      └──────────────┘      └─────────────┘
                                                   │
                                                   ▼
                                          ┌─────────────────┐
                                          │  BitShield      │
                                          │  Smart Contract │
                                          │  (Cairo)        │
                                          └─────────────────┘
                                                   │
                                                   ▼
                                          ┌─────────────────┐
                                          │  ZK Proof       │
                                          │  Verification   │
                                          └─────────────────┘
```

## 📦 Tech Stack

- **Smart Contracts**: Cairo 2.x
- **Frontend**: React + TypeScript + Vite
- **Wallet Integration**: Starknet.js + get-starknet
- **Styling**: TailwindCSS
- **ZK Proofs**: Starknet's native STARK proofs

## 🛠️ Project Structure

```
bitshield/
├── contracts/          # Cairo smart contracts
├── frontend/          # React application
├── scripts/           # Deployment scripts
└── docs/             # Documentation
```

## 🚦 Getting Started

### Prerequisites

- Node.js 18+
- Scarb (Cairo package manager)
- Starknet wallet (ArgentX or Braavos)

### Installation

```bash
# Install dependencies
npm install

# Build contracts
cd contracts && scarb build

# Run frontend
cd frontend && npm run dev
```

## 📝 Smart Contract Overview

### Core Contracts

1. **BitShieldVault.cairo** - Main lending vault
2. **PrivacyProver.cairo** - ZK proof verification
3. **BTCBridge.cairo** - Bitcoin bridge interface
4. **Liquidator.cairo** - Private liquidation logic

## 🎬 Demo Flow

1. Connect Starknet wallet
2. Deposit BTC (testnet) via bridge
3. Generate ZK proof of collateral
4. Borrow USDC privately
5. View encrypted position dashboard
6. Repay loan with privacy preserved

## 🏆 Hackathon Submission

- **Track**: Privacy + Bitcoin
- **Demo Video**: [Link TBD]
- **Live Demo**: [Link TBD]
- **Testnet Deployment**: [Address TBD]

## 📄 License

MIT

## 🤝 Team

Built for Re{define} Hackathon 2025
