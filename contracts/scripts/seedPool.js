// Seed the MarkerStakingPool season pool
const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Seeding pool with account:", deployer.address);

  const pool = await hre.ethers.getContractAt(
    'MarkerStakingPool',
    '0xd4DD97Be46D3DDB73BC559b327bF834BB7b5fAb3'
  );

  console.log("Sending 0.1 ETH to season pool...");
  const tx = await pool.depositToSeasonPool({ value: hre.ethers.parseEther('0.1') });
  await tx.wait();
  console.log("Season pool seeded! Tx:", tx.hash);

  const info = await pool.getSeasonInfo();
  console.log("Season:", info[0].toString());
  console.log("Pool balance:", hre.ethers.formatEther(info[2]), "ETH");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
