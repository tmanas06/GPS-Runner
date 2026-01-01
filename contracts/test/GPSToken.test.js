const { expect } = require("chai");
const { ethers } = require("hardhat");
const { time } = require("@nomicfoundation/hardhat-network-helpers");

describe("GPSToken", function () {
  let gpsToken;
  let owner, treasury, minter, user1, user2;

  const INITIAL_SUPPLY = ethers.parseEther("100000000"); // 100 million
  const MAX_SUPPLY = ethers.parseEther("1000000000"); // 1 billion
  const MINTER_LIMIT = ethers.parseEther("10000000"); // 10 million

  beforeEach(async function () {
    [owner, treasury, minter, user1, user2] = await ethers.getSigners();

    const GPSToken = await ethers.getContractFactory("GPSToken");
    gpsToken = await GPSToken.deploy(treasury.address);
    await gpsToken.waitForDeployment();
  });

  describe("Deployment", function () {
    it("Should set correct name and symbol", async function () {
      expect(await gpsToken.name()).to.equal("GPS Runner Token");
      expect(await gpsToken.symbol()).to.equal("GPSR");
    });

    it("Should mint initial supply to treasury", async function () {
      expect(await gpsToken.balanceOf(treasury.address)).to.equal(INITIAL_SUPPLY);
    });

    it("Should set correct max supply", async function () {
      expect(await gpsToken.MAX_SUPPLY()).to.equal(MAX_SUPPLY);
    });

    it("Should set owner correctly", async function () {
      expect(await gpsToken.owner()).to.equal(owner.address);
    });
  });

  describe("Minting", function () {
    beforeEach(async function () {
      await gpsToken.addMinter(minter.address, MINTER_LIMIT);
    });

    it("Should allow minter to mint", async function () {
      const mintAmount = ethers.parseEther("1000");

      await gpsToken.connect(minter).mint(user1.address, mintAmount);

      expect(await gpsToken.balanceOf(user1.address)).to.equal(mintAmount);
    });

    it("Should track minter stats", async function () {
      const mintAmount = ethers.parseEther("1000");

      await gpsToken.connect(minter).mint(user1.address, mintAmount);

      const minterInfo = await gpsToken.getMinterInfo(minter.address);
      expect(minterInfo.isMinter).to.be.true;
      expect(minterInfo.minted).to.equal(mintAmount);
      expect(minterInfo.remaining).to.equal(MINTER_LIMIT - mintAmount);
    });

    it("Should reject mint from non-minter", async function () {
      await expect(
        gpsToken.connect(user1).mint(user2.address, ethers.parseEther("100"))
      ).to.be.revertedWithCustomError(gpsToken, "NotMinter");
    });

    it("Should reject mint exceeding limit", async function () {
      const overLimit = MINTER_LIMIT + ethers.parseEther("1");

      await expect(
        gpsToken.connect(minter).mint(user1.address, overLimit)
      ).to.be.revertedWithCustomError(gpsToken, "ExceedsMinterLimit");
    });

    it("Should use mintReward function", async function () {
      const rewardAmount = ethers.parseEther("500");

      await gpsToken.connect(minter).mintReward(user1.address, rewardAmount);

      expect(await gpsToken.balanceOf(user1.address)).to.equal(rewardAmount);
    });
  });

  describe("Minter Management", function () {
    it("Should add minter", async function () {
      await expect(gpsToken.addMinter(minter.address, MINTER_LIMIT))
        .to.emit(gpsToken, "MinterAdded")
        .withArgs(minter.address, MINTER_LIMIT);

      expect(await gpsToken.minters(minter.address)).to.be.true;
    });

    it("Should remove minter", async function () {
      await gpsToken.addMinter(minter.address, MINTER_LIMIT);

      await expect(gpsToken.removeMinter(minter.address))
        .to.emit(gpsToken, "MinterRemoved")
        .withArgs(minter.address);

      expect(await gpsToken.minters(minter.address)).to.be.false;
    });

    it("Should update minter limit", async function () {
      await gpsToken.addMinter(minter.address, MINTER_LIMIT);

      const newLimit = MINTER_LIMIT * 2n;
      await expect(gpsToken.updateMinterLimit(minter.address, newLimit))
        .to.emit(gpsToken, "MinterLimitUpdated")
        .withArgs(minter.address, newLimit);

      const info = await gpsToken.getMinterInfo(minter.address);
      expect(info.limit).to.equal(newLimit);
    });

    it("Should reject zero address as minter", async function () {
      await expect(
        gpsToken.addMinter(ethers.ZeroAddress, MINTER_LIMIT)
      ).to.be.revertedWithCustomError(gpsToken, "ZeroAddress");
    });
  });

  describe("Owner Minting", function () {
    it("Should allow owner to mint", async function () {
      const amount = ethers.parseEther("1000000");

      await gpsToken.ownerMint(user1.address, amount);

      expect(await gpsToken.balanceOf(user1.address)).to.equal(amount);
    });

    it("Should reject owner mint exceeding max supply", async function () {
      const remainingSupply = await gpsToken.remainingMintableSupply();
      const overMax = remainingSupply + ethers.parseEther("1");

      await expect(
        gpsToken.ownerMint(user1.address, overMax)
      ).to.be.revertedWithCustomError(gpsToken, "ExceedsMaxSupply");
    });
  });

  describe("Burning", function () {
    beforeEach(async function () {
      // Transfer some tokens to user1
      await gpsToken.connect(treasury).transfer(user1.address, ethers.parseEther("1000"));
    });

    it("Should allow burning own tokens", async function () {
      const burnAmount = ethers.parseEther("100");
      const balanceBefore = await gpsToken.balanceOf(user1.address);

      await gpsToken.connect(user1).burn(burnAmount);

      expect(await gpsToken.balanceOf(user1.address)).to.equal(
        balanceBefore - burnAmount
      );
    });

    it("Should allow burnFrom with approval", async function () {
      const burnAmount = ethers.parseEther("100");

      await gpsToken.connect(user1).approve(user2.address, burnAmount);
      await gpsToken.connect(user2).burnFrom(user1.address, burnAmount);

      expect(await gpsToken.balanceOf(user1.address)).to.equal(
        ethers.parseEther("900")
      );
    });
  });

  describe("ERC20 Permit", function () {
    it("Should support permit", async function () {
      const value = ethers.parseEther("100");
      const blockTime = await time.latest();
      const deadline = blockTime + 3600;

      // Get nonce
      const nonce = await gpsToken.nonces(treasury.address);

      // Create permit signature
      const domain = {
        name: "GPS Runner Token",
        version: "1",
        chainId: (await ethers.provider.getNetwork()).chainId,
        verifyingContract: await gpsToken.getAddress(),
      };

      const types = {
        Permit: [
          { name: "owner", type: "address" },
          { name: "spender", type: "address" },
          { name: "value", type: "uint256" },
          { name: "nonce", type: "uint256" },
          { name: "deadline", type: "uint256" },
        ],
      };

      const message = {
        owner: treasury.address,
        spender: user1.address,
        value: value,
        nonce: nonce,
        deadline: deadline,
      };

      const signature = await treasury.signTypedData(domain, types, message);
      const { v, r, s } = ethers.Signature.from(signature);

      // Execute permit
      await gpsToken.permit(
        treasury.address,
        user1.address,
        value,
        deadline,
        v,
        r,
        s
      );

      expect(await gpsToken.allowance(treasury.address, user1.address)).to.equal(value);
    });
  });

  describe("View Functions", function () {
    it("Should return remaining mintable supply", async function () {
      const remaining = await gpsToken.remainingMintableSupply();
      expect(remaining).to.equal(MAX_SUPPLY - INITIAL_SUPPLY);
    });

    it("Should return correct minter info", async function () {
      await gpsToken.addMinter(minter.address, MINTER_LIMIT);

      const info = await gpsToken.getMinterInfo(minter.address);
      expect(info.isMinter).to.be.true;
      expect(info.limit).to.equal(MINTER_LIMIT);
      expect(info.minted).to.equal(0);
      expect(info.remaining).to.equal(MINTER_LIMIT);
    });
  });
});
