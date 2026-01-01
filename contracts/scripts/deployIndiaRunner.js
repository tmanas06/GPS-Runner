const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  const network = await ethers.provider.getNetwork();

  console.log("=".repeat(50));
  console.log("Deploying IndiaRunner to", network.name);
  console.log("Chain ID:", network.chainId.toString());
  console.log("=".repeat(50));
  console.log("\nDeployer:", deployer.address);

  const balance = await ethers.provider.getBalance(deployer.address);
  console.log("Balance:", ethers.formatEther(balance), "MNT");

  if (balance === 0n) {
    console.error("\nError: Deployer has no balance!");
    console.log("Get testnet MNT from: https://faucet.sepolia.mantle.xyz/");
    process.exit(1);
  }

  console.log("\nDeploying IndiaRunner contract...");

  const IndiaRunner = await ethers.getContractFactory("IndiaRunner");
  const indiaRunner = await IndiaRunner.deploy();

  console.log("Waiting for deployment...");
  await indiaRunner.waitForDeployment();

  const contractAddress = await indiaRunner.getAddress();
  console.log("\n" + "=".repeat(50));
  console.log("IndiaRunner deployed successfully!");
  console.log("=".repeat(50));
  console.log("\nContract Address:", contractAddress);
  console.log("\nUpdate this address in:");
  console.log("  lib/models/city_bounds.dart -> indiaContractAddress");
  console.log("\nMantle Sepolia Explorer:");
  console.log(`  https://sepolia.mantlescan.xyz/address/${contractAddress}`);

  // Wait for confirmations
  if (network.chainId !== 31337n) {
    console.log("\nWaiting for block confirmations...");
    await indiaRunner.deploymentTransaction().wait(3);
    console.log("Confirmed!");
  }

  // Verify initial state
  console.log("\nVerifying contract state...");
  const totalPlayers = await indiaRunner.totalPlayersCount();
  const totalMarkers = await indiaRunner.totalMarkersCount();
  const owner = await indiaRunner.owner();

  console.log("- Total Players:", totalPlayers.toString());
  console.log("- Total Markers:", totalMarkers.toString());
  console.log("- Owner:", owner);
  console.log("- Paused:", await indiaRunner.paused());

  console.log("\n" + "=".repeat(50));
  console.log("Deployment complete!");
  console.log("=".repeat(50));

  return contractAddress;
}

main()
  .then((address) => {
    console.log("\nExported contract address:", address);
    process.exit(0);
  })
  .catch((error) => {
    console.error("\nDeployment failed:");
    console.error(error);
    process.exit(1);
  });
