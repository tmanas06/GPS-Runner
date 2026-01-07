import { ethers } from "ethers";

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

const SIGNATURE_EXPIRY = 60 * 60; // 1 hour

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type",
};

function jsonResponse(data, status = 200) {
  return new Response(JSON.stringify(data), {
    status,
    headers: { "Content-Type": "application/json", ...corsHeaders },
  });
}

export default {
  async fetch(request, env) {
    if (request.method === "OPTIONS") {
      return new Response(null, { headers: corsHeaders });
    }

    const url = new URL(request.url);

    try {
      // Health check
      if (url.pathname === "/" || url.pathname === "/health") {
        const signer = env.SIGNER_PRIVATE_KEY
          ? new ethers.Wallet(env.SIGNER_PRIVATE_KEY)
          : null;
        return jsonResponse({
          status: "ok",
          service: "GPS Runner API (Cloudflare)",
          signerAddress: signer?.address,
          chains: Object.values(CHAINS).map(c => c.name),
        });
      }

      // Get chains
      if (url.pathname === "/api/chains") {
        return jsonResponse(CHAINS);
      }

      // Sign claim
      if (url.pathname === "/api/claim/sign" && request.method === "POST") {
        const body = await request.json();
        const { player, amount, coinSymbol, chainId } = body;

        // Validate inputs
        if (!player || !ethers.isAddress(player)) {
          return jsonResponse({ error: "Invalid player address" }, 400);
        }
        if (!amount || BigInt(amount) <= 0n) {
          return jsonResponse({ error: "Invalid amount" }, 400);
        }
        if (!chainId || !CHAINS[chainId]) {
          return jsonResponse({
            error: "Unsupported chain",
            supported: Object.keys(CHAINS)
          }, 400);
        }

        const chain = CHAINS[chainId];

        // Create signer
        if (!env.SIGNER_PRIVATE_KEY) {
          return jsonResponse({ error: "Signer not configured" }, 500);
        }
        const signer = new ethers.Wallet(env.SIGNER_PRIVATE_KEY);

        // Generate unique claim ID
        const claimId = ethers.id(crypto.randomUUID());

        // Set expiry (1 hour from now)
        const expiry = Math.floor(Date.now() / 1000) + SIGNATURE_EXPIRY;

        // Create message hash (must match contract)
        const messageHash = ethers.solidityPackedKeccak256(
          ["address", "uint256", "bytes32", "uint256", "uint256", "address"],
          [player, amount, claimId, expiry, chainId, chain.gameToken]
        );

        // Sign the message
        const signature = await signer.signMessage(ethers.getBytes(messageHash));

        console.log(`Signed claim: ${player} for ${amount} ${chain.symbol}`);

        return jsonResponse({
          success: true,
          claimId,
          expiry,
          signature,
          amount: amount.toString(),
          chainId,
          tokenAddress: chain.gameToken,
          symbol: chain.symbol,
        });
      }

      return jsonResponse({ error: "Not found" }, 404);
    } catch (error) {
      console.error("Error:", error);
      return jsonResponse({ error: error.message }, 500);
    }
  },
};
