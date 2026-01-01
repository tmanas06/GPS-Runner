import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/gps_proof.dart';
import '../models/marker.dart';
import '../models/city_bounds.dart';

/// Blockchain connection state
enum ChainState {
  disconnected,
  connecting,
  connected,
  error,
}

/// Contract ABI for IndiaRunner (unified contract)
const String _indiaRunnerABI = '''
[
  {
    "inputs": [
      {"name": "_lat1e6", "type": "uint256"},
      {"name": "_lng1e6", "type": "uint256"},
      {"name": "_stateHash", "type": "bytes32"},
      {"name": "_cityHash", "type": "bytes32"},
      {"name": "_landmark", "type": "string"},
      {"name": "_activityType", "type": "uint8"},
      {"name": "_speedKmh", "type": "uint16"},
      {"name": "_stepsPerMin", "type": "uint16"}
    ],
    "name": "submitMarker",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [{"name": "_player", "type": "address"}],
    "name": "getPlayerStats",
    "outputs": [
      {"name": "totalMarkers", "type": "uint256"},
      {"name": "totalDistanceMeters", "type": "uint256"},
      {"name": "homeState", "type": "bytes32"},
      {"name": "homeCity", "type": "bytes32"},
      {"name": "isRegistered", "type": "bool"}
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [{"name": "_player", "type": "address"}],
    "name": "getPlayerMarkerCount",
    "outputs": [{"name": "", "type": "uint256"}],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [{"name": "_player", "type": "address"}],
    "name": "getPlayerDistance",
    "outputs": [{"name": "", "type": "uint256"}],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {"name": "_player", "type": "address"},
      {"name": "_cityHash", "type": "bytes32"}
    ],
    "name": "getPlayerCityMarkerCount",
    "outputs": [{"name": "", "type": "uint256"}],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [{"name": "_cityHash", "type": "bytes32"}],
    "name": "getCityStats",
    "outputs": [
      {"name": "totalMarkers", "type": "uint256"},
      {"name": "totalPlayers", "type": "uint256"},
      {"name": "lastActivity", "type": "uint256"}
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [{"name": "_limit", "type": "uint256"}],
    "name": "getGlobalLeaderboard",
    "outputs": [
      {"name": "players", "type": "address[]"},
      {"name": "markerCounts", "type": "uint256[]"},
      {"name": "distances", "type": "uint256[]"}
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {"name": "_cityHash", "type": "bytes32"},
      {"name": "_limit", "type": "uint256"}
    ],
    "name": "getCityLeaderboard",
    "outputs": [
      {"name": "players", "type": "address[]"},
      {"name": "markerCounts", "type": "uint256[]"}
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [{"name": "_index", "type": "uint256"}],
    "name": "getMarkerByIndex",
    "outputs": [
      {"name": "player", "type": "address"},
      {"name": "lat1e6", "type": "uint256"},
      {"name": "lng1e6", "type": "uint256"},
      {"name": "cityHash", "type": "bytes32"},
      {"name": "landmark", "type": "string"},
      {"name": "timestamp", "type": "uint256"}
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "getTotalMarkers",
    "outputs": [{"name": "", "type": "uint256"}],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "totalPlayersCount",
    "outputs": [{"name": "", "type": "uint256"}],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "totalDistanceMeters",
    "outputs": [{"name": "", "type": "uint256"}],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "anonymous": false,
    "inputs": [
      {"indexed": true, "name": "player", "type": "address"},
      {"indexed": true, "name": "stateHash", "type": "bytes32"},
      {"indexed": true, "name": "cityHash", "type": "bytes32"},
      {"indexed": false, "name": "timestamp", "type": "uint256"}
    ],
    "name": "PlayerRegistered",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {"indexed": true, "name": "player", "type": "address"},
      {"indexed": true, "name": "cityHash", "type": "bytes32"},
      {"indexed": false, "name": "lat1e6", "type": "uint256"},
      {"indexed": false, "name": "lng1e6", "type": "uint256"},
      {"indexed": false, "name": "landmark", "type": "string"},
      {"indexed": false, "name": "distanceMeters", "type": "uint256"},
      {"indexed": false, "name": "timestamp", "type": "uint256"}
    ],
    "name": "MarkerAdded",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {"indexed": true, "name": "player", "type": "address"},
      {"indexed": false, "name": "distanceMeters", "type": "uint256"},
      {"indexed": false, "name": "totalDistance", "type": "uint256"}
    ],
    "name": "DistanceRecorded",
    "type": "event"
  }
]
''';

/// Player stats from blockchain
class PlayerBlockchainStats {
  final int totalMarkers;
  final int totalDistanceMeters;
  final String homeState;
  final String homeCity;
  final bool isRegistered;

  PlayerBlockchainStats({
    required this.totalMarkers,
    required this.totalDistanceMeters,
    required this.homeState,
    required this.homeCity,
    required this.isRegistered,
  });

  double get totalDistanceKm => totalDistanceMeters / 1000.0;
}

/// Leaderboard entry
class LeaderboardEntry {
  final String address;
  final int markerCount;
  final int distanceMeters;

  LeaderboardEntry({
    required this.address,
    required this.markerCount,
    this.distanceMeters = 0,
  });

  double get distanceKm => distanceMeters / 1000.0;
}

/// Blockchain service for Polygon Mumbai
class BlockchainService extends ChangeNotifier {
  static final BlockchainService _instance = BlockchainService._internal();
  factory BlockchainService() => _instance;
  BlockchainService._internal();

  // RPC Configuration - Public Polygon Amoy Testnet
  static const String _rpcUrl = 'https://rpc-amoy.polygon.technology';
  static const String _wsUrl = 'wss://rpc-amoy.polygon.technology';

  // Chain ID for Polygon Amoy (Mumbai deprecated, Amoy is new testnet)
  static const int _chainId = 80002;

  Web3Client? _client;
  WebSocketChannel? _wsChannel;
  ChainState _state = ChainState.disconnected;
  String? _errorMessage;

  // Credentials (will be set from auth service)
  EthPrivateKey? _credentials;
  EthereumAddress? _address;

  // Unified India contract
  DeployedContract? _indiaContract;

  // Event subscriptions
  StreamSubscription? _eventSub;

  // Live markers from events
  final List<GPSMarker> _liveMarkers = [];

  // Callbacks for new markers
  final List<void Function(GPSMarker)> _onNewMarkerCallbacks = [];

  // Rate limiting - 30 seconds between submissions
  static const int _rateLimitSeconds = 30;
  DateTime? _lastSubmissionTime;

  // Getters
  ChainState get state => _state;
  String? get errorMessage => _errorMessage;
  EthereumAddress? get address => _address;
  List<GPSMarker> get liveMarkers => List.unmodifiable(_liveMarkers);
  bool get isConnected => _state == ChainState.connected;

  /// Initialize blockchain connection
  Future<void> initialize(String privateKey) async {
    if (_state == ChainState.connected) return;

    _state = ChainState.connecting;
    _errorMessage = null;
    notifyListeners();

    try {
      // Create HTTP client
      final httpClient = http.Client();
      _client = Web3Client(_rpcUrl, httpClient);

      // Set credentials
      _credentials = EthPrivateKey.fromHex(privateKey);
      _address = _credentials!.address;

      // Load unified India contract
      final contractAbi = ContractAbi.fromJson(_indiaRunnerABI, 'IndiaRunner');

      _indiaContract = DeployedContract(
        contractAbi,
        EthereumAddress.fromHex(CityBounds.indiaContractAddress),
      );

      // Connect WebSocket for events (optional, don't fail if it doesn't work)
      try {
        await _connectWebSocket();
      } catch (e) {
        debugPrint('WebSocket connection failed (non-critical): $e');
      }

      _state = ChainState.connected;
      _errorMessage = null;
      notifyListeners();

      debugPrint('Blockchain connected: ${_address!.hex}');
    } catch (e) {
      _state = ChainState.error;
      _errorMessage = e.toString();
      notifyListeners();
      debugPrint('Blockchain error: $e');
    }
  }

  Future<void> _connectWebSocket() async {
    // Disable WebSocket events for now to prevent RPC errors
    // Real-time events can be enabled when a proper RPC with WebSocket support is configured
    debugPrint('WebSocket events disabled - using polling for updates');
    return;
  }

  /// Check if rate limited
  bool get isRateLimited {
    if (_lastSubmissionTime == null) return false;
    final elapsed = DateTime.now().difference(_lastSubmissionTime!).inSeconds;
    return elapsed < _rateLimitSeconds;
  }

  /// Get seconds until next submission allowed
  int get secondsUntilNextSubmission {
    if (_lastSubmissionTime == null) return 0;
    final elapsed = DateTime.now().difference(_lastSubmissionTime!).inSeconds;
    return math.max(0, _rateLimitSeconds - elapsed);
  }

  /// Submit GPS proof to blockchain
  Future<String?> submitProof(GPSProof proof) async {
    if (!isConnected || _credentials == null) {
      debugPrint('Blockchain not connected');
      return null;
    }

    // Client-side rate limiting
    if (isRateLimited) {
      debugPrint('Rate limited: wait $secondsUntilNextSubmission seconds');
      return null;
    }

    // Validate proof
    if (!proof.isValid) {
      debugPrint('Invalid proof: ${proof.rejectionReason}');
      return null;
    }

    if (_indiaContract == null) {
      debugPrint('Contract not initialized');
      return null;
    }

    try {
      final submitFunction = _indiaContract!.function('submitMarker');

      // Get state and city hashes
      final stateHash = _hexToBytes32(CityBounds.getStateHash(proof.stateId));
      final cityHash = _hexToBytes32(CityBounds.getCityHash(proof.city));

      final tx = await _client!.sendTransaction(
        _credentials!,
        Transaction.callContract(
          contract: _indiaContract!,
          function: submitFunction,
          parameters: [
            BigInt.from(proof.lat1e6),
            BigInt.from(proof.lng1e6),
            stateHash,
            cityHash,
            proof.landmarkName ?? 'Unknown',
            BigInt.from(proof.activityType.code),
            BigInt.from(proof.speedInt),
            BigInt.from(proof.stepsPerMin),
          ],
        ),
        chainId: _chainId,
      );

      debugPrint('Transaction submitted: $tx');
      _lastSubmissionTime = DateTime.now();
      return tx;
    } catch (e) {
      debugPrint('Transaction error: $e');
      return null;
    }
  }

  /// Get player stats from blockchain
  Future<PlayerBlockchainStats?> getPlayerStats([EthereumAddress? player]) async {
    if (!isConnected || _indiaContract == null) return null;

    final playerAddress = player ?? _address;
    if (playerAddress == null) return null;

    try {
      final function = _indiaContract!.function('getPlayerStats');
      final result = await _client!.call(
        contract: _indiaContract!,
        function: function,
        params: [playerAddress],
      );

      return PlayerBlockchainStats(
        totalMarkers: (result[0] as BigInt).toInt(),
        totalDistanceMeters: (result[1] as BigInt).toInt(),
        homeState: _bytes32ToHex(result[2]),
        homeCity: _bytes32ToHex(result[3]),
        isRegistered: result[4] as bool,
      );
    } catch (e) {
      debugPrint('Error getting player stats: $e');
      return null;
    }
  }

  /// Get player marker count
  Future<int> getPlayerMarkerCount([String? city]) async {
    if (!isConnected || _indiaContract == null) return 0;

    try {
      if (city != null) {
        // City-specific count
        final function = _indiaContract!.function('getPlayerCityMarkerCount');
        final cityHash = _hexToBytes32(CityBounds.getCityHash(city));
        final result = await _client!.call(
          contract: _indiaContract!,
          function: function,
          params: [_address, cityHash],
        );
        return (result[0] as BigInt).toInt();
      } else {
        // Total count
        final function = _indiaContract!.function('getPlayerMarkerCount');
        final result = await _client!.call(
          contract: _indiaContract!,
          function: function,
          params: [_address],
        );
        return (result[0] as BigInt).toInt();
      }
    } catch (e) {
      debugPrint('Error getting marker count: $e');
      return 0;
    }
  }

  /// Get player total distance
  Future<int> getPlayerDistance() async {
    if (!isConnected || _indiaContract == null || _address == null) return 0;

    try {
      final function = _indiaContract!.function('getPlayerDistance');
      final result = await _client!.call(
        contract: _indiaContract!,
        function: function,
        params: [_address],
      );
      return (result[0] as BigInt).toInt();
    } catch (e) {
      debugPrint('Error getting player distance: $e');
      return 0;
    }
  }

  /// Get total markers
  Future<int> getTotalMarkers([String? city]) async {
    if (!isConnected || _indiaContract == null) return 0;

    try {
      if (city != null) {
        // City stats
        final function = _indiaContract!.function('getCityStats');
        final cityHash = _hexToBytes32(CityBounds.getCityHash(city));
        final result = await _client!.call(
          contract: _indiaContract!,
          function: function,
          params: [cityHash],
        );
        return (result[0] as BigInt).toInt();
      } else {
        // Total
        final function = _indiaContract!.function('getTotalMarkers');
        final result = await _client!.call(
          contract: _indiaContract!,
          function: function,
          params: [],
        );
        return (result[0] as BigInt).toInt();
      }
    } catch (e) {
      debugPrint('Error getting total markers: $e');
      return 0;
    }
  }

  /// Get global leaderboard
  Future<List<LeaderboardEntry>> getGlobalLeaderboard({int limit = 20}) async {
    if (!isConnected || _indiaContract == null) return [];

    try {
      final function = _indiaContract!.function('getGlobalLeaderboard');
      final result = await _client!.call(
        contract: _indiaContract!,
        function: function,
        params: [BigInt.from(limit)],
      );

      final players = result[0] as List;
      final markerCounts = result[1] as List;
      final distances = result[2] as List;

      final entries = <LeaderboardEntry>[];
      for (int i = 0; i < players.length; i++) {
        final addr = players[i] as EthereumAddress;
        if (addr.hex != '0x0000000000000000000000000000000000000000') {
          entries.add(LeaderboardEntry(
            address: addr.hex,
            markerCount: (markerCounts[i] as BigInt).toInt(),
            distanceMeters: (distances[i] as BigInt).toInt(),
          ));
        }
      }

      return entries;
    } catch (e) {
      debugPrint('Error getting global leaderboard: $e');
      return [];
    }
  }

  /// Get city leaderboard
  Future<List<LeaderboardEntry>> getCityLeaderboard(String cityId, {int limit = 20}) async {
    if (!isConnected || _indiaContract == null) return [];

    try {
      final function = _indiaContract!.function('getCityLeaderboard');
      final cityHash = _hexToBytes32(CityBounds.getCityHash(cityId));

      final result = await _client!.call(
        contract: _indiaContract!,
        function: function,
        params: [cityHash, BigInt.from(limit)],
      );

      final players = result[0] as List;
      final markerCounts = result[1] as List;

      final entries = <LeaderboardEntry>[];
      for (int i = 0; i < players.length; i++) {
        final addr = players[i] as EthereumAddress;
        if (addr.hex != '0x0000000000000000000000000000000000000000') {
          entries.add(LeaderboardEntry(
            address: addr.hex,
            markerCount: (markerCounts[i] as BigInt).toInt(),
          ));
        }
      }

      return entries;
    } catch (e) {
      debugPrint('Error getting city leaderboard: $e');
      return [];
    }
  }

  /// Get all markers (paginated)
  Future<List<GPSMarker>> getAllMarkers({int start = 0, int limit = 100}) async {
    if (!isConnected || _indiaContract == null) return [];

    final markers = <GPSMarker>[];
    final total = await getTotalMarkers();

    try {
      final function = _indiaContract!.function('getMarkerByIndex');

      for (int i = start; i < total && i < start + limit; i++) {
        final result = await _client!.call(
          contract: _indiaContract!,
          function: function,
          params: [BigInt.from(i)],
        );

        final playerAddress = result[0] as EthereumAddress;
        final lat1e6 = result[1] as BigInt;
        final lng1e6 = result[2] as BigInt;
        final cityHash = result[3];
        final landmark = result[4] as String;
        final timestamp = result[5] as BigInt;

        markers.add(GPSMarker.create(
          playerId: playerAddress.hex,
          playerName: _shortenAddress(playerAddress.hex),
          latitude: lat1e6.toDouble() / 1e6,
          longitude: lng1e6.toDouble() / 1e6,
          city: 'india', // We'd need reverse lookup for city
          color: '#4CAF50',
          landmarkName: landmark,
          activityProof: 'verified',
          speedKmh: 0,
          stepsPerMin: 0,
          syncedToChain: true,
        )..timestamp = timestamp.toInt());
      }
    } catch (e) {
      debugPrint('Error getting markers: $e');
    }

    return markers;
  }

  /// Get wallet balance
  Future<double> getBalance() async {
    if (!isConnected || _address == null) return 0;

    try {
      final balance = await _client!.getBalance(_address!);
      return balance.getValueInUnit(EtherUnit.ether);
    } catch (e) {
      debugPrint('Error getting balance: $e');
      return 0;
    }
  }

  /// Add callback for new marker events
  void addNewMarkerCallback(void Function(GPSMarker) callback) {
    _onNewMarkerCallbacks.add(callback);
  }

  /// Remove callback
  void removeNewMarkerCallback(void Function(GPSMarker) callback) {
    _onNewMarkerCallbacks.remove(callback);
  }

  String _shortenAddress(String address) {
    if (address.length <= 10) return address;
    return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
  }

  /// Convert hex string to bytes32
  List<int> _hexToBytes32(String hex) {
    final cleanHex = hex.startsWith('0x') ? hex.substring(2) : hex;
    final bytes = <int>[];
    for (int i = 0; i < cleanHex.length; i += 2) {
      bytes.add(int.parse(cleanHex.substring(i, i + 2), radix: 16));
    }
    // Ensure it's exactly 32 bytes
    while (bytes.length < 32) {
      bytes.add(0);
    }
    return bytes;
  }

  /// Convert bytes32 to hex string
  String _bytes32ToHex(dynamic bytes) {
    if (bytes is List<int>) {
      return '0x${bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}';
    }
    return bytes.toString();
  }

  /// Disconnect from blockchain
  Future<void> disconnect() async {
    _eventSub?.cancel();
    _wsChannel?.sink.close();
    _client?.dispose();

    _state = ChainState.disconnected;
    _liveMarkers.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}

/// Helper to generate a simple wallet for testing
class WalletHelper {
  /// Generate a new random wallet
  static (String privateKey, String address) generateWallet() {
    final random = math.Random.secure();
    final credentials = EthPrivateKey.createRandom(random);
    return (
      bytesToHex(credentials.privateKey),
      credentials.address.hex,
    );
  }

  /// Convert bytes to hex string
  static String bytesToHex(List<int> bytes) {
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}
