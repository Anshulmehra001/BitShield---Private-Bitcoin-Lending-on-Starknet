const hre = require("hardhat");

async function main() {
  console.log("Deploying BitShield contracts to Arbitrum Sepolia...\n");

  // Get deployer
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying with account:", deployer.address);
  
  const balance = await hre.ethers.provider.getBalance(deployer.address);
  console.log("Account balance:", hre.ethers.formatEther(balance), "ETH\n");

  // Deploy MockUSDC
  console.log("Deploying MockUSDC...");
  const MockUSDC = await hre.ethers.getContractFactory("MockUSDC");
  const mockUSDC = await MockUSDC.deploy();
  await mockUSDC.waitForDeployment();
  const usdcAddress = await mockUSDC.getAddress();
  console.log("MockUSDC deployed to:", usdcAddress);

  // Deploy BTCBridge
  console.log("\nDeploying BTCBridge...");
  const BTCBridge = await hre.ethers.getContractFactory("BTCBridge");
  const btcBridge = await BTCBridge.deploy();
  await btcBridge.waitForDeployment();
  const bridgeAddress = await btcBridge.getAddress();
  console.log("BTCBridge deployed to:", bridgeAddress);

  // Deploy BitShieldVault
  console.log("\nDeploying BitShieldVault...");
  const BitShieldVault = await hre.ethers.getContractFactory("BitShieldVault");
  const vault = await BitShieldVault.deploy();
  await vault.waitForDeployment();
  const vaultAddress = await vault.getAddress();
  console.log("BitShieldVault deployed to:", vaultAddress);

  console.log("\n=== Deployment Complete ===");
  console.log("MockUSDC:", usdcAddress);
  console.log("BTCBridge:", bridgeAddress);
  console.log("BitShieldVault:", vaultAddress);
  console.log("\nVerify on Arbiscan:");
  console.log(`https://sepolia.arbiscan.io/address/${vaultAddress}`);
  console.log(`https://sepolia.arbiscan.io/address/${bridgeAddress}`);
  console.log(`https://sepolia.arbiscan.io/address/${usdcAddress}`);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
