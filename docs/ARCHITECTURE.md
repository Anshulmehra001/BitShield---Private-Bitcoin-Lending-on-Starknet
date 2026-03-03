# BitShield Architecture

## System Overview

BitShield implements privacy-preserving lending using commitment schemes and zero-knowledge proofs on Starknet.

## Core Components

### 1. Privacy Layer

**Commitment Scheme**
```
commitment = Pedersen(amount, salt)
```

Users generate commitments locally and submit only the hash to the contract. The actual amount remains private.

**ZK Proofs**
- Range proofs: Prove amount is within valid range
- Collateral proofs: Prove collateral >= debt * ratio
- Equality proofs: Prove commitment matches claimed amount

### 2. Smart Contracts

**BitShieldVault**
- Stores encrypted commitments
- Verifies ZK proofs
- Manages lending logic
- Emits private events

**PrivacyProver**
- Generates commitments
- Verifies range proofs
- Validates collateral ratios
- Checks equality proofs

**BTCBridge**
- Wraps Bitcoin as ERC20
- Handles deposits/withdrawals
- Tracks total supply
- Manages bridge operator

**Liquidator**
- Monitors positions privately
- Executes liquidations with proofs
- Distributes liquidation bonuses
- Maintains protocol health

### 3. Privacy Guarantees

**What's Private:**
- Individual collateral amounts
- Individual debt amounts
- Loan-to-value ratios
- Liquidation thresholds per user

**What's Public:**
- Protocol TVL (aggregate)
- Number of active loans
- Global collateral ratio
- Liquidation events (not amounts)

## Data Flow

### Deposit Flow
```
1. User: Generate commitment = Hash(amount, salt)
2. User: Create ZK proof of valid amount
3. User: Submit commitment + proof to contract
4. Contract: Verify proof
5. Contract: Store commitment
6. Contract: Emit PrivateDeposit event
```

### Borrow Flow
```
1. User: Generate debt commitment
2. User: Create proof that collateral >= debt * 1.5
3. User: Submit debt commitment + proof
4. Contract: Verify collateral proof
5. Contract: Store debt commitment
6. Contract: Transfer borrowed funds
7. Contract: Emit PrivateBorrow event
```

### Liquidation Flow
```
1. Liquidator: Monitor commitments
2. Liquidator: Generate proof of undercollateralization
3. Liquidator: Submit liquidation with proof
4. Contract: Verify liquidation proof
5. Contract: Transfer collateral to liquidator
6. Contract: Clear user commitments
7. Contract: Emit PrivateLiquidation event
```

## Security Considerations

1. **Proof Verification**: All proofs must be verified on-chain
2. **Commitment Uniqueness**: Salts must be random and unique
3. **Front-running Protection**: Commitments prevent MEV
4. **Oracle Security**: Price feeds must be reliable
5. **Bridge Security**: BTC bridge must be trust-minimized

## Scalability

- Commitments are constant size (1 felt252)
- Proofs verified in O(log n) time with STARKs
- Storage efficient: 2 commitments per user
- Gas optimized Cairo contracts

## Future Enhancements

1. **Recursive Proofs**: Batch multiple operations
2. **Private Credit Scores**: ZK-based reputation
3. **Cross-chain Privacy**: Bridge to other L2s
4. **Institutional Features**: Multi-sig with privacy
5. **Compliance Layer**: Selective disclosure for regulators
