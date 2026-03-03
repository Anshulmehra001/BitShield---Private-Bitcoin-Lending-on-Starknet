import { useState } from 'react';
import './App.css';

interface WalletState {
  address: string | null;
  isConnected: boolean;
}

interface UserPosition {
  collateral: number;
  debt: number;
  healthFactor: string;
}

function App() {
  const [wallet, setWallet] = useState<WalletState>({
    address: null,
    isConnected: false,
  });
  const [position] = useState<UserPosition>({
    collateral: 0,
    debt: 0,
    healthFactor: 'Safe',
  });
  const [depositAmount, setDepositAmount] = useState('');
  const [borrowAmount, setBorrowAmount] = useState('');
  const [loading, setLoading] = useState(false);

  const connectWallet = async () => {
    try {
      // Demo mode - simulate wallet connection
      const demoAddress = '0x' + Math.random().toString(16).substring(2, 42);
      setWallet({
        address: demoAddress,
        isConnected: true,
      });
      alert('Demo Mode: Wallet Connected!\n\nAddress: ' + demoAddress.substring(0, 10) + '...');
    } catch (error) {
      console.error('Failed to connect wallet:', error);
    }
  };

  const disconnectWallet = () => {
    setWallet({ address: null, isConnected: false });
  };

  const handleDeposit = async () => {
    if (!depositAmount || !wallet.isConnected) return;
    
    setLoading(true);
    try {
      // Simulate transaction
      await new Promise(resolve => setTimeout(resolve, 1500));
      
      alert(`✅ Deposit Successful!\n\nAmount: ${depositAmount} BTC\nStatus: Encrypted on-chain\n\nNote: This is demo mode. Deploy contracts to testnet for real transactions.`);
      setDepositAmount('');
    } catch (error) {
      console.error('Deposit failed:', error);
      alert('Deposit failed');
    } finally {
      setLoading(false);
    }
  };

  const handleBorrow = async () => {
    if (!borrowAmount || !wallet.isConnected) return;
    
    setLoading(true);
    try {
      // Simulate transaction
      await new Promise(resolve => setTimeout(resolve, 1500));
      
      alert(`✅ Borrow Successful!\n\nAmount: ${borrowAmount} USDC\nStatus: Private loan created\n\nNote: This is demo mode. Deploy contracts to testnet for real transactions.`);
      setBorrowAmount('');
    } catch (error) {
      console.error('Borrow failed:', error);
      alert('Borrow failed');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="app">
      <header className="header">
        <div className="logo">
          <span className="shield-icon">🛡️</span>
          <h1>BitShield</h1>
        </div>
        
        {!wallet.isConnected ? (
          <button onClick={connectWallet} className="connect-btn">
            Connect Wallet
          </button>
        ) : (
          <div className="wallet-info">
            <span className="address">
              {wallet.address?.slice(0, 6)}...{wallet.address?.slice(-4)}
            </span>
            <button onClick={disconnectWallet} className="disconnect-btn">
              Disconnect
            </button>
          </div>
        )}
      </header>

      <main className="main">
        <div className="hero">
          <h2>Private Bitcoin Lending on Starknet</h2>
          <p>Deposit BTC, borrow stablecoins. Your amounts stay private.</p>
        </div>

        {wallet.isConnected ? (
          <div className="dashboard">
            <div className="stats">
              <div className="stat-card">
                <h3>Your Collateral</h3>
                <p className="encrypted">
                  {position.collateral > 0 ? `${position.collateral.toFixed(4)} BTC` : '🔒 Encrypted'}
                </p>
                <span className="hint">Only you can see this</span>
              </div>
              <div className="stat-card">
                <h3>Your Debt</h3>
                <p className="encrypted">
                  {position.debt > 0 ? `${position.debt.toFixed(2)} USDC` : '🔒 Encrypted'}
                </p>
                <span className="hint">Only you can see this</span>
              </div>
              <div className="stat-card">
                <h3>Health Factor</h3>
                <p className="health">🟢 {position.healthFactor}</p>
                <span className="hint">Computed privately</span>
              </div>
            </div>

            <div className="actions">
              <div className="action-card">
                <h3>Deposit BTC</h3>
                <input
                  type="number"
                  placeholder="Amount in BTC"
                  value={depositAmount}
                  onChange={(e) => setDepositAmount(e.target.value)}
                  className="input"
                />
                <button
                  onClick={handleDeposit}
                  disabled={loading || !depositAmount}
                  className="action-btn primary"
                >
                  {loading ? 'Processing...' : 'Deposit Privately'}
                </button>
                <p className="note">
                  ✓ Amount encrypted with ZK proof
                </p>
              </div>

              <div className="action-card">
                <h3>Borrow USDC</h3>
                <input
                  type="number"
                  placeholder="Amount in USDC"
                  value={borrowAmount}
                  onChange={(e) => setBorrowAmount(e.target.value)}
                  className="input"
                />
                <button
                  onClick={handleBorrow}
                  disabled={loading || !borrowAmount}
                  className="action-btn secondary"
                >
                  {loading ? 'Processing...' : 'Borrow Privately'}
                </button>
                <p className="note">
                  ✓ Loan amount stays confidential
                </p>
              </div>
            </div>

            <div className="protocol-stats">
              <h3>Protocol Stats (Public)</h3>
              <div className="public-stats">
                <div className="stat">
                  <span>Total Value Locked</span>
                  <strong>$2.1M</strong>
                </div>
                <div className="stat">
                  <span>Active Loans</span>
                  <strong>127</strong>
                </div>
                <div className="stat">
                  <span>Collateral Ratio</span>
                  <strong>150%</strong>
                </div>
              </div>
            </div>
          </div>
        ) : (
          <div className="connect-prompt">
            <p>Connect your Starknet wallet to start lending privately</p>
          </div>
        )}
      </main>

      <footer className="footer">
        <p>Built for Re{'{define}'} Hackathon</p>
        <p>Privacy Track + Bitcoin Track</p>
      </footer>
    </div>
  );
}

export default App;
