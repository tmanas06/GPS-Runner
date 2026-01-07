const hre = require("hardhat");
const fs = require("fs");
const path = require("path");

// Chain configurations
const CHAINS = {
  mantleSepolia: {
    name: "Mantle Sepolia",
    tokenName: "GPS Game Mantle",
    tokenSymbol: "gMNT",
    chainId: 5003,
  },
  polygonAmoy: {
    name: "Polygon Amoy",
    tokenName: "GPS Game Polygon",
    tokenSymbol: "gPOL",
    chainId: 80002,
  },
  bnbTestnet: {
    name: "BNB Testnet",
    tokenName: "GPS Game BNB",
    tokenSymbol: "gBNB",
    chainId: 97,
  },
};

async function main() {
  const networkName = hre.network.name;
  const chainConfig = CHAINS[networkName];

  if (!chainConfig) {
    console.log("Unknown network:", networkName);
    console.log("Available networks:", Object.keys(CHAINS).join(", "));
    return;
  }

  console.log(`\n🚀 Deploying GameToken on ${chainConfig.name}...`);
  console.log(`   Token Name: ${chainConfig.tokenName}`);
  console.log(`   Token Symbol: ${chainConfig.tokenSymbol}`);
  console.log(`   Chain ID: ${chainConfig.chainId}\n`);

  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying with account:", deployer.address);

  const balance = await hre.ethers.provider.getBalance(deployer.address);
  console.log("Account balance:", hre.ethers.formatEther(balance));

  // Deploy GameToken
  const GameToken = await hre.ethers.getContractFactory("GameToken");
  const gameToken = await GameToken.deploy(
    chainConfig.tokenName,
    chainConfig.tokenSymbol,
    deployer.address // Initial signer is deployer
  );

  await gameToken.waitForDeployment();
  const tokenAddress = await gameToken.getAddress();

  console.log(`\n✅ GameToken (${chainConfig.tokenSymbol}) deployed to:`, tokenAddress);

  // Save deployment info
  const deploymentDir = path.join(__dirname, "../deployments", networkName);
  if (!fs.existsSync(deploymentDir)) {
    fs.mkdirSync(deploymentDir, { recursive: true });
  }

  const deploymentInfo = {
    network: networkName,
    chainId: chainConfig.chainId,
    tokenName: chainConfig.tokenName,
    tokenSymbol: chainConfig.tokenSymbol,
    address: tokenAddress,
    deployer: deployer.address,
    timestamp: new Date().toISOString(),
    blockNumber: await hre.ethers.provider.getBlockNumber(),
  };

  fs.writeFileSync(
    path.join(deploymentDir, "GameToken.json"),
    JSON.stringify(deploymentInfo, null, 2)
  );

  console.log(`\n📝 Deployment info saved to deployments/${networkName}/GameToken.json`);

  // Verify on explorer (if supported)
  if (networkName !== "localhost" && networkName !== "hardhat") {
    console.log("\n⏳ Waiting for block confirmations...");
    await new Promise((resolve) => setTimeout(resolve, 30000));

    try {
      console.log("🔍 Verifying contract on explorer...");
      await hre.run("verify:verify", {
        address: tokenAddress,
        constructorArguments: [
          chainConfig.tokenName,
          chainConfig.tokenSymbol,
          deployer.address,
        ],
      });
      console.log("✅ Contract verified!");
    } catch (error) {
      console.log("⚠️ Verification failed (may already be verified):", error.message);
    }
  }

  console.log("\n🎉 Deployment complete!");
  console.log("━".repeat(50));
  console.log(`Network: ${chainConfig.name}`);
  console.log(`Token: ${chainConfig.tokenSymbol}`);
  console.log(`Address: ${tokenAddress}`);
  console.log("━".repeat(50));
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
