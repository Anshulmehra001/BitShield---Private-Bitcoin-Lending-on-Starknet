# BitShield - Hackathon Submission

## Project Information

**Name**: BitShield
**Tagline**: Private Bitcoin Lending on Starknet
**Tracks**: Privacy + Bitcoin

## Problem Statement

Current DeFi lending protocols expose all user financial data on-chain:
- Collateral amounts are public
- Loan sizes are visible to everyone
- Liquidation positions can be front-run
- No financial privacy for institutional or individual users

This creates:
- Privacy concerns for large holders
- MEV exploitation opportunities
- Competitive disadvantage for traders
- Regulatory compliance issues

## Solution

BitShield is a privacy-preserving Bitcoin lending protocol that uses Starknet's STARK proofs to enable:

1. **Private Deposits**: Users deposit BTC with encrypted amounts
2. **Confidential Borrowing**: Loan amounts hidden via ZK commitments
3. **Hidden Positions**: Collateral ratios computed privately
4. **Private Liquidations**: Undercollateralized positions liquidated without revealing amounts

## Technical Implementation

### Smart Contracts (Cairo)

1. **BitShieldVault**: Core lending logic with encrypted commitments
2. **PrivacyProver**: ZK proof generation and verification
3. **BTCBridge**: Wrapped BTC token for cross-chain deposits
4. **Liquidator**: Privacy-preserving liquidation mechanism

### Privacy Mechanism

- Uses Pedersen commitments: `commitment = Hash(amount, salt)`
- ZK proofs verify collateralization without revealing amounts
- Only commitment hashes stored on-chain
- Users maintain local proof of their positions

### Frontend

- React + TypeScript
- Starknet wallet integration (ArgentX, Braavos)
- Real-time encrypted position tracking
- Simple UX for complex cryptography

## Why This Wins

✅ **Dual Track**: Hits both Privacy and Bitcoin tracks perfectly
✅ **Real Utility**: Solves actual DeFi privacy problem
✅ **Technical Depth**: Showcases Starknet's ZK capabilities
✅ **Market Fit**: Institutional demand for private DeFi
✅ **Completeness**: Full stack implementation
✅ **Innovation**: First private lending protocol on Starknet

## Demo Flow

1. User connects Starknet wallet
2. Deposits BTC via bridge (testnet)
3. System generates ZK commitment
4. User borrows USDC privately
5. Dashboard shows encrypted positions
6. Repayment clears debt commitment

## Future Roadmap

- Multi-collateral support (ETH, STRK)
- Cross-chain privacy bridges
- Private credit scoring system
- Institutional custody integration
- Mainnet launch with audits

## Technical Highlights

- **Zero-Knowledge Proofs**: STARK-based privacy
- **Bitcoin Integration**: Native BTC collateral
- **Gas Efficient**: Optimized Cairo contracts
- **User Experience**: Complex crypto, simple UX
- **Composability**: Can integrate with other protocols

## Deployment

- **Testnet**: Starknet Sepolia


## Team

Solo developer submission for Re{define} Hackathon

## Repository

GitHub: https://github.com/Anshulmehra001/BitShield---Private-Bitcoin-Lending-on-Starknet


---

Built with ❤️ for Re{define} Hackathon
Privacy Track + Bitcoin Track
