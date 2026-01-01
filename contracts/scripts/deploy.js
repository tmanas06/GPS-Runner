const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with account:", deployer.address);
  console.log("Account balance:", ethers.formatEther(await ethers.provider.getBalance(deployer.address)));

  // 1. Deploy GPSToken
  console.log("\n1. Deploying GPSToken...");
  const GPSToken = await ethers.getContractFactory("GPSToken");
  const gpsToken = await GPSToken.deploy(deployer.address);
  await gpsToken.waitForDeployment();
  console.log("GPSToken deployed to:", await gpsToken.getAddress());

  // 2. Deploy GPSRunner
  console.log("\n2. Deploying GPSRunner...");
  const GPSRunner = await ethers.getContractFactory("GPSRunner");
  const gpsRunner = await GPSRunner.deploy();
  await gpsRunner.waitForDeployment();
  console.log("GPSRunner deployed to:", await gpsRunner.getAddress());

  // 3. Deploy GPSStaking
  console.log("\n3. Deploying GPSStaking...");
  const GPSStaking = await ethers.getContractFactory("GPSStaking");
  const gpsStaking = await GPSStaking.deploy(
    ethers.ZeroAddress, // Use native token for rewards
    deployer.address // Treasury
  );
  await gpsStaking.waitForDeployment();
  console.log("GPSStaking deployed to:", await gpsStaking.getAddress());

  // 4. Configure contracts
  console.log("\n4. Configuring contracts...");

  // Link staking to runner
  await gpsStaking.setGPSRunnerContract(await gpsRunner.getAddress());
  console.log("- Linked staking to runner");

  // Add staking as minter
  const minterLimit = ethers.parseEther("100000000"); // 100M tokens
  await gpsToken.addMinter(await gpsStaking.getAddress(), minterLimit);
  console.log("- Added staking contract as minter");

  // Set initial reward rate (0.001 ETH per second for 30 days)
  const rewardRate = ethers.parseEther("0.001");
  const duration = 30 * 24 * 60 * 60; // 30 days
  await gpsStaking.setRewardRate(rewardRate, duration);
  console.log("- Set reward rate");

  // Fund staking contract for rewards (optional, for testing)
  // await deployer.sendTransaction({
  //   to: await gpsStaking.getAddress(),
  //   value: ethers.parseEther("10"),
  // });
  // console.log("- Funded staking contract");

  console.log("\n=== Deployment Complete ===");
  console.log({
    GPSToken: await gpsToken.getAddress(),
    GPSRunner: await gpsRunner.getAddress(),
    GPSStaking: await gpsStaking.getAddress(),
    deployer: deployer.address,
  });

  // Verify contracts on block explorer (if not local)
  const network = await ethers.provider.getNetwork();
  if (network.chainId !== 31337n) {
    console.log("\nWaiting for block confirmations...");
    await gpsToken.deploymentTransaction().wait(5);
    await gpsRunner.deploymentTransaction().wait(5);
    await gpsStaking.deploymentTransaction().wait(5);

    console.log("Verifying contracts on block explorer...");
    // Add verification logic here if needed
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
