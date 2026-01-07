import 'package:isar/isar.dart';

part 'staked_marker.g.dart';

/// Local tracking of staked markers for offline-first sync
@collection
class StakedMarkerLocal {
  Id id = Isar.autoIncrement;

  @Index()
  late int markerId;

  @Index()
  late String landmarkHash;

  late String landmarkName;
  late String cityHash;
  late String cityName;

  @Index()
  late DateTime stakedAt;

  late double accumulatedYieldETH;
  late DateTime lastClaimTime;

  @Index()
  late bool isSynced;

  late String txHash;

  StakedMarkerLocal();

  factory StakedMarkerLocal.create({
    required int markerId,
    required String landmarkHash,
    required String landmarkName,
    required String cityHash,
    required String cityName,
  }) {
    return StakedMarkerLocal()
      ..markerId = markerId
      ..landmarkHash = landmarkHash
      ..landmarkName = landmarkName
      ..cityHash = cityHash
      ..cityName = cityName
      ..stakedAt = DateTime.now()
      ..accumulatedYieldETH = 0
      ..lastClaimTime = DateTime.now()
      ..isSynced = false
      ..txHash = '';
  }

  /// Check if unstake cooldown is met (7 days)
  bool get canUnstake {
    return DateTime.now().difference(stakedAt).inDays >= 7;
  }

  /// Time until can unstake
  @ignore
  Duration get timeUntilUnstake {
    final cooldownEnd = stakedAt.add(const Duration(days: 7));
    final remaining = cooldownEnd.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }
}

/// Yield token tracking for ERC-1155 tokens
@collection
class YieldTokenLocal {
  Id id = Isar.autoIncrement;

  @Index()
  late String tokenId;

  late String landmarkHash;
  late String landmarkName;
  late String cityHash;
  late String cityName;
  late double balance;
  late double pendingYield;

  @Index()
  late DateTime mintedAt;

  late bool isSynced;
  late String mintTxHash;

  YieldTokenLocal();

  factory YieldTokenLocal.create({
    required String tokenId,
    required String landmarkHash,
    required String landmarkName,
    required String cityHash,
    required String cityName,
    required double balance,
  }) {
    return YieldTokenLocal()
      ..tokenId = tokenId
      ..landmarkHash = landmarkHash
      ..landmarkName = landmarkName
      ..cityHash = cityHash
      ..cityName = cityName
      ..balance = balance
      ..pendingYield = 0
      ..mintedAt = DateTime.now()
      ..isSynced = false
      ..mintTxHash = '';
  }
}

/// RUN token balance tracking
@collection
class RUNBalanceLocal {
  Id id = Isar.autoIncrement;

  late double balance;
  late double stakedBalance;
  late double pendingLPYield;
  late DateTime lastUpdated;

  // Active boost
  late int boostMultiplier; // 100 = 1x, 120 = 1.2x
  DateTime? boostExpiresAt;

  // Stats
  late double totalBurned;
  late double totalEarned;

  RUNBalanceLocal();

  factory RUNBalanceLocal.create({double balance = 0}) {
    return RUNBalanceLocal()
      ..balance = balance
      ..stakedBalance = 0
      ..pendingLPYield = 0
      ..lastUpdated = DateTime.now()
      ..boostMultiplier = 100
      ..boostExpiresAt = null
      ..totalBurned = 0
      ..totalEarned = 0;
  }

  bool get hasActiveBoost =>
      boostExpiresAt != null && DateTime.now().isBefore(boostExpiresAt!);

  double get effectiveMultiplier => hasActiveBoost ? boostMultiplier / 100 : 1.0;

  @ignore
  Duration? get boostTimeRemaining {
    if (boostExpiresAt == null) return null;
    final remaining = boostExpiresAt!.difference(DateTime.now());
    return remaining.isNegative ? null : remaining;
  }
}

/// Governance vote tracking
@collection
class GovernanceVoteLocal {
  Id id = Isar.autoIncrement;

  @Index()
  late int proposalId;

  late String proposalType; // 'landmark', 'city', 'parameter'
  late String description;

  @Index()
  late bool votedFor; // true = for, false = against

  late double voteWeight;
  late DateTime votedAt;
  late String txHash;

  @Index()
  late bool isSynced;

  GovernanceVoteLocal();

  factory GovernanceVoteLocal.create({
    required int proposalId,
    required String proposalType,
    required String description,
    required bool votedFor,
    required double voteWeight,
  }) {
    return GovernanceVoteLocal()
      ..proposalId = proposalId
      ..proposalType = proposalType
      ..description = description
      ..votedFor = votedFor
      ..voteWeight = voteWeight
      ..votedAt = DateTime.now()
      ..txHash = ''
      ..isSynced = false;
  }
}

/// Yield claim history
@collection
class YieldClaimLocal {
  Id id = Isar.autoIncrement;

  @Index()
  late String claimType; // 'landmark_yield', 'staking_yield', 'lp_yield'

  late String sourceId; // tokenId or 'staking' or 'lp'
  late double amount;
  late String currency; // 'ETH', 'MNT'

  @Index()
  late DateTime claimedAt;

  late String txHash;
  late bool isSynced;

  YieldClaimLocal();

  factory YieldClaimLocal.create({
    required String claimType,
    required String sourceId,
    required double amount,
    required String currency,
  }) {
    return YieldClaimLocal()
      ..claimType = claimType
      ..sourceId = sourceId
      ..amount = amount
      ..currency = currency
      ..claimedAt = DateTime.now()
      ..txHash = ''
      ..isSynced = false;
  }
}

/// Game token balance for each chain (gMNT, gPOL, gBNB)
@collection
class GameCoinBalance {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String coinSymbol; // 'gMNT', 'gPOL', 'gBNB'

  late String chainName; // 'Mantle', 'Polygon', 'BNB'
  late double balance;
  late double pendingClaim; // Unclaimed tokens to be minted on-chain
  late DateTime lastUpdated;

  GameCoinBalance();

  factory GameCoinBalance.create({
    required String coinSymbol,
    required String chainName,
    double balance = 0,
  }) {
    return GameCoinBalance()
      ..coinSymbol = coinSymbol
      ..chainName = chainName
      ..balance = balance
      ..pendingClaim = 0
      ..lastUpdated = DateTime.now();
  }
}

/// Individual coin collection event (for history)
@collection
class CollectedCoinEvent {
  Id id = Isar.autoIncrement;

  @Index()
  late String coinSymbol; // 'gMNT', 'gPOL', 'gBNB'

  late double amount;
  late double latitude;
  late double longitude;

  @Index()
  late DateTime collectedAt;

  late bool claimedOnChain;
  late String txHash;

  CollectedCoinEvent();

  factory CollectedCoinEvent.create({
    required String coinSymbol,
    required double amount,
    required double latitude,
    required double longitude,
  }) {
    return CollectedCoinEvent()
      ..coinSymbol = coinSymbol
      ..amount = amount
      ..latitude = latitude
      ..longitude = longitude
      ..collectedAt = DateTime.now()
      ..claimedOnChain = false
      ..txHash = '';
  }
}

/// Yield estimate snapshot for analytics
@collection
class YieldSnapshotLocal {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime snapshotDate;

  late int totalStakedMarkers;
  late double totalPendingYield;
  late double currentAPY;
  late int leaderboardRank;
  late double multiplier;

  late double runBalance;
  late double runStaked;

  late int yieldTokenCount;
  late double totalYieldTokenBalance;

  YieldSnapshotLocal();

  factory YieldSnapshotLocal.createSnapshot({
    required int totalStakedMarkers,
    required double totalPendingYield,
    required double currentAPY,
    required int leaderboardRank,
    required double multiplier,
    required double runBalance,
    required double runStaked,
    required int yieldTokenCount,
    required double totalYieldTokenBalance,
  }) {
    return YieldSnapshotLocal()
      ..snapshotDate = DateTime.now()
      ..totalStakedMarkers = totalStakedMarkers
      ..totalPendingYield = totalPendingYield
      ..currentAPY = currentAPY
      ..leaderboardRank = leaderboardRank
      ..multiplier = multiplier
      ..runBalance = runBalance
      ..runStaked = runStaked
      ..yieldTokenCount = yieldTokenCount
      ..totalYieldTokenBalance = totalYieldTokenBalance;
  }
}
