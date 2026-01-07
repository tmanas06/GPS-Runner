require("dotenv").config();
const express = require("express");
const cors = require("cors");
const { ethers } = require("ethers");
const { v4: uuidv4 } = require("uuid");

const app = express();
app.use(cors());
app.use(express.json());

// Chain configurations with GameToken addresses
const CHAINS = {
  5003: {
    name: "Mantle Sepolia",
    gameToken: "0x79A5B42530fDa67638ED2Ac33fa8D1eb50c6B7F7",
    symbol: "gMNT",
  },
  80002: {
    name: "Polygon Amoy",
    gameToken: "0x89586D8FF2A671F5951AdCf9222ac93C52cF4DF5",
    symbol: "gPOL",
  },
  97: {
    name: "BNB Testnet",
    gameToken: "0x79A5B42530fDa67638ED2Ac33fa8D1eb50c6B7F7",
    symbol: "gBNB",
  },
};

// Signer wallet (same key used for deployment - is authorized signer)
const SIGNER_PRIVATE_KEY = process.env.SIGNER_PRIVATE_KEY;
const signer = SIGNER_PRIVATE_KEY ? new ethers.Wallet(SIGNER_PRIVATE_KEY) : null;

// Store pending claims (in production, use a database)
const pendingClaims = new Map();

// Signature expiry time (1 hour)
const SIGNATURE_EXPIRY = 60 * 60;

/**
 * Sign a claim request for the GameToken contract
 */
async function signClaim(player, amount, chainId) {
  if (!signer) {
    throw new Error("Signer not configured");
  }

  const chain = CHAINS[chainId];
  if (!chain) {
    throw new Error(`Unsupported chain: ${chainId}`);
  }

  // Generate unique claim ID
  const claimId = ethers.id(uuidv4());

  // Set expiry to 1 hour from now
  const expiry = Math.floor(Date.now() / 1000) + SIGNATURE_EXPIRY;

  // Create the message hash (must match contract's verification)
  const messageHash = ethers.solidityPackedKeccak256(
    ["address", "uint256", "bytes32", "uint256", "uint256", "address"],
    [player, amount, claimId, expiry, chainId, chain.gameToken]
  );

  // Sign the message
  const signature = await signer.signMessage(ethers.getBytes(messageHash));

  return {
    claimId,
    expiry,
    signature,
    chainId,
    tokenAddress: chain.gameToken,
    symbol: chain.symbol,
  };
}

// Health check
app.get("/", (req, res) => {
  res.json({
    status: "ok",
    service: "GPS Runner Backend",
    signerConfigured: !!signer,
    signerAddress: signer?.address,
  });
});

// Get supported chains
app.get("/api/chains", (req, res) => {
  res.json(CHAINS);
});

// Request claim signature
app.post("/api/claim/sign", async (req, res) => {
  try {
    const { player, amount, coinSymbol, chainId } = req.body;

    // Validate inputs
    if (!player || !ethers.isAddress(player)) {
      return res.status(400).json({ error: "Invalid player address" });
    }

    if (!amount || BigInt(amount) <= 0) {
      return res.status(400).json({ error: "Invalid amount" });
    }

    if (!chainId || !CHAINS[chainId]) {
      return res.status(400).json({
        error: "Unsupported chain",
        supportedChains: Object.keys(CHAINS)
      });
    }

    // Verify coin symbol matches chain
    const chain = CHAINS[chainId];
    if (coinSymbol && coinSymbol !== chain.symbol) {
      return res.status(400).json({
        error: `Invalid coin symbol for chain. Expected ${chain.symbol}`
      });
    }

    console.log(`Signing claim for ${player} on ${chain.name}: ${amount} wei`);

    // Sign the claim
    const claimData = await signClaim(player, amount, chainId);

    // Store pending claim (for verification)
    pendingClaims.set(claimData.claimId, {
      player,
      amount,
      chainId,
      createdAt: Date.now(),
      ...claimData,
    });

    res.json({
      success: true,
      ...claimData,
      amount: amount.toString(),
    });

  } catch (error) {
    console.error("Error signing claim:", error);
    res.status(500).json({ error: error.message });
  }
});

// Verify a claim (for debugging)
app.post("/api/claim/verify", async (req, res) => {
  try {
    const { claimId } = req.body;

    const claim = pendingClaims.get(claimId);
    if (!claim) {
      return res.status(404).json({ error: "Claim not found" });
    }

    const isExpired = Math.floor(Date.now() / 1000) > claim.expiry;

    res.json({
      ...claim,
      isExpired,
      signerAddress: signer?.address,
    });

  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get player's pending claims
app.get("/api/claims/:player", (req, res) => {
  const { player } = req.params;
  const playerClaims = [];

  for (const [id, claim] of pendingClaims) {
    if (claim.player.toLowerCase() === player.toLowerCase()) {
      playerClaims.push(claim);
    }
  }

  res.json(playerClaims);
});

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`GPS Runner Backend running on port ${PORT}`);
  console.log(`Signer address: ${signer?.address || "NOT CONFIGURED"}`);
  console.log(`Supported chains: ${Object.values(CHAINS).map(c => c.name).join(", ")}`);
});
