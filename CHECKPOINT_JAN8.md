# GPS Runner - Development Checkpoint
**Date:** January 8, 2026
**Session:** Game Token Deployment & Production Setup

---

## What Was Completed

### 1. GameToken Smart Contracts Deployed
| Chain | Token | Address |
|-------|-------|---------|
| Mantle Sepolia | gMNT | `0x79A5B42530fDa67638ED2Ac33fa8D1eb50c6B7F7` |
| Polygon Amoy | gPOL | `0x89586D8FF2A671F5951AdCf9222ac93C52cF4DF5` |
| BNB Testnet | gBNB | `0x79A5B42530fDa67638ED2Ac33fa8D1eb50c6B7F7` |

### 2. Backend Services Created
- **Local Express backend:** `backend/` folder (for development)
- **Cloudflare Workers:** `backend-cloudflare/` folder (for production - FREE)

### 3. GitHub Actions Workflows
- `.github/workflows/deploy-backend.yml` - Auto-deploy backend on push
- `.github/workflows/build-apk.yml` - Build APK on version tags

### 4. Flutter App Updated
- `lib/services/game_token_service.dart` - Blockchain interaction for claims
- `lib/screens/wallet_screen.dart` - Claim button UI with pending/on-chain balances
- `lib/config/chain_config.dart` - GameToken addresses added

### 5. Build Status
✅ APK builds successfully (61.3MB)

---

## Next Steps To Complete

### Step 1: Deploy Cloudflare Worker
```bash
cd backend-cloudflare
npm install -g wrangler
wrangler login
npm install
wrangler deploy
wrangler secret put SIGNER_PRIVATE_KEY
# Enter: 74c9f45fd02447d63a1e766e6a24d95c5773d76f6a6c63340aca6463ef9040d9
```

### Step 2: Update Backend URL & Build
```bash
# After deploying, get your worker URL and build:
flutter build apk --release --dart-define=BACKEND_URL=https://gps-runner-api.YOUR_SUBDOMAIN.workers.dev
```

### Step 3: Setup GitHub Secrets (for auto-deploy)
Go to GitHub → Settings → Secrets → Add:
- `CLOUDFLARE_API_TOKEN` (from Cloudflare dashboard)
- `SIGNER_PRIVATE_KEY` (your deployer key)

### Step 4: Test the Full Flow
1. Run the app
2. Collect coins while walking
3. Go to Wallet → see pending balance
4. Tap "Claim" → tokens minted on-chain

---

## Key Files Reference

| File | Purpose |
|------|---------|
| `contracts/src/GameToken.sol` | ERC-20 game token contract |
| `contracts/scripts/deployGameTokens.js` | Deployment script |
| `backend/server.js` | Local Express backend |
| `backend-cloudflare/src/worker.js` | Production Cloudflare Worker |
| `lib/services/game_token_service.dart` | Flutter blockchain service |
| `lib/screens/wallet_screen.dart` | Wallet UI with claim button |

---

## To Resume This Chat

Tell Claude:
> "Continue from CHECKPOINT_JAN8 - I need to deploy the Cloudflare backend and test the claim flow"

Or just run:
```bash
cat CHECKPOINT_JAN8.md
```
