// Deploy RWA + Yield contracts to multiple chains
// Usage:
//   npx hardhat run scripts/deployMultiChain.js --network mantleSepolia
//   npx hardhat run scripts/deployMultiChain.js --network polygonAmoy
//   npx hardhat run scripts/deployMultiChain.js --network bnbTestnet

const hre = require("hardhat");
const fs = require("fs");
const path = require("path");

// Chain configurations
const CHAIN_CONFIG = {
  mantleSepolia: {
    chainId: 5003,
    name: "Mantle Sepolia Testnet",
    explorer: "https://sepolia.mantlescan.xyz",
    nativeCurrency: "MNT",
    // IndiaRunner needs to be deployed first on each chain
    indiaRunnerAddress: "0x94ec3cA5359A20f01912f4F7e4D464C8A52f467b"
  },
  polygonAmoy: {
    chainId: 80002,
    name: "Polygon Amoy Testnet",
    explorer: "https://amoy.polygonscan.com",
    nativeCurrency: "MATIC",
    indiaRunnerAddress: null // Will be deployed
  },
  bnbTestnet: {
    chainId: 97,
    name: "BNB Smart Chain Testnet",
    explorer: "https://testnet.bscscan.com",
    nativeCurrency: "tBNB",
    indiaRunnerAddress: null // Will be deployed
  }
};

async function main() {
  const networkName = hre.network.name;
  const config = CHAIN_CONFIG[networkName];

  if (!config) {
    throw new Error(`Unknown network: ${networkName}. Supported: ${Object.keys(CHAIN_CONFIG).join(", ")}`);
  }

  const [deployer] = await hre.ethers.getSigners();
  const balance = await hre.ethers.provider.getBalance(deployer.address);

  console.log("═══════════════════════════════════════════════════════");
  console.log(`Deploying to ${config.name}`);
  console.log("═══════════════════════════════════════════════════════");
  console.log("Deployer:", deployer.address);
  console.log("Balance:", hre.ethers.formatEther(balance), config.nativeCurrency);
  console.log("Chain ID:", config.chainId);
  console.log("");

  let indiaRunnerAddress = config.indiaRunnerAddress;

  // ============ Deploy IndiaRunner if needed ============
  if (!indiaRunnerAddress) {
    console.log("1. Deploying IndiaRunner...");
    const IndiaRunner = await hre.ethers.getContractFactory("IndiaRunner");
    const indiaRunner = await IndiaRunner.deploy();
    await indiaRunner.waitForDeployment();
    indiaRunnerAddress = await indiaRunner.getAddress();
    console.log("   IndiaRunner deployed to:", indiaRunnerAddress);
  } else {
    console.log("1. Using existing IndiaRunner:", indiaRunnerAddress);
  }

  // ============ Deploy RUNToken ============
  console.log("\n2. Deploying RUNToken...");
  const RUNToken = await hre.ethers.getContractFactory("RUNToken");
  const runToken = await RUNToken.deploy(deployer.address);
  await runToken.waitForDeployment();
  const runTokenAddress = await runToken.getAddress();
  console.log("   RUNToken deployed to:", runTokenAddress);

  // ============ Deploy LandmarkYieldNFT ============
  console.log("\n3. Deploying LandmarkYieldNFT...");
  const LandmarkYieldNFT = await hre.ethers.getContractFactory("LandmarkYieldNFT");
  const landmarkYield = await LandmarkYieldNFT.deploy(
    indiaRunnerAddress,
    `https://api.gpsrunner.game/${networkName}/yield/{id}.json`
  );
  await landmarkYield.waitForDeployment();
  const landmarkYieldAddress = await landmarkYield.getAddress();
  console.log("   LandmarkYieldNFT deployed to:", landmarkYieldAddress);

  // ============ Deploy MarkerStakingPool ============
  console.log("\n4. Deploying MarkerStakingPool...");
  const MarkerStakingPool = await hre.ethers.getContractFactory("MarkerStakingPool");
  const markerStaking = await MarkerStakingPool.deploy(indiaRunnerAddress);
  await markerStaking.waitForDeployment();
  const markerStakingAddress = await markerStaking.getAddress();
  console.log("   MarkerStakingPool deployed to:", markerStakingAddress);

  // ============ Deploy GovernanceVoting ============
  console.log("\n5. Deploying GovernanceVoting...");
  const GovernanceVoting = await hre.ethers.getContractFactory("GovernanceVoting");
  const governance = await GovernanceVoting.deploy(runTokenAddress);
  await governance.waitForDeployment();
  const governanceAddress = await governance.getAddress();
  console.log("   GovernanceVoting deployed to:", governanceAddress);

  // ============ Configure Permissions ============
  console.log("\n6. Configuring permissions...");

  console.log("   Setting authorized minter on LandmarkYieldNFT...");
  await (await landmarkYield.setAuthorizedMinter(deployer.address, true)).wait();

  console.log("   Setting authorized callers on MarkerStakingPool...");
  await (await markerStaking.setAuthorizedCaller(deployer.address, true)).wait();
  await (await markerStaking.setAuthorizedCaller(landmarkYieldAddress, true)).wait();

  console.log("   Setting minters on RUNToken...");
  const minterLimit = hre.ethers.parseEther("100000000"); // 100M
  await (await runToken.setMinter(markerStakingAddress, minterLimit)).wait();
  await (await runToken.setMinter(landmarkYieldAddress, minterLimit)).wait();

  // ============ Seed Initial Pool (optional) ============
  console.log("\n7. Seeding initial pool...");
  try {
    const seedAmount = hre.ethers.parseEther("0.01"); // Small amount for testing
    await (await markerStaking.depositToSeasonPool({ value: seedAmount })).wait();
    console.log("   Season pool seeded with 0.01", config.nativeCurrency);
  } catch (e) {
    console.log("   Skipping pool seed (insufficient balance or error):", e.message);
  }

  // ============ Summary ============
  console.log("\n═══════════════════════════════════════════════════════");
  console.log(`Deployment Complete on ${config.name}!`);
  console.log("═══════════════════════════════════════════════════════");
  console.log("\nContract Addresses:");
  console.log(`  IndiaRunner:        ${indiaRunnerAddress}`);
  console.log(`  RUNToken:           ${runTokenAddress}`);
  console.log(`  LandmarkYieldNFT:   ${landmarkYieldAddress}`);
  console.log(`  MarkerStakingPool:  ${markerStakingAddress}`);
  console.log(`  GovernanceVoting:   ${governanceAddress}`);
  console.log("\nExplorer:", config.explorer);

  // Save deployment info
  const deploymentInfo = {
    network: networkName,
    chainId: config.chainId,
    deployedAt: new Date().toISOString(),
    deployer: deployer.address,
    contracts: {
      RUNToken: runTokenAddress,
      LandmarkYieldNFT: landmarkYieldAddress,
      MarkerStakingPool: markerStakingAddress,
      GovernanceVoting: governanceAddress,
      IndiaRunner: indiaRunnerAddress
    },
    configuration: {
      authorizedMinters: [deployer.address],
      authorizedCallers: [deployer.address, landmarkYieldAddress]
    }
  };

  // Ensure deployments directory exists
  const deploymentsDir = path.join(__dirname, "..", "deployments");
  if (!fs.existsSync(deploymentsDir)) {
    fs.mkdirSync(deploymentsDir, { recursive: true });
  }

  const filePath = path.join(deploymentsDir, `rwa-${networkName}.json`);
  fs.writeFileSync(filePath, JSON.stringify(deploymentInfo, null, 2));
  console.log(`\nDeployment saved to: deployments/rwa-${networkName}.json`);

  // Output for chain_config.dart
  console.log("\n───────────────────────────────────────────────────────");
  console.log("Flutter chain_config.dart update:");
  console.log("───────────────────────────────────────────────────────");
  console.log(`
  static final ${networkName} = ChainConfig(
    type: ChainType.${networkName},
    // ... existing config ...
    indiaRunnerAddress: '${indiaRunnerAddress}',
    runTokenAddress: '${runTokenAddress}',
    landmarkYieldAddress: '${landmarkYieldAddress}',
    markerStakingAddress: '${markerStakingAddress}',
    governanceAddress: '${governanceAddress}',
  );
  `);

  return deploymentInfo;
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
