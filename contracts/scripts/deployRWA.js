// Deploy RWA + Yield contracts to Mantle Sepolia
// Usage: npx hardhat run scripts/deployRWA.js --network mantleSepolia

const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying RWA contracts with account:", deployer.address);
  console.log("Account balance:", hre.ethers.formatEther(await hre.ethers.provider.getBalance(deployer.address)), "ETH");

  // Existing IndiaRunner contract address
  const INDIA_RUNNER_ADDRESS = "0x94ec3cA5359A20f01912f4F7e4D464C8A52f467b";

  // ============ 1. Deploy RUNToken ============
  console.log("\n1. Deploying RUNToken...");
  const RUNToken = await hre.ethers.getContractFactory("RUNToken");
  const runToken = await RUNToken.deploy(deployer.address);
  await runToken.waitForDeployment();
  const runTokenAddress = await runToken.getAddress();
  console.log("RUNToken deployed to:", runTokenAddress);

  // ============ 2. Deploy LandmarkYieldNFT ============
  console.log("\n2. Deploying LandmarkYieldNFT...");
  const LandmarkYieldNFT = await hre.ethers.getContractFactory("LandmarkYieldNFT");
  const landmarkYield = await LandmarkYieldNFT.deploy(
    INDIA_RUNNER_ADDRESS,
    "https://api.gpsrunner.game/yield/{id}.json" // Metadata URI
  );
  await landmarkYield.waitForDeployment();
  const landmarkYieldAddress = await landmarkYield.getAddress();
  console.log("LandmarkYieldNFT deployed to:", landmarkYieldAddress);

  // ============ 3. Deploy MarkerStakingPool ============
  console.log("\n3. Deploying MarkerStakingPool...");
  const MarkerStakingPool = await hre.ethers.getContractFactory("MarkerStakingPool");
  const markerStaking = await MarkerStakingPool.deploy(INDIA_RUNNER_ADDRESS);
  await markerStaking.waitForDeployment();
  const markerStakingAddress = await markerStaking.getAddress();
  console.log("MarkerStakingPool deployed to:", markerStakingAddress);

  // ============ 4. Deploy GovernanceVoting ============
  console.log("\n4. Deploying GovernanceVoting...");
  const GovernanceVoting = await hre.ethers.getContractFactory("GovernanceVoting");
  const governance = await GovernanceVoting.deploy(runTokenAddress);
  await governance.waitForDeployment();
  const governanceAddress = await governance.getAddress();
  console.log("GovernanceVoting deployed to:", governanceAddress);

  // ============ 5. Configure Permissions ============
  console.log("\n5. Configuring permissions...");

  // Set deployer as authorized minter on LandmarkYieldNFT
  console.log("Setting authorized minter on LandmarkYieldNFT...");
  await landmarkYield.setAuthorizedMinter(deployer.address, true);

  // Set deployer as authorized caller on MarkerStakingPool
  console.log("Setting authorized caller on MarkerStakingPool...");
  await markerStaking.setAuthorizedCaller(deployer.address, true);

  // Set LandmarkYieldNFT as authorized caller on MarkerStakingPool (for fee recording)
  console.log("Setting LandmarkYieldNFT as authorized caller on MarkerStakingPool...");
  await markerStaking.setAuthorizedCaller(landmarkYieldAddress, true);

  // Set MarkerStakingPool as minter on RUNToken
  console.log("Setting MarkerStakingPool as minter on RUNToken...");
  await runToken.setMinter(markerStakingAddress, hre.ethers.parseEther("100000000")); // 100M limit

  // Set LandmarkYieldNFT as minter on RUNToken
  console.log("Setting LandmarkYieldNFT as minter on RUNToken...");
  await runToken.setMinter(landmarkYieldAddress, hre.ethers.parseEther("100000000")); // 100M limit

  // ============ 6. Seed Initial Pools ============
  console.log("\n6. Seeding initial pools...");

  // Seed season pool with 0.1 ETH (for testing)
  const seedAmount = hre.ethers.parseEther("0.1");
  console.log("Seeding MarkerStakingPool season pool with 0.1 ETH...");
  await markerStaking.depositToSeasonPool({ value: seedAmount });

  // ============ 7. Verify Deployment ============
  console.log("\n7. Verifying deployment...");

  const runTokenInfo = await runToken.getTokenInfo();
  console.log("RUNToken supply:", hre.ethers.formatEther(runTokenInfo[0]), "RUN");

  const seasonInfo = await markerStaking.getSeasonInfo();
  console.log("MarkerStakingPool season:", seasonInfo[0].toString());
  console.log("Season pool balance:", hre.ethers.formatEther(seasonInfo[2]), "ETH");

  // ============ Summary ============
  console.log("\n========================================");
  console.log("RWA Deployment Complete!");
  console.log("========================================");
  console.log("\nContract Addresses:");
  console.log("  RUNToken:          ", runTokenAddress);
  console.log("  LandmarkYieldNFT:  ", landmarkYieldAddress);
  console.log("  MarkerStakingPool: ", markerStakingAddress);
  console.log("  GovernanceVoting:  ", governanceAddress);
  console.log("\nExisting Contracts:");
  console.log("  IndiaRunner:       ", INDIA_RUNNER_ADDRESS);
  console.log("\n========================================");

  // Output for Flutter integration
  console.log("\nFlutter Integration (copy to rwa_service.dart):");
  console.log(`
  static const String runTokenAddress = '${runTokenAddress}';
  static const String landmarkYieldAddress = '${landmarkYieldAddress}';
  static const String markerStakingAddress = '${markerStakingAddress}';
  static const String governanceAddress = '${governanceAddress}';
  `);

  // Save addresses to file
  const fs = require("fs");
  const addresses = {
    network: "mantleSepolia",
    chainId: 5003,
    deployedAt: new Date().toISOString(),
    contracts: {
      RUNToken: runTokenAddress,
      LandmarkYieldNFT: landmarkYieldAddress,
      MarkerStakingPool: markerStakingAddress,
      GovernanceVoting: governanceAddress,
      IndiaRunner: INDIA_RUNNER_ADDRESS
    }
  };

  fs.writeFileSync(
    "deployments/rwa-mantleSepolia.json",
    JSON.stringify(addresses, null, 2)
  );
  console.log("\nAddresses saved to deployments/rwa-mantleSepolia.json");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
