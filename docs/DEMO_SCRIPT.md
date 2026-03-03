# BitShield Demo Script

## 3-Minute Video Demo Script

### Opening (0:00 - 0:30)

**Visual**: BitShield logo and tagline

**Narration**:
"Hi, I'm presenting BitShield - a privacy-preserving Bitcoin lending protocol built on Starknet. In traditional DeFi, everyone can see your collateral, your loans, and your liquidation risk. BitShield changes that using zero-knowledge proofs."

**Show**: Problem slide with public blockchain explorer showing loan data

---

### Problem Statement (0:30 - 0:50)

**Visual**: Split screen - public DeFi vs private DeFi

**Narration**:
"Current lending protocols expose all your financial data. Large holders can't maintain privacy. Traders get front-run. Institutions face compliance issues. We need privacy in DeFi."

**Show**: Examples of public loan data, MEV attacks

---

### Solution Overview (0:50 - 1:20)

**Visual**: Architecture diagram

**Narration**:
"BitShield solves this with three innovations:

First, encrypted commitments - your amounts are hashed before going on-chain.

Second, ZK proofs - you prove you're properly collateralized without revealing amounts.

Third, Bitcoin integration - deposit real BTC as collateral on Starknet."

**Show**: Commitment scheme diagram, ZK proof flow

---

### Live Demo (1:20 - 2:30)

**Visual**: Screen recording of frontend

**Narration**:
"Let me show you how it works.

[Connect wallet]
First, I connect my Starknet wallet.

[Deposit screen]
I deposit 0.5 BTC as collateral. Notice the amount gets encrypted - only I can see it.

[Dashboard]
My dashboard shows encrypted values. The protocol knows I'm collateralized, but not the exact amounts.

[Borrow screen]
Now I borrow 5,000 USDC. Again, this amount is private. A ZK proof verifies I have enough collateral.

[Stats]
The protocol shows aggregate stats - total TVL, number of loans - but individual positions stay private."

**Show**: 
- Wallet connection
- Deposit transaction
- Encrypted dashboard
- Borrow transaction
- Protocol stats

---

### Technical Highlights (2:30 - 2:50)

**Visual**: Code snippets and contract addresses

**Narration**:
"Under the hood, we're using Cairo smart contracts on Starknet, Pedersen commitments for privacy, and STARK proofs for verification. Everything is deployed on testnet and open source."

**Show**: 
- Cairo contract code
- Commitment generation
- Deployed addresses

---

### Closing (2:50 - 3:00)

**Visual**: BitShield logo with tracks

**Narration**:
"BitShield brings institutional-grade privacy to Bitcoin DeFi on Starknet. Check out our GitHub for the full implementation. Thanks for watching!"

**Show**:
- GitHub link
- Privacy + Bitcoin track badges
- Contact info

---

## Recording Tips

1. **Preparation**
   - Test all transactions on testnet first
   - Have wallet pre-funded
   - Clear browser cache for clean demo
   - Use screen recording software (OBS, Loom)

2. **Visuals**
   - Use high contrast for readability
   - Zoom in on important UI elements
   - Add arrows/highlights for key features
   - Include captions for accessibility

3. **Audio**
   - Use good microphone
   - Record in quiet environment
   - Speak clearly and at moderate pace
   - Add background music (low volume)

4. **Editing**
   - Cut dead time
   - Add transitions between sections
   - Include text overlays for key points
   - Export in 1080p minimum

5. **Upload**
   - YouTube (unlisted or public)
   - Include timestamps in description
   - Add relevant tags
   - Enable captions

## Demo Checklist

- [ ] Testnet wallet funded with ETH
- [ ] Test BTC tokens available
- [ ] Contracts deployed and verified
- [ ] Frontend deployed and accessible
- [ ] All transactions tested
- [ ] Screen recording software ready
- [ ] Script practiced
- [ ] Backup recording plan
- [ ] Video edited and reviewed
- [ ] Uploaded with proper metadata
