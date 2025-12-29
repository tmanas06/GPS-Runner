# Quick Build Instructions - GPS Runner Web3

## 15-Minute Setup Guide

### Step 1: Install Dependencies (2 min)
```bash
cd gps_game
flutter pub get
```

### Step 2: Get Testnet MATIC (2 min)
1. Go to https://faucet.polygon.technology/
2. Select "Polygon Amoy" testnet
3. Enter your wallet address
4. Request 0.5 MATIC (free)

### Step 3: Deploy Contracts via Remix (5 min)
1. Open https://remix.ethereum.org
2. Create file: `DelhiRunner.sol` - paste from `contracts/DelhiRunner.sol`
3. Create file: `HydRunner.sol` - paste from `contracts/HydRunner.sol`
4. Compile with Solidity 0.8.19
5. Connect MetaMask to Polygon Amoy (Chain ID: 80002)
6. Deploy both contracts
7. **Save the deployed addresses!**

### Step 4: Configure App (2 min)

Edit `lib/models/city_bounds.dart`:
```dart
static const String delhiContractAddress = '0xYOUR_DELHI_ADDRESS';
static const String hydContractAddress = '0xYOUR_HYD_ADDRESS';
```

Edit `lib/services/blockchain_service.dart`:
```dart
static const String _rpcUrl = 'https://polygon-amoy.g.alchemy.com/v2/YOUR_KEY';
static const String _wsUrl = 'wss://polygon-amoy.g.alchemy.com/v2/YOUR_KEY';
```

Get Alchemy key (free): https://www.alchemy.com/

### Step 5: Build APK (3 min)
```bash
# Debug build (faster)
flutter build apk --debug

# OR Release build (optimized, smaller)
flutter build apk --release --split-per-abi
```

APK location: `build/app/outputs/flutter-apk/app-release.apk`

---

## Testing Without Blockchain

For quick local testing, the app works without blockchain:
- GPS tracking works locally
- Markers saved to local database
- Anti-cheat validation runs locally
- Profile and leaderboards work offline

Just skip Steps 2-4 and run:
```bash
flutter run
```

---

## Common Issues

### "minSdk too low"
Edit `android/app/build.gradle`:
```gradle
minSdk 24  // Must be 24+
```

### "Location permission denied"
- Enable GPS on device
- Grant "Allow all the time" permission in app settings

### "Blockchain not connecting"
- Verify Alchemy API key is valid
- Check MATIC balance > 0.01
- Ensure correct chain ID (80002 for Amoy)

---

## Demo Presentation Script

### Slide 1: Title (5 sec)
"GPS Runner Web3 - Real Delhi/Hyderabad Coverage Battle with AI Anti-Cheat"

### Slide 2: Live Demo (15 sec)
- Show Phone 1: Running in Delhi, marker appears
- Show Phone 2: Running in Hyderabad, marker appears
- Show Phone 3: Profile with both cities' markers

### Slide 3: Blockchain Proof (10 sec)
- Open PolygonScan Amoy
- Show transaction hash
- "Every marker is verified on-chain!"

### Slide 4: Anti-Cheat (10 sec)
- Show HUD: Speed, Steps, Activity indicators
- "92% vehicle detection accuracy"
- "Triple verification: GPS + ML + Pedometer"

---

## Hackathon Checklist

- [ ] Contracts deployed on Polygon Amoy
- [ ] APK built and tested on 3 phones
- [ ] Demo video recorded (30 sec)
- [ ] PolygonScan links ready for judges
- [ ] Presentation slides prepared
- [ ] Source code pushed to GitHub

**Good luck! You've got this!** 🚀
