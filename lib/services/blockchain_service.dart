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

/// Contract ABI for GPS Runner
const String _runnerContractABI = '''
[
  {
    "inputs": [
      {"name": "_lat1e6", "type": "uint256"},
      {"name": "_lng1e6", "type": "uint256"},
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
    "name": "getPlayerMarkerCount",
    "outputs": [{"name": "", "type": "uint256"}],
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
    "anonymous": false,
    "inputs": [
      {"indexed": true, "name": "player", "type": "address"},
      {"indexed": false, "name": "lat1e6", "type": "uint256"},
      {"indexed": false, "name": "lng1e6", "type": "uint256"},
      {"indexed": false, "name": "landmark", "type": "string"},
      {"indexed": false, "name": "timestamp", "type": "uint256"}
    ],
    "name": "MarkerAdded",
    "type": "event"
  }
]
''';

/// Blockchain service for Polygon Mumbai
class BlockchainService extends ChangeNotifier {
  static final BlockchainService _instance = BlockchainService._internal();
  factory BlockchainService() => _instance;
  BlockchainService._internal();

  // RPC Configuration - Public Polygon Amoy Testnet
  static const String _rpcUrl =
      'https://rpc-amoy.polygon.technology';
  static const String _wsUrl =
      'wss://rpc-amoy.polygon.technology';

  // Chain ID for Polygon Amoy (Mumbai deprecated, Amoy is new testnet)
  static const int _chainId = 80002;

  Web3Client? _client;
  WebSocketChannel? _wsChannel;
  ChainState _state = ChainState.disconnected;
  String? _errorMessage;

  // Credentials (will be set from auth service)
  EthPrivateKey? _credentials;
  EthereumAddress? _address;

  // Contracts
  DeployedContract? _delhiContract;
  DeployedContract? _hydContract;

  // Event subscriptions
  StreamSubscription? _delhiEventSub;
  StreamSubscription? _hydEventSub;

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

      // Load contracts
      final contractAbi = ContractAbi.fromJson(_runnerContractABI, 'GPSRunner');

      _delhiContract = DeployedContract(
        contractAbi,
        EthereumAddress.fromHex(CityBounds.delhiContractAddress),
      );

      _hydContract = DeployedContract(
        contractAbi,
        EthereumAddress.fromHex(CityBounds.hydContractAddress),
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

    // Original code (disabled):
    // try {
    //   _wsChannel = WebSocketChannel.connect(Uri.parse(_wsUrl));
    //   _subscribeToEvents();
    // } catch (e) {
    //   debugPrint('WebSocket error: $e');
    // }
  }

  void _subscribeToEvents() {
    // Listen for MarkerAdded events from both contracts
    // Wrapped in try-catch to prevent crashes on RPC issues
    try {
      if (_delhiContract != null && _client != null) {
        final markerAddedEvent = _delhiContract!.event('MarkerAdded');
        _delhiEventSub = _client!
            .events(FilterOptions.events(
              contract: _delhiContract!,
              event: markerAddedEvent,
            ))
            .listen(
              (event) => _handleMarkerEvent(event, 'delhi'),
              onError: (e) => debugPrint('Delhi event error: $e'),
            );
      }

      if (_hydContract != null && _client != null) {
        final markerAddedEvent = _hydContract!.event('MarkerAdded');
        _hydEventSub = _client!
            .events(FilterOptions.events(
              contract: _hydContract!,
              event: markerAddedEvent,
            ))
            .listen(
              (event) => _handleMarkerEvent(event, 'hyderabad'),
              onError: (e) => debugPrint('Hyd event error: $e'),
            );
      }
    } catch (e) {
      debugPrint('Event subscription error: $e');
    }
  }

  void _handleMarkerEvent(FilterEvent event, String city) {
    try {
      final decoded = event.topics;
      if (decoded == null || decoded.isEmpty) return;

      // Parse event data
      final playerAddress = EthereumAddress.fromHex(decoded[1].toString());
      final lat1e6 = BigInt.parse(event.data?.substring(0, 66) ?? '0');
      final lng1e6 = BigInt.parse(event.data?.substring(66, 132) ?? '0');

      final marker = GPSMarker.create(
        playerId: playerAddress.hex,
        playerName: _shortenAddress(playerAddress.hex),
        latitude: lat1e6.toDouble() / 1e6,
        longitude: lng1e6.toDouble() / 1e6,
        city: city,
        color: city == 'delhi' ? '#2196F3' : '#4CAF50',
        landmarkName: 'On-chain marker',
        activityProof: 'verified',
        speedKmh: 0,
        stepsPerMin: 0,
        txHash: event.transactionHash ?? '',
        syncedToChain: true,
      );

      _liveMarkers.add(marker);

      // Notify callbacks
      for (final callback in _onNewMarkerCallbacks) {
        callback(marker);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error parsing marker event: $e');
    }
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

    // Select contract based on city
    final contract = proof.city == 'delhi' ? _delhiContract : _hydContract;
    if (contract == null) {
      debugPrint('Contract not found for city: ${proof.city}');
      return null;
    }

    try {
      final submitFunction = contract.function('submitMarker');

      final tx = await _client!.sendTransaction(
        _credentials!,
        Transaction.callContract(
          contract: contract,
          function: submitFunction,
          parameters: [
            BigInt.from(proof.lat1e6),
            BigInt.from(proof.lng1e6),
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

  /// Get player marker count
  Future<int> getPlayerMarkerCount(String city) async {
    if (!isConnected) return 0;

    final contract = city == 'delhi' ? _delhiContract : _hydContract;
    if (contract == null || _address == null) return 0;

    try {
      final function = contract.function('getPlayerMarkerCount');
      final result = await _client!.call(
        contract: contract,
        function: function,
        params: [_address],
      );
      return (result[0] as BigInt).toInt();
    } catch (e) {
      debugPrint('Error getting marker count: $e');
      return 0;
    }
  }

  /// Get total markers in city
  Future<int> getTotalMarkers(String city) async {
    if (!isConnected) return 0;

    final contract = city == 'delhi' ? _delhiContract : _hydContract;
    if (contract == null) return 0;

    try {
      final function = contract.function('getTotalMarkers');
      final result = await _client!.call(
        contract: contract,
        function: function,
        params: [],
      );
      return (result[0] as BigInt).toInt();
    } catch (e) {
      debugPrint('Error getting total markers: $e');
      return 0;
    }
  }

  /// Get all markers for a city
  Future<List<GPSMarker>> getAllMarkers(String city) async {
    if (!isConnected) return [];

    final contract = city == 'delhi' ? _delhiContract : _hydContract;
    if (contract == null) return [];

    final markers = <GPSMarker>[];
    final total = await getTotalMarkers(city);

    try {
      final function = contract.function('getMarkerByIndex');

      for (int i = 0; i < total && i < 100; i++) {
        // Limit to 100
        final result = await _client!.call(
          contract: contract,
          function: function,
          params: [BigInt.from(i)],
        );

        final playerAddress = result[0] as EthereumAddress;
        final lat1e6 = result[1] as BigInt;
        final lng1e6 = result[2] as BigInt;
        final landmark = result[3] as String;
        final timestamp = result[4] as BigInt;

        markers.add(GPSMarker.create(
          playerId: playerAddress.hex,
          playerName: _shortenAddress(playerAddress.hex),
          latitude: lat1e6.toDouble() / 1e6,
          longitude: lng1e6.toDouble() / 1e6,
          city: city,
          color: city == 'delhi' ? '#2196F3' : '#4CAF50',
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

  /// Disconnect from blockchain
  Future<void> disconnect() async {
    _delhiEventSub?.cancel();
    _hydEventSub?.cancel();
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
