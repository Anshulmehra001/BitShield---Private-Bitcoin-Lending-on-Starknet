# BitShield Testnet Deployment Script for Windows
# This script deploys BitShield contracts to Starknet Sepolia testnet

Write-Host "=== BitShield Testnet Deployment ===" -ForegroundColor Cyan

# Set PATH for Scarb and Starkli
$env:PATH = "D:\starknet-tools\scarb-v2.8.4-x86_64-pc-windows-msvc\bin;D:\starknet-tools\starkli;" + $env:PATH

# Configuration
$NETWORK = "sepolia"
$RPC_URL = "https://starknet-sepolia.public.blastapi.io/rpc/v0_7"
$KEYSTORE_PATH = "D:\starknet-tools\deployer.json"
$ACCOUNT_PATH = "D:\starknet-tools\account.json"

Write-Host "`nStep 1: Checking if keystore exists..." -ForegroundColor Yellow
if (-Not (Test-Path $KEYSTORE_PATH)) {
    Write-Host "Creating new keystore at $KEYSTORE_PATH" -ForegroundColor Green
    Write-Host "Please enter a password for your keystore when prompted." -ForegroundColor Cyan
    starkli signer keystore new $KEYSTORE_PATH
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to create keystore" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "Keystore already exists at $KEYSTORE_PATH" -ForegroundColor Green
}

Write-Host "`nStep 2: Checking if account exists..." -ForegroundColor Yellow
if (-Not (Test-Path $ACCOUNT_PATH)) {
    Write-Host "Creating new account..." -ForegroundColor Green
    Write-Host "This will create an account descriptor. You'll need to:" -ForegroundColor Cyan
    Write-Host "1. Get testnet ETH from: https://starknet-faucet.vercel.app/" -ForegroundColor Cyan
    Write-Host "2. Deploy the account using: starkli account deploy $ACCOUNT_PATH" -ForegroundColor Cyan
    
    starkli account oz init --keystore $KEYSTORE_PATH $ACCOUNT_PATH
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to create account" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "`nIMPORTANT: Account created but not deployed yet!" -ForegroundColor Red
    Write-Host "Please:" -ForegroundColor Yellow
    Write-Host "1. Get your account address from $ACCOUNT_PATH" -ForegroundColor Yellow
    Write-Host "2. Get testnet ETH from https://starknet-faucet.vercel.app/" -ForegroundColor Yellow
    Write-Host "3. Run: starkli account deploy $ACCOUNT_PATH --rpc $RPC_URL --keystore $KEYSTORE_PATH" -ForegroundColor Yellow
    Write-Host "4. Then run this script again" -ForegroundColor Yellow
    exit 0
} else {
    Write-Host "Account exists at $ACCOUNT_PATH" -ForegroundColor Green
}

Write-Host "`nStep 3: Building contracts..." -ForegroundColor Yellow
Set-Location contracts
scarb build
if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to build contracts" -ForegroundColor Red
    exit 1
}
Set-Location ..
Write-Host "Contracts built successfully" -ForegroundColor Green

Write-Host "`nStep 4: Deploying MockUSDC..." -ForegroundColor Yellow
$MOCK_USDC_ADDRESS = starkli declare target/dev/bitshield_MockUSDC.contract_class.json --rpc $RPC_URL --account $ACCOUNT_PATH --keystore $KEYSTORE_PATH
if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to declare MockUSDC" -ForegroundColor Red
    exit 1
}
Write-Host "MockUSDC declared: $MOCK_USDC_ADDRESS" -ForegroundColor Green

Write-Host "`nStep 5: Deploying BTCBridge..." -ForegroundColor Yellow
$BTC_BRIDGE_ADDRESS = starkli declare target/dev/bitshield_BTCBridge.contract_class.json --rpc $RPC_URL --account $ACCOUNT_PATH --keystore $KEYSTORE_PATH
if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to declare BTCBridge" -ForegroundColor Red
    exit 1
}
Write-Host "BTCBridge declared: $BTC_BRIDGE_ADDRESS" -ForegroundColor Green

Write-Host "`nStep 6: Deploying BitShieldVault..." -ForegroundColor Yellow
$VAULT_ADDRESS = starkli declare target/dev/bitshield_BitShieldVault.contract_class.json --rpc $RPC_URL --account $ACCOUNT_PATH --keystore $KEYSTORE_PATH
if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to declare BitShieldVault" -ForegroundColor Red
    exit 1
}
Write-Host "BitShieldVault declared: $VAULT_ADDRESS" -ForegroundColor Green

Write-Host "`n=== Deployment Complete ===" -ForegroundColor Cyan
Write-Host "Contract Addresses:" -ForegroundColor Green
Write-Host "MockUSDC: $MOCK_USDC_ADDRESS" -ForegroundColor White
Write-Host "BTCBridge: $BTC_BRIDGE_ADDRESS" -ForegroundColor White
Write-Host "BitShieldVault: $VAULT_ADDRESS" -ForegroundColor White

Write-Host "`nNext Steps:" -ForegroundColor Yellow
Write-Host "1. Update frontend/src/config.ts with these addresses" -ForegroundColor White
Write-Host "2. Test the frontend integration" -ForegroundColor White
Write-Host "3. Record your demo video" -ForegroundColor White
