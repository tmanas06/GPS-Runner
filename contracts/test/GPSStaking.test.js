const { expect } = require("chai");
const { ethers } = require("hardhat");
const { time } = require("@nomicfoundation/hardhat-network-helpers");

describe("GPSStaking", function () {
  let gpsStaking, gpsToken;
  let owner, treasury, player1, player2;
  let player1Id, player2Id;

  const STAKE_AMOUNT = ethers.parseEther("1");
  const REWARD_RATE = ethers.parseEther("0.0000001"); // per second (small for testing)

  beforeEach(async function () {
    [owner, treasury, player1, player2] = await ethers.getSigners();

    // Deploy token
    const GPSToken = await ethers.getContractFactory("GPSToken");
    gpsToken = await GPSToken.deploy(treasury.address);
    await gpsToken.waitForDeployment();

    // Deploy staking (using native token for simplicity)
    const GPSStaking = await ethers.getContractFactory("GPSStaking");
    gpsStaking = await GPSStaking.deploy(ethers.ZeroAddress, treasury.address);
    await gpsStaking.waitForDeployment();

    // Fund staking contract
    await owner.sendTransaction({
      to: await gpsStaking.getAddress(),
      value: ethers.parseEther("100"),
    });

    // Set reward rate
    await gpsStaking.setRewardRate(REWARD_RATE, 30 * 24 * 60 * 60); // 30 days

    player1Id = ethers.keccak256(ethers.toUtf8Bytes("player1"));
    player2Id = ethers.keccak256(ethers.toUtf8Bytes("player2"));
  });

  describe("Deployment", function () {
    it("Should set owner correctly", async function () {
      expect(await gpsStaking.owner()).to.equal(owner.address);
    });

    it("Should set treasury correctly", async function () {
      expect(await gpsStaking.treasury()).to.equal(treasury.address);
    });

    it("Should have correct initial pool state", async function () {
      const poolInfo = await gpsStaking.getPoolInfo();
      expect(poolInfo.totalStaked).to.equal(0);
      expect(poolInfo.rewardRate).to.equal(REWARD_RATE);
    });
  });

  describe("Staking", function () {
    it("Should stake tokens", async function () {
      await expect(
        gpsStaking.connect(player1).stake(player1Id, { value: STAKE_AMOUNT })
      ).to.emit(gpsStaking, "Staked")
        .withArgs(player1Id, STAKE_AMOUNT);

      const stakeInfo = await gpsStaking.getStakeInfo(player1Id);
      expect(stakeInfo.stakedAmount).to.equal(STAKE_AMOUNT);
    });

    it("Should reject stake below minimum", async function () {
      await expect(
        gpsStaking.connect(player1).stake(player1Id, {
          value: ethers.parseEther("0.001"),
        })
      ).to.be.revertedWithCustomError(gpsStaking, "InvalidAmount");
    });

    it("Should reject stake above maximum", async function () {
      await expect(
        gpsStaking.connect(player1).stake(player1Id, {
          value: ethers.parseEther("2000"),
        })
      ).to.be.revertedWithCustomError(gpsStaking, "InvalidAmount");
    });

    it("Should allow multiple stakes from same player", async function () {
      await gpsStaking.connect(player1).stake(player1Id, { value: STAKE_AMOUNT });
      await gpsStaking.connect(player1).stake(player1Id, { value: STAKE_AMOUNT });

      const stakeInfo = await gpsStaking.getStakeInfo(player1Id);
      expect(stakeInfo.stakedAmount).to.equal(STAKE_AMOUNT * 2n);
    });

    it("Should update pool total staked", async function () {
      await gpsStaking.connect(player1).stake(player1Id, { value: STAKE_AMOUNT });
      await gpsStaking.connect(player2).stake(player2Id, { value: STAKE_AMOUNT });

      const poolInfo = await gpsStaking.getPoolInfo();
      expect(poolInfo.totalStaked).to.equal(STAKE_AMOUNT * 2n);
    });
  });

  describe("Rewards", function () {
    beforeEach(async function () {
      await gpsStaking.connect(player1).stake(player1Id, { value: STAKE_AMOUNT });
    });

    it("Should accumulate rewards over time", async function () {
      const initialPending = await gpsStaking.pendingRewards(player1Id);

      await time.increase(100); // 100 seconds

      const pendingAfter = await gpsStaking.pendingRewards(player1Id);
      expect(pendingAfter).to.be.gt(initialPending);
    });

    it("Should claim rewards", async function () {
      await time.increase(1000); // 1000 seconds

      const pending = await gpsStaking.pendingRewards(player1Id);
      expect(pending).to.be.gt(0);

      const balanceBefore = await ethers.provider.getBalance(player1.address);

      await expect(gpsStaking.connect(player1).claimRewards(player1Id))
        .to.emit(gpsStaking, "RewardsClaimed");

      const balanceAfter = await ethers.provider.getBalance(player1.address);
      // Balance should increase (minus gas)
      expect(balanceAfter).to.be.gt(balanceBefore - ethers.parseEther("0.01"));
    });

    it("Should apply activity multiplier", async function () {
      // Update activity multiplier to 2x
      await gpsStaking.updateActivityMultiplier(player1Id, 100); // 100 markers

      await time.increase(1000);

      const pendingWith2x = await gpsStaking.pendingRewards(player1Id);

      // Player 2 with default multiplier
      await gpsStaking.connect(player2).stake(player2Id, { value: STAKE_AMOUNT });
      await time.increase(1000);

      // Player 1's rewards should be higher due to multiplier
      const stakeInfo = await gpsStaking.getStakeInfo(player1Id);
      expect(stakeInfo.activityMultiplier).to.be.gte(100);
    });
  });

  describe("Unstaking", function () {
    beforeEach(async function () {
      await gpsStaking.connect(player1).stake(player1Id, { value: STAKE_AMOUNT });
    });

    it("Should request unstake", async function () {
      await expect(gpsStaking.connect(player1).requestUnstake(player1Id))
        .to.emit(gpsStaking, "UnstakeRequested")
        .withArgs(player1Id, STAKE_AMOUNT);

      const stakeInfo = await gpsStaking.getStakeInfo(player1Id);
      expect(stakeInfo.hasUnstakeRequest).to.be.true;
    });

    it("Should reject unstake before cooldown", async function () {
      await gpsStaking.connect(player1).requestUnstake(player1Id);

      await expect(
        gpsStaking.connect(player1).unstake(player1Id)
      ).to.be.revertedWithCustomError(gpsStaking, "CooldownNotMet");
    });

    it("Should allow unstake after cooldown", async function () {
      await gpsStaking.connect(player1).requestUnstake(player1Id);

      // Wait for cooldown (7 days)
      await time.increase(7 * 24 * 60 * 60 + 1);

      const balanceBefore = await ethers.provider.getBalance(player1.address);

      await expect(gpsStaking.connect(player1).unstake(player1Id))
        .to.emit(gpsStaking, "Unstaked")
        .withArgs(player1Id, STAKE_AMOUNT);

      const balanceAfter = await ethers.provider.getBalance(player1.address);
      expect(balanceAfter).to.be.gt(balanceBefore);

      const stakeInfo = await gpsStaking.getStakeInfo(player1Id);
      expect(stakeInfo.stakedAmount).to.equal(0);
    });

    it("Should claim pending rewards on unstake", async function () {
      await time.increase(1000); // Accumulate some rewards

      await gpsStaking.connect(player1).requestUnstake(player1Id);
      await time.increase(7 * 24 * 60 * 60 + 1);

      const pending = await gpsStaking.pendingRewards(player1Id);
      expect(pending).to.be.gt(0);

      await expect(gpsStaking.connect(player1).unstake(player1Id))
        .to.emit(gpsStaking, "RewardsClaimed");
    });
  });

  describe("City Staking", function () {
    const cityHash = ethers.keccak256(ethers.toUtf8Bytes("mumbai"));

    beforeEach(async function () {
      await gpsStaking.connect(player1).stake(player1Id, { value: STAKE_AMOUNT });
    });

    it("Should stake to city pool", async function () {
      await expect(
        gpsStaking.connect(player1).stakeToCity(player1Id, cityHash, {
          value: STAKE_AMOUNT,
        })
      ).to.emit(gpsStaking, "StakedToCity")
        .withArgs(player1Id, cityHash, STAKE_AMOUNT);
    });

    it("Should require main stake before city stake", async function () {
      // Player2 hasn't staked, so owner is address(0) and won't match
      await expect(
        gpsStaking.connect(player2).stakeToCity(player2Id, cityHash, {
          value: STAKE_AMOUNT,
        })
      ).to.be.revertedWithCustomError(gpsStaking, "NotStakeOwner");
    });
  });

  describe("Admin Functions", function () {
    it("Should set GPSRunner contract", async function () {
      const mockAddress = player1.address;
      await gpsStaking.setGPSRunnerContract(mockAddress);
      expect(await gpsStaking.gpsRunnerContract()).to.equal(mockAddress);
    });

    it("Should set city bonus rate", async function () {
      const cityHash = ethers.keccak256(ethers.toUtf8Bytes("mumbai"));
      const bonusRate = ethers.parseEther("0.0001");

      await expect(gpsStaking.setCityBonusRate(cityHash, bonusRate))
        .to.emit(gpsStaking, "CityBonusUpdated")
        .withArgs(cityHash, bonusRate);
    });

    it("Should set activity multipliers", async function () {
      const thresholds = [10, 50, 100];
      const multipliers = [100, 150, 200];

      await gpsStaking.setActivityMultipliers(thresholds, multipliers);
    });

    it("Should pause and unpause", async function () {
      await gpsStaking.pause();

      await expect(
        gpsStaking.connect(player1).stake(player1Id, { value: STAKE_AMOUNT })
      ).to.be.reverted;

      await gpsStaking.unpause();

      await expect(
        gpsStaking.connect(player1).stake(player1Id, { value: STAKE_AMOUNT })
      ).to.not.be.reverted;
    });

    it("Should allow emergency withdraw", async function () {
      const balanceBefore = await ethers.provider.getBalance(owner.address);

      await gpsStaking.emergencyWithdraw();

      const balanceAfter = await ethers.provider.getBalance(owner.address);
      expect(balanceAfter).to.be.gt(balanceBefore);
    });
  });
});
