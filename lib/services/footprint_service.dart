import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/chain_config.dart';

/// Footprint Analytics Service for GPS Runner Game
/// Uses Footprint's SQL Query API for on-chain analytics
/// Multi-chain support: dynamically uses chain config
class FootprintService extends ChangeNotifier {
  static final FootprintService _instance = FootprintService._internal();
  factory FootprintService() => _instance;
  FootprintService._internal();

  // API Configuration - Footprint uses SQL query API
  static const String _baseUrl = 'https://api.footprint.network/api/v2';
  static const String _apiKey = 'tZVhYmESz2v6RS4yAEpZZVUE3tC/3jvB3I7oHY8UEid8z5CsufNwpCJnf2u1WM9U';

  // Current chain configuration
  ChainConfig _currentChain = SupportedChains.defaultChain;

  // Dynamic getters for contract addresses
  String get _indiaRunnerAddress => _currentChain.indiaRunnerAddress ?? '';
  String get _landmarkYieldAddress => _currentChain.landmarkYieldAddress ?? '';
  String get _markerStakingAddress => _currentChain.markerStakingAddress ?? '';
  String get _runTokenAddress => _currentChain.runTokenAddress ?? '';
  String get _governanceAddress => _currentChain.governanceAddress ?? '';

  // Chain name for Footprint queries
  String get _chain => _getFootprintChainName(_currentChain.type);
  int get _chainId => _currentChain.chainId;

  // Map chain types to Footprint chain names
  String _getFootprintChainName(ChainType type) {
    switch (type) {
      case ChainType.mantleSepolia:
        return 'Mantle Sepolia';
      case ChainType.mantleMainnet:
        return 'Mantle';
      case ChainType.polygonAmoy:
        return 'Polygon Amoy';
      case ChainType.polygonMainnet:
        return 'Polygon';
      case ChainType.bnbTestnet:
        return 'BSC Testnet';
      case ChainType.bnbMainnet:
        return 'BSC';
    }
  }

  // Public getter for current chain
  ChainConfig get currentChain => _currentChain;
  String get chainName => _currentChain.name;

  // Cache
  GameStats? _gameStats;
  NFTStats? _nftStats;
  List<NFTTransaction> _recentTransactions = [];
  PlayerAnalytics? _playerAnalytics;
  List<TokenBalance> _walletBalances = [];
  bool _isLoading = false;
  String? _error;
  DateTime? _lastFetch;

  // Getters
  GameStats? get gameStats => _gameStats;
  NFTStats? get nftStats => _nftStats;
  List<NFTTransaction> get recentTransactions => List.unmodifiable(_recentTransactions);
  PlayerAnalytics? get playerAnalytics => _playerAnalytics;
  List<TokenBalance> get walletBalances => List.unmodifiable(_walletBalances);
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Rate limiting for free tier
  static const Duration _minFetchInterval = Duration(minutes: 1);

  bool get canFetch {
    if (_lastFetch == null) return true;
    return DateTime.now().difference(_lastFetch!) > _minFetchInterval;
  }

  /// Switch to a different chain for analytics
  void switchChain(ChainType chainType) {
    _currentChain = SupportedChains.getByType(chainType);
    clearCache();
    debugPrint('FootprintService switched to ${_currentChain.name}');
  }

  /// Execute SQL query against Footprint API
  Future<Map<String, dynamic>?> _executeQuery(String sql) async {
    try {
      debugPrint('Footprint Query: $sql');

      final response = await http.post(
        Uri.parse('$_baseUrl/query'),
        headers: {
          'Content-Type': 'application/json',
          'api-key': _apiKey,
        },
        body: jsonEncode({
          'query': sql,
        }),
      );

      debugPrint('Footprint Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        debugPrint('Footprint API Error: ${response.body}');
        _error = 'API Error: ${response.statusCode}';
        return null;
      }
    } catch (e) {
      debugPrint('Footprint Query Error: $e');
      _error = 'Network error: $e';
      return null;
    }
  }

  // ============ GameFi Protocol Stats ============

  /// Get GameFi protocol daily stats using gamefi_protocol_daily_stats table
  Future<GameStats?> getGameStats({int days = 30}) async {
    if (!canFetch && _gameStats != null) {
      return _gameStats;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Query gamefi_protocol_daily_stats for our contract
      final sql = '''
        SELECT
          day,
          active_users,
          new_users,
          total_users,
          transactions,
          volume_usd
        FROM gamefi_protocol_daily_stats
        WHERE chain = '$_chain'
          AND contract_address = LOWER('$_indiaRunnerAddress')
        ORDER BY day DESC
        LIMIT $days
      ''';

      final result = await _executeQuery(sql);

      if (result != null && result['data'] != null) {
        _gameStats = GameStats.fromFootprintData(result['data']);
        _lastFetch = DateTime.now();
      } else {
        // Fallback to mock data for testing
        debugPrint('Using mock GameStats data');
        _gameStats = GameStats.mock();
      }
    } catch (e) {
      _error = 'Failed to fetch game stats: $e';
      _gameStats = GameStats.mock();
    }

    _isLoading = false;
    notifyListeners();
    return _gameStats;
  }

  /// Get protocol info using protocol_info table
  Future<Map<String, dynamic>?> getProtocolInfo() async {
    final sql = '''
      SELECT *
      FROM protocol_info
      WHERE chain = '$_chain'
        AND contract_address = LOWER('$_indiaRunnerAddress')
      LIMIT 1
    ''';

    return await _executeQuery(sql);
  }

  // ============ NFT Analytics ============

  /// Get NFT collection stats using nft_collection_daily_stats
  Future<NFTStats?> getNFTStats({int days = 7}) async {
    if (!canFetch && _nftStats != null) {
      return _nftStats;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final sql = '''
        SELECT
          day,
          floor_price,
          volume,
          sales,
          holders,
          total_supply,
          market_cap
        FROM nft_collection_daily_stats
        WHERE chain = '$_chain'
          AND collection_contract_address = LOWER('$_landmarkYieldAddress')
        ORDER BY day DESC
        LIMIT $days
      ''';

      final result = await _executeQuery(sql);

      if (result != null && result['data'] != null) {
        _nftStats = NFTStats.fromFootprintData(result['data']);
        _lastFetch = DateTime.now();
      } else {
        debugPrint('Using mock NFTStats data');
        _nftStats = NFTStats.mock();
      }
    } catch (e) {
      _error = 'Failed to fetch NFT stats: $e';
      _nftStats = NFTStats.mock();
    }

    _isLoading = false;
    notifyListeners();
    return _nftStats;
  }

  /// Get NFT collection info using nft_collection_info
  Future<Map<String, dynamic>?> getNFTCollectionInfo() async {
    final sql = '''
      SELECT *
      FROM nft_collection_info
      WHERE chain = '$_chain'
        AND collection_contract_address = LOWER('$_landmarkYieldAddress')
      LIMIT 1
    ''';

    return await _executeQuery(sql);
  }

  /// Get recent NFT transactions using nft_transcations (note: their typo)
  Future<List<NFTTransaction>> getNFTTransactions({int limit = 20}) async {
    try {
      final sql = '''
        SELECT
          transaction_hash,
          buyer,
          seller,
          token_id,
          price,
          price_usd,
          platform,
          platform_fee,
          royalty_amount,
          block_timestamp
        FROM nft_transcations
        WHERE chain = '$_chain'
          AND collection_contract_address = LOWER('$_landmarkYieldAddress')
        ORDER BY block_timestamp DESC
        LIMIT $limit
      ''';

      final result = await _executeQuery(sql);

      if (result != null && result['data'] != null) {
        final List<dynamic> items = result['data'];
        _recentTransactions = items.map((e) => NFTTransaction.fromJson(e)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('NFT transactions error: $e');
    }

    return _recentTransactions;
  }

  /// Get NFT transfers using nft_transfers
  Future<List<NFTTransfer>> getNFTTransfers({int limit = 50}) async {
    try {
      final sql = '''
        SELECT
          transaction_hash,
          from_address,
          to_address,
          token_id,
          amount,
          block_timestamp
        FROM nft_transfers
        WHERE chain = '$_chain'
          AND collection_contract_address = LOWER('$_landmarkYieldAddress')
        ORDER BY block_timestamp DESC
        LIMIT $limit
      ''';

      final result = await _executeQuery(sql);

      if (result != null && result['data'] != null) {
        final List<dynamic> items = result['data'];
        return items.map((e) => NFTTransfer.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint('NFT transfers error: $e');
    }

    return [];
  }

  // ============ Wallet/Address Analytics ============

  /// Get wallet balances using address_latest_balance
  Future<List<TokenBalance>> getWalletBalances(String walletAddress) async {
    _isLoading = true;
    notifyListeners();

    try {
      final sql = '''
        SELECT
          token_address,
          token_symbol,
          token_name,
          balance,
          balance_usd,
          token_type
        FROM address_latest_balance
        WHERE chain = '$_chain'
          AND address = LOWER('$walletAddress')
      ''';

      final result = await _executeQuery(sql);

      if (result != null && result['data'] != null) {
        final List<dynamic> items = result['data'];
        _walletBalances = items.map((e) => TokenBalance.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint('Wallet balance error: $e');
    }

    _isLoading = false;
    notifyListeners();
    return _walletBalances;
  }

  /// Get wallet labels/tags using entity_tag
  Future<List<String>> getWalletLabels(String walletAddress) async {
    try {
      final sql = '''
        SELECT tag, tag_type, confidence
        FROM entity_tag
        WHERE address = LOWER('$walletAddress')
      ''';

      final result = await _executeQuery(sql);

      if (result != null && result['data'] != null) {
        final List<dynamic> items = result['data'];
        return items.map((e) => e['tag']?.toString() ?? '').where((t) => t.isNotEmpty).toList();
      }
    } catch (e) {
      debugPrint('Wallet labels error: $e');
    }

    return [];
  }

  /// Get player analytics - combines multiple queries
  Future<PlayerAnalytics?> getPlayerAnalytics(String walletAddress) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Get transaction count for this wallet
      final txSql = '''
        SELECT
          COUNT(*) as tx_count,
          MIN(block_timestamp) as first_tx,
          MAX(block_timestamp) as last_tx
        FROM mantle_transaction
        WHERE from_address = LOWER('$walletAddress')
           OR to_address = LOWER('$walletAddress')
      ''';

      final txResult = await _executeQuery(txSql);

      // Get NFT holdings count
      final nftSql = '''
        SELECT COUNT(DISTINCT token_id) as nft_count
        FROM address_latest_balance
        WHERE chain = '$_chain'
          AND address = LOWER('$walletAddress')
          AND token_type IN ('ERC721', 'ERC1155')
      ''';

      final nftResult = await _executeQuery(nftSql);

      if (txResult != null || nftResult != null) {
        _playerAnalytics = PlayerAnalytics(
          address: walletAddress,
          totalTransactions: txResult?['data']?[0]?['tx_count'] ?? 0,
          nftCount: nftResult?['data']?[0]?['nft_count'] ?? 0,
          totalVolumeETH: 0,
          activeProtocols: ['GPS Runner'],
          firstActivity: DateTime.tryParse(txResult?['data']?[0]?['first_tx'] ?? '') ?? DateTime.now(),
          lastActivity: DateTime.tryParse(txResult?['data']?[0]?['last_tx'] ?? '') ?? DateTime.now(),
        );
      }
    } catch (e) {
      debugPrint('Player analytics error: $e');
    }

    _isLoading = false;
    notifyListeners();
    return _playerAnalytics;
  }

  // ============ Token Analytics ============

  /// Get RUN token daily stats using token_daily_stats
  Future<TokenStats?> getTokenStats({int days = 30}) async {
    try {
      final sql = '''
        SELECT
          day,
          price,
          market_cap,
          volume,
          total_supply,
          circulating_supply
        FROM token_daily_stats
        WHERE chain = '$_chain'
          AND token_address = LOWER('$_runTokenAddress')
        ORDER BY day DESC
        LIMIT $days
      ''';

      final result = await _executeQuery(sql);

      if (result != null && result['data'] != null && (result['data'] as List).isNotEmpty) {
        return TokenStats.fromFootprintData(result['data']);
      }
    } catch (e) {
      debugPrint('Token stats error: $e');
    }

    return null;
  }

  // ============ Raw Chain Data ============

  /// Get raw transactions using mantle_transaction table
  Future<List<Map<String, dynamic>>> getRawTransactions(String address, {int limit = 50}) async {
    try {
      final sql = '''
        SELECT
          hash,
          from_address,
          to_address,
          value,
          gas_used,
          gas_price,
          block_timestamp,
          status
        FROM mantle_transaction
        WHERE (from_address = LOWER('$address') OR to_address = LOWER('$address'))
        ORDER BY block_timestamp DESC
        LIMIT $limit
      ''';

      final result = await _executeQuery(sql);

      if (result != null && result['data'] != null) {
        return List<Map<String, dynamic>>.from(result['data']);
      }
    } catch (e) {
      debugPrint('Raw transactions error: $e');
    }

    return [];
  }

  /// Get token transfers using mantle_token_transfer
  Future<List<Map<String, dynamic>>> getTokenTransfers(String tokenAddress, {int limit = 50}) async {
    try {
      final sql = '''
        SELECT
          transaction_hash,
          from_address,
          to_address,
          token_address,
          amount,
          block_timestamp
        FROM mantle_token_transfer
        WHERE token_address = LOWER('$tokenAddress')
        ORDER BY block_timestamp DESC
        LIMIT $limit
      ''';

      final result = await _executeQuery(sql);

      if (result != null && result['data'] != null) {
        return List<Map<String, dynamic>>.from(result['data']);
      }
    } catch (e) {
      debugPrint('Token transfers error: $e');
    }

    return [];
  }

  // ============ Refresh All Data ============

  /// Refresh all analytics data
  Future<void> refreshAll({String? walletAddress}) async {
    if (!canFetch) {
      debugPrint('Rate limited - please wait before refreshing');
      return;
    }

    await Future.wait([
      getGameStats(),
      getNFTStats(),
      getNFTTransactions(),
      if (walletAddress != null) getWalletBalances(walletAddress),
    ]);
  }

  /// Clear cached data
  void clearCache() {
    _gameStats = null;
    _nftStats = null;
    _recentTransactions = [];
    _playerAnalytics = null;
    _walletBalances = [];
    _lastFetch = null;
    notifyListeners();
  }
}

// ============ Data Models ============

class GameStats {
  final int totalUsers;
  final int activeUsersToday;
  final int activeUsersWeek;
  final int newUsersToday;
  final int totalTransactions;
  final double totalVolumeUSD;
  final List<DailyStats> dailyStats;

  GameStats({
    required this.totalUsers,
    required this.activeUsersToday,
    required this.activeUsersWeek,
    required this.newUsersToday,
    required this.totalTransactions,
    required this.totalVolumeUSD,
    required this.dailyStats,
  });

  factory GameStats.fromFootprintData(List<dynamic> data) {
    final dailyStats = data.map((e) => DailyStats.fromJson(e)).toList();

    // Calculate aggregates from daily data
    int totalUsers = 0;
    int totalTx = 0;
    double totalVol = 0;
    int newUsersToday = 0;
    int activeToday = 0;
    int activeWeek = 0;

    for (int i = 0; i < dailyStats.length; i++) {
      final day = dailyStats[i];
      if (day.totalUsers > totalUsers) totalUsers = day.totalUsers;
      totalTx += day.transactions;
      totalVol += day.volumeUSD;

      if (i == 0) {
        activeToday = day.activeUsers;
        newUsersToday = day.newUsers;
      }
      if (i < 7) {
        activeWeek += day.activeUsers;
      }
    }

    return GameStats(
      totalUsers: totalUsers,
      activeUsersToday: activeToday,
      activeUsersWeek: activeWeek,
      newUsersToday: newUsersToday,
      totalTransactions: totalTx,
      totalVolumeUSD: totalVol,
      dailyStats: dailyStats,
    );
  }

  factory GameStats.mock() {
    return GameStats(
      totalUsers: 1250,
      activeUsersToday: 89,
      activeUsersWeek: 342,
      newUsersToday: 12,
      totalTransactions: 15680,
      totalVolumeUSD: 45230.50,
      dailyStats: List.generate(30, (i) => DailyStats(
        date: DateTime.now().subtract(Duration(days: i)),
        activeUsers: 50 + (i * 3) % 100,
        newUsers: 5 + (i * 2) % 20,
        totalUsers: 1200 + i * 10,
        transactions: 100 + (i * 17) % 500,
        volumeUSD: 500 + (i * 123) % 2000,
      )),
    );
  }
}

class DailyStats {
  final DateTime date;
  final int activeUsers;
  final int newUsers;
  final int totalUsers;
  final int transactions;
  final double volumeUSD;

  DailyStats({
    required this.date,
    required this.activeUsers,
    required this.newUsers,
    required this.totalUsers,
    required this.transactions,
    required this.volumeUSD,
  });

  factory DailyStats.fromJson(Map<String, dynamic> json) {
    return DailyStats(
      date: DateTime.tryParse(json['day']?.toString() ?? '') ?? DateTime.now(),
      activeUsers: json['active_users'] ?? 0,
      newUsers: json['new_users'] ?? 0,
      totalUsers: json['total_users'] ?? 0,
      transactions: json['transactions'] ?? 0,
      volumeUSD: (json['volume_usd'] ?? json['volume'] ?? 0).toDouble(),
    );
  }
}

class NFTStats {
  final int totalSupply;
  final int holders;
  final int totalSales;
  final double totalVolumeETH;
  final double floorPrice;
  final double marketCap;
  final List<NFTDailyStats> dailyStats;

  NFTStats({
    required this.totalSupply,
    required this.holders,
    required this.totalSales,
    required this.totalVolumeETH,
    required this.floorPrice,
    required this.marketCap,
    required this.dailyStats,
  });

  factory NFTStats.fromFootprintData(List<dynamic> data) {
    final dailyStats = data.map((e) => NFTDailyStats.fromJson(e)).toList();

    // Use most recent day's data for current stats
    final latest = dailyStats.isNotEmpty ? dailyStats.first : null;
    double totalVol = dailyStats.fold(0.0, (sum, d) => sum + d.volume);
    int totalSales = dailyStats.fold(0, (sum, d) => sum + d.sales);

    return NFTStats(
      totalSupply: latest?.totalSupply ?? 0,
      holders: latest?.holders ?? 0,
      totalSales: totalSales,
      totalVolumeETH: totalVol,
      floorPrice: latest?.floorPrice ?? 0,
      marketCap: latest?.marketCap ?? 0,
      dailyStats: dailyStats,
    );
  }

  factory NFTStats.mock() {
    return NFTStats(
      totalSupply: 5420,
      holders: 892,
      totalSales: 1890,
      totalVolumeETH: 125.5,
      floorPrice: 0.05,
      marketCap: 27100,
      dailyStats: [],
    );
  }
}

class NFTDailyStats {
  final DateTime date;
  final double floorPrice;
  final double volume;
  final int sales;
  final int holders;
  final int totalSupply;
  final double marketCap;

  NFTDailyStats({
    required this.date,
    required this.floorPrice,
    required this.volume,
    required this.sales,
    required this.holders,
    required this.totalSupply,
    required this.marketCap,
  });

  factory NFTDailyStats.fromJson(Map<String, dynamic> json) {
    return NFTDailyStats(
      date: DateTime.tryParse(json['day']?.toString() ?? '') ?? DateTime.now(),
      floorPrice: (json['floor_price'] ?? 0).toDouble(),
      volume: (json['volume'] ?? 0).toDouble(),
      sales: json['sales'] ?? 0,
      holders: json['holders'] ?? 0,
      totalSupply: json['total_supply'] ?? 0,
      marketCap: (json['market_cap'] ?? 0).toDouble(),
    );
  }
}

class NFTTransaction {
  final String txHash;
  final String buyer;
  final String seller;
  final String tokenId;
  final double priceETH;
  final double priceUSD;
  final String platform;
  final double platformFee;
  final double royalty;
  final DateTime timestamp;

  NFTTransaction({
    required this.txHash,
    required this.buyer,
    required this.seller,
    required this.tokenId,
    required this.priceETH,
    required this.priceUSD,
    required this.platform,
    required this.platformFee,
    required this.royalty,
    required this.timestamp,
  });

  factory NFTTransaction.fromJson(Map<String, dynamic> json) {
    return NFTTransaction(
      txHash: json['transaction_hash'] ?? '',
      buyer: json['buyer'] ?? '',
      seller: json['seller'] ?? '',
      tokenId: json['token_id']?.toString() ?? '',
      priceETH: (json['price'] ?? 0).toDouble(),
      priceUSD: (json['price_usd'] ?? 0).toDouble(),
      platform: json['platform'] ?? 'Unknown',
      platformFee: (json['platform_fee'] ?? 0).toDouble(),
      royalty: (json['royalty_amount'] ?? 0).toDouble(),
      timestamp: DateTime.tryParse(json['block_timestamp']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  String get shortTxHash => txHash.length > 10
      ? '${txHash.substring(0, 6)}...${txHash.substring(txHash.length - 4)}'
      : txHash;
  String get shortBuyer => buyer.length > 10
      ? '${buyer.substring(0, 6)}...${buyer.substring(buyer.length - 4)}'
      : buyer;
  String get shortSeller => seller.length > 10
      ? '${seller.substring(0, 6)}...${seller.substring(seller.length - 4)}'
      : seller;
}

class NFTTransfer {
  final String txHash;
  final String from;
  final String to;
  final String tokenId;
  final int amount;
  final bool isMint;
  final DateTime timestamp;

  NFTTransfer({
    required this.txHash,
    required this.from,
    required this.to,
    required this.tokenId,
    required this.amount,
    required this.isMint,
    required this.timestamp,
  });

  factory NFTTransfer.fromJson(Map<String, dynamic> json) {
    final from = json['from_address'] ?? '';
    return NFTTransfer(
      txHash: json['transaction_hash'] ?? '',
      from: from,
      to: json['to_address'] ?? '',
      tokenId: json['token_id']?.toString() ?? '',
      amount: json['amount'] ?? 1,
      isMint: from == '0x0000000000000000000000000000000000000000',
      timestamp: DateTime.tryParse(json['block_timestamp']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}

class TokenBalance {
  final String tokenAddress;
  final String symbol;
  final String name;
  final double balance;
  final double balanceUSD;
  final String tokenType; // ERC20, ERC721, ERC1155, native

  TokenBalance({
    required this.tokenAddress,
    required this.symbol,
    required this.name,
    required this.balance,
    required this.balanceUSD,
    required this.tokenType,
  });

  factory TokenBalance.fromJson(Map<String, dynamic> json) {
    return TokenBalance(
      tokenAddress: json['token_address'] ?? '',
      symbol: json['token_symbol'] ?? '',
      name: json['token_name'] ?? '',
      balance: (json['balance'] ?? 0).toDouble(),
      balanceUSD: (json['balance_usd'] ?? 0).toDouble(),
      tokenType: json['token_type'] ?? 'ERC20',
    );
  }
}

class PlayerAnalytics {
  final String address;
  final int totalTransactions;
  final int nftCount;
  final double totalVolumeETH;
  final List<String> activeProtocols;
  final DateTime firstActivity;
  final DateTime lastActivity;

  PlayerAnalytics({
    required this.address,
    required this.totalTransactions,
    required this.nftCount,
    required this.totalVolumeETH,
    required this.activeProtocols,
    required this.firstActivity,
    required this.lastActivity,
  });

  String get shortAddress => address.length > 10
      ? '${address.substring(0, 6)}...${address.substring(address.length - 4)}'
      : address;
}

class TokenStats {
  final double price;
  final double marketCap;
  final double volume24h;
  final double totalSupply;
  final double circulatingSupply;
  final List<TokenDailyStats> dailyStats;

  TokenStats({
    required this.price,
    required this.marketCap,
    required this.volume24h,
    required this.totalSupply,
    required this.circulatingSupply,
    required this.dailyStats,
  });

  factory TokenStats.fromFootprintData(List<dynamic> data) {
    final dailyStats = data.map((e) => TokenDailyStats.fromJson(e)).toList();
    final latest = dailyStats.isNotEmpty ? dailyStats.first : null;

    return TokenStats(
      price: latest?.price ?? 0,
      marketCap: latest?.marketCap ?? 0,
      volume24h: latest?.volume ?? 0,
      totalSupply: latest?.totalSupply ?? 0,
      circulatingSupply: latest?.circulatingSupply ?? 0,
      dailyStats: dailyStats,
    );
  }
}

class TokenDailyStats {
  final DateTime date;
  final double price;
  final double marketCap;
  final double volume;
  final double totalSupply;
  final double circulatingSupply;

  TokenDailyStats({
    required this.date,
    required this.price,
    required this.marketCap,
    required this.volume,
    required this.totalSupply,
    required this.circulatingSupply,
  });

  factory TokenDailyStats.fromJson(Map<String, dynamic> json) {
    return TokenDailyStats(
      date: DateTime.tryParse(json['day']?.toString() ?? '') ?? DateTime.now(),
      price: (json['price'] ?? 0).toDouble(),
      marketCap: (json['market_cap'] ?? 0).toDouble(),
      volume: (json['volume'] ?? 0).toDouble(),
      totalSupply: (json['total_supply'] ?? 0).toDouble(),
      circulatingSupply: (json['circulating_supply'] ?? 0).toDouble(),
    );
  }
}
