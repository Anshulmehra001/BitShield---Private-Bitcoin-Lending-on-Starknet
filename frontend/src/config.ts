// Contract addresses - update after deployment
export const CONTRACTS = {
  VAULT: '0x0', // BitShieldVault address
  BTC_BRIDGE: '0x0', // BTCBridge address
  MOCK_USDC: '0x0', // MockUSDC address
};

export const NETWORK = {
  chainId: 'SN_SEPOLIA', // Starknet Sepolia testnet
  rpcUrl: 'https://starknet-sepolia.public.blastapi.io/rpc/v0_7',
};

// Privacy settings
export const PRIVACY = {
  // Simple XOR encryption for demo (not production-grade)
  encryptAmount: (amount: number, userAddress: string): bigint => {
    // Convert amount to wei (assuming 8 decimals for BTC)
    const amountWei = BigInt(Math.floor(amount * 100000000));
    // Simple obfuscation using address hash
    const addressNum = BigInt(userAddress.slice(0, 10));
    return amountWei ^ addressNum;
  },
  
  decryptAmount: (encrypted: bigint, userAddress: string): number => {
    const addressNum = BigInt(userAddress.slice(0, 10));
    const amountWei = encrypted ^ addressNum;
    return Number(amountWei) / 100000000;
  },
};

export const VAULT_ABI = [
  {
    name: 'deposit_collateral',
    type: 'function',
    inputs: [{ name: 'encrypted_amount', type: 'u256' }],
    outputs: [],
  },
  {
    name: 'borrow',
    type: 'function',
    inputs: [{ name: 'encrypted_amount', type: 'u256' }],
    outputs: [],
  },
  {
    name: 'repay',
    type: 'function',
    inputs: [{ name: 'encrypted_amount', type: 'u256' }],
    outputs: [],
  },
  {
    name: 'get_collateral',
    type: 'function',
    inputs: [{ name: 'user', type: 'ContractAddress' }],
    outputs: [{ type: 'u256' }],
  },
  {
    name: 'get_debt',
    type: 'function',
    inputs: [{ name: 'user', type: 'ContractAddress' }],
    outputs: [{ type: 'u256' }],
  },
  {
    name: 'get_tvl',
    type: 'function',
    inputs: [],
    outputs: [{ type: 'u256' }],
  },
];
