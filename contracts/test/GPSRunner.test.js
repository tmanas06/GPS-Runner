const { expect } = require("chai");
const { ethers } = require("hardhat");
const { time } = require("@nomicfoundation/hardhat-network-helpers");

describe("GPSRunner", function () {
  let gpsRunner;
  let owner, player1, player2, verifier;
  let player1Id, player2Id;
  let cityHash, landmarkHash;

  beforeEach(async function () {
    [owner, player1, player2, verifier] = await ethers.getSigners();

    const GPSRunner = await ethers.getContractFactory("GPSRunner");
    gpsRunner = await GPSRunner.deploy();
    await gpsRunner.waitForDeployment();

    // Create player IDs
    player1Id = ethers.keccak256(ethers.toUtf8Bytes("player1"));
    player2Id = ethers.keccak256(ethers.toUtf8Bytes("player2"));

    // Create city and landmark hashes
    cityHash = ethers.keccak256(ethers.toUtf8Bytes("mumbai"));
    landmarkHash = ethers.keccak256(ethers.toUtf8Bytes("gateway_of_india"));
  });

  describe("Deployment", function () {
    it("Should set the owner correctly", async function () {
      expect(await gpsRunner.owner()).to.equal(owner.address);
    });

    it("Should set owner as trusted verifier", async function () {
      expect(await gpsRunner.trustedVerifiers(owner.address)).to.be.true;
    });

    it("Should initialize with zero stats", async function () {
      expect(await gpsRunner.totalPlayers()).to.equal(0);
      expect(await gpsRunner.totalMarkers()).to.equal(0);
    });
  });

  describe("Player Registration", function () {
    it("Should register a new player", async function () {
      const color = "0x2196F3"; // Blue

      const tx = await gpsRunner.connect(player1).registerPlayer(player1Id, color);
      await expect(tx).to.emit(gpsRunner, "PlayerRegistered");

      const playerInfo = await gpsRunner.getPlayer(player1Id);
      expect(playerInfo.wallet).to.equal(player1.address);
      expect(playerInfo.color.toLowerCase()).to.equal(color.toLowerCase());
      expect(playerInfo.isActive).to.be.true;

      expect(await gpsRunner.totalPlayers()).to.equal(1);
    });

    it("Should reject duplicate player registration", async function () {
      const color = "0x2196F3";
      await gpsRunner.connect(player1).registerPlayer(player1Id, color);

      await expect(
        gpsRunner.connect(player1).registerPlayer(player1Id, color)
      ).to.be.revertedWithCustomError(gpsRunner, "PlayerAlreadyExists");
    });

    it("Should reject registration from same wallet", async function () {
      const color = "0x2196F3";
      await gpsRunner.connect(player1).registerPlayer(player1Id, color);

      const anotherId = ethers.keccak256(ethers.toUtf8Bytes("another"));
      await expect(
        gpsRunner.connect(player1).registerPlayer(anotherId, color)
      ).to.be.revertedWithCustomError(gpsRunner, "PlayerAlreadyExists");
    });

    it("Should update player color", async function () {
      const color = "0x2196F3";
      const newColor = "0xFF5722";

      await gpsRunner.connect(player1).registerPlayer(player1Id, color);

      const tx = await gpsRunner.connect(player1).updatePlayerColor(player1Id, newColor);
      await expect(tx).to.emit(gpsRunner, "PlayerUpdated");

      const playerInfo = await gpsRunner.getPlayer(player1Id);
      expect(playerInfo.color.toLowerCase()).to.equal(newColor.toLowerCase());
    });
  });

  describe("Marker Placement", function () {
    beforeEach(async function () {
      await gpsRunner.connect(player1).registerPlayer(player1Id, "0x2196F3");
    });

    it("Should place a marker", async function () {
      const lat = 19076090; // 19.076090 * 1e6
      const lon = 72877426; // 72.877426 * 1e6
      const speed = 5; // km/h

      const tx = await gpsRunner.connect(player1).placeMarker(
        player1Id,
        lat,
        lon,
        cityHash,
        landmarkHash,
        speed
      );

      const receipt = await tx.wait();
      const event = receipt.logs.find(
        log => log.fragment && log.fragment.name === "MarkerPlaced"
      );

      expect(event).to.not.be.undefined;
      expect(await gpsRunner.totalMarkers()).to.equal(1);

      const playerInfo = await gpsRunner.getPlayer(player1Id);
      expect(playerInfo.totalMarkersCount).to.equal(1);
    });

    it("Should reject invalid coordinates", async function () {
      await expect(
        gpsRunner.connect(player1).placeMarker(
          player1Id,
          100000000, // Invalid latitude (>90)
          72877426,
          cityHash,
          landmarkHash,
          5
        )
      ).to.be.revertedWithCustomError(gpsRunner, "InvalidCoordinates");
    });

    it("Should enforce cooldown between markers", async function () {
      const lat = 19076090;
      const lon = 72877426;

      await gpsRunner.connect(player1).placeMarker(
        player1Id,
        lat,
        lon,
        cityHash,
        landmarkHash,
        5
      );

      // Try to place another marker immediately
      await expect(
        gpsRunner.connect(player1).placeMarker(
          player1Id,
          lat + 100,
          lon + 100,
          cityHash,
          landmarkHash,
          5
        )
      ).to.be.revertedWithCustomError(gpsRunner, "CooldownNotMet");

      // Wait for cooldown
      await time.increase(31);

      // Should succeed now
      await expect(
        gpsRunner.connect(player1).placeMarker(
          player1Id,
          lat + 100,
          lon + 100,
          cityHash,
          landmarkHash,
          5
        )
      ).to.not.be.reverted;
    });

    it("Should track city stats", async function () {
      const lat = 19076090;
      const lon = 72877426;

      await gpsRunner.connect(player1).placeMarker(
        player1Id,
        lat,
        lon,
        cityHash,
        landmarkHash,
        5
      );

      const stats = await gpsRunner.getCityStats(cityHash);
      expect(stats.totalMarkersCount).to.equal(1);
      expect(stats.totalPlayersCount).to.equal(1);
    });

    it("Should prevent unauthorized marker placement", async function () {
      await gpsRunner.connect(player2).registerPlayer(player2Id, "0xFF5722");

      await expect(
        gpsRunner.connect(player2).placeMarker(
          player1Id, // Wrong player ID
          19076090,
          72877426,
          cityHash,
          landmarkHash,
          5
        )
      ).to.be.revertedWithCustomError(gpsRunner, "NotAuthorized");
    });
  });

  describe("Marker Verification", function () {
    let markerId;

    beforeEach(async function () {
      await gpsRunner.connect(player1).registerPlayer(player1Id, "0x2196F3");

      const tx = await gpsRunner.connect(player1).placeMarker(
        player1Id,
        19076090,
        72877426,
        cityHash,
        landmarkHash,
        5
      );

      const receipt = await tx.wait();
      const event = receipt.logs.find(
        log => log.fragment && log.fragment.name === "MarkerPlaced"
      );
      markerId = event.args[0];
    });

    it("Should verify marker by verifier", async function () {
      await gpsRunner.addVerifier(verifier.address);

      await expect(gpsRunner.connect(verifier).verifyMarker(markerId))
        .to.emit(gpsRunner, "MarkerVerified")
        .withArgs(markerId, verifier.address);

      const marker = await gpsRunner.getMarker(markerId);
      expect(marker.verified).to.be.true;
    });

    it("Should batch verify markers", async function () {
      await gpsRunner.addVerifier(verifier.address);

      // Place more markers
      await time.increase(31);
      const tx2 = await gpsRunner.connect(player1).placeMarker(
        player1Id,
        19076190,
        72877526,
        cityHash,
        landmarkHash,
        5
      );
      const receipt2 = await tx2.wait();
      const event2 = receipt2.logs.find(
        log => log.fragment && log.fragment.name === "MarkerPlaced"
      );
      const markerId2 = event2.args[0];

      await gpsRunner.connect(verifier).batchVerifyMarkers([markerId, markerId2]);

      const marker1 = await gpsRunner.getMarker(markerId);
      const marker2 = await gpsRunner.getMarker(markerId2);
      expect(marker1.verified).to.be.true;
      expect(marker2.verified).to.be.true;
    });

    it("Should reject verification from non-verifier", async function () {
      await expect(
        gpsRunner.connect(player2).verifyMarker(markerId)
      ).to.be.revertedWithCustomError(gpsRunner, "NotAuthorized");
    });
  });

  describe("Leaderboard", function () {
    beforeEach(async function () {
      await gpsRunner.connect(player1).registerPlayer(player1Id, "0x2196F3");
      await gpsRunner.connect(player2).registerPlayer(player2Id, "0xFF5722");
    });

    it("Should update leaderboard when placing markers", async function () {
      // Player 1 places a marker
      await gpsRunner.connect(player1).placeMarker(
        player1Id,
        19076090,
        72877426,
        cityHash,
        landmarkHash,
        5
      );

      let leaderboard = await gpsRunner.getCityLeaderboard(cityHash, 10);
      expect(leaderboard.playerIds[0]).to.equal(player1Id);
      expect(leaderboard.markerCounts[0]).to.equal(1);

      // Player 2 places two markers
      await gpsRunner.connect(player2).placeMarker(
        player2Id,
        19076190,
        72877526,
        cityHash,
        landmarkHash,
        5
      );

      await time.increase(31);

      await gpsRunner.connect(player2).placeMarker(
        player2Id,
        19076290,
        72877626,
        cityHash,
        landmarkHash,
        5
      );

      leaderboard = await gpsRunner.getCityLeaderboard(cityHash, 10);
      expect(leaderboard.playerIds[0]).to.equal(player2Id);
      expect(leaderboard.markerCounts[0]).to.equal(2);
      expect(leaderboard.playerIds[1]).to.equal(player1Id);
      expect(leaderboard.markerCounts[1]).to.equal(1);
    });
  });

  describe("Admin Functions", function () {
    it("Should add and remove verifiers", async function () {
      await expect(gpsRunner.addVerifier(verifier.address))
        .to.emit(gpsRunner, "VerifierAdded")
        .withArgs(verifier.address);

      expect(await gpsRunner.trustedVerifiers(verifier.address)).to.be.true;

      await expect(gpsRunner.removeVerifier(verifier.address))
        .to.emit(gpsRunner, "VerifierRemoved")
        .withArgs(verifier.address);

      expect(await gpsRunner.trustedVerifiers(verifier.address)).to.be.false;
    });

    it("Should pause and unpause", async function () {
      await gpsRunner.pause();

      await gpsRunner.connect(player1).registerPlayer(player1Id, "0x2196F3")
        .catch(() => {}); // Should fail when paused

      await gpsRunner.unpause();

      await expect(
        gpsRunner.connect(player1).registerPlayer(player1Id, "0x2196F3")
      ).to.not.be.reverted;
    });

    it("Should only allow owner to admin functions", async function () {
      await expect(
        gpsRunner.connect(player1).addVerifier(verifier.address)
      ).to.be.revertedWithCustomError(gpsRunner, "OwnableUnauthorizedAccount");
    });
  });

  describe("Anti-Cheat", function () {
    beforeEach(async function () {
      await gpsRunner.connect(player1).registerPlayer(player1Id, "0x2196F3");
    });

    it("Should reject impossibly fast movement", async function () {
      // Place first marker
      await gpsRunner.connect(player1).placeMarker(
        player1Id,
        19076090, // Mumbai
        72877426,
        cityHash,
        landmarkHash,
        5
      );

      await time.increase(31); // Just past cooldown

      // Try to place marker very far away (impossible speed)
      await expect(
        gpsRunner.connect(player1).placeMarker(
          player1Id,
          28613939, // Delhi (~1200km away)
          77209023,
          cityHash,
          landmarkHash,
          5
        )
      ).to.be.revertedWithCustomError(gpsRunner, "SpeedTooHigh");
    });

    it("Should allow reasonable movement speed", async function () {
      // Place first marker
      await gpsRunner.connect(player1).placeMarker(
        player1Id,
        19076090,
        72877426,
        cityHash,
        landmarkHash,
        5
      );

      await time.increase(3600); // Wait 1 hour

      // Move ~50km (reasonable for 1 hour)
      await expect(
        gpsRunner.connect(player1).placeMarker(
          player1Id,
          19526090, // ~50km north
          72877426,
          cityHash,
          landmarkHash,
          50
        )
      ).to.not.be.reverted;
    });
  });
});
