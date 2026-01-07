import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import '../config/chain_config.dart';
import 'isar_db.dart';

/// Service for interacting with GameToken contracts on multiple chains
/// Handles claiming collected coins as on-chain tokens (gMNT, gPOL, gBNB)
class GameTokenService extends ChangeNotifier {
  static final GameTokenService _instance = GameTokenService._internal();
  factory GameTokenService() => _instance;
  GameTokenService._internal();

  // State
  Web3Client? _client;
  ChainConfig? _currentChain;
  EthPrivateKey? _credentials;
  bool _isInitialized = false;

  // Contract instance
  DeployedContract? _gameTokenContract;

  // Backend URL for signed claims
  // Set via: flutter build apk --dart-define=BACKEND_URL=https://your-api.workers.dev
  static const String _backendUrl = String.fromEnvironment(
    'BACKEND_URL',
    defaultValue: 'http://10.0.2.2:3000', // Android emulator localhost for dev
  );

  // Getters
  bool get isInitialized => _isInitialized;
  ChainConfig? get currentChain => _currentChain;

  /// Initialize with a specific chain
  Future<void> initialize(String privateKey, {ChainType? chainType}) async {
    try {
      final chain = chainType != null
          ? SupportedChains.getByType(chainType)
          : SupportedChains.defaultChain;

      _currentChain = chain;
      _client = Web3Client(chain.rpcUrl, http.Client());
      _credentials = EthPrivateKey.fromHex(privateKey);

      // Load contract if deployed
      if (chain.gameTokenAddress != null && chain.gameTokenAddress!.isNotEmpty) {
        await _loadContract(chain.gameTokenAddress!);
      }

      _isInitialized = true;
      notifyListeners();
      debugPrint('GameTokenService initialized on ${chain.name}');
    } catch (e) {
      debugPrint('Failed to initialize GameTokenService: $e');
      rethrow;
    }
  }

  /// Switch to a different chain
  Future<void> switchChain(ChainType chainType) async {
    if (!_isInitialized || _credentials == null) {
      throw Exception('Service not initialized');
    }

    final chain = SupportedChains.getByType(chainType);
    _currentChain = chain;
    _client = Web3Client(chain.rpcUrl, http.Client());

    if (chain.gameTokenAddress != null && chain.gameTokenAddress!.isNotEmpty) {
      await _loadContract(chain.gameTokenAddress!);
    } else {
      _gameTokenContract = null;
    }

    notifyListeners();
    debugPrint('Switched to ${chain.name}');
  }

  /// Load the GameToken contract
  Future<void> _loadContract(String address) async {
    final abi = _getGameTokenABI();
    _gameTokenContract = DeployedContract(
      ContractAbi.fromJson(abi, 'GameToken'),
      EthereumAddress.fromHex(address),
    );
  }

  /// Get player's on-chain token balance
  Future<BigInt> getOnChainBalance() async {
    if (_gameTokenContract == null || _credentials == null) {
      return BigInt.zero;
    }

    try {
      final balanceOf = _gameTokenContract!.function('balanceOf');
      final result = await _client!.call(
        contract: _gameTokenContract!,
        function: balanceOf,
        params: [_credentials!.address],
      );
      return result[0] as BigInt;
    } catch (e) {
      debugPrint('Error getting balance: $e');
      return BigInt.zero;
    }
  }

  /// Get player stats from contract
  Future<Map<String, dynamic>> getPlayerStats() async {
    if (_gameTokenContract == null || _credentials == null) {
      return {};
    }

    try {
      final getStats = _gameTokenContract!.function('getPlayerStats');
      final result = await _client!.call(
        contract: _gameTokenContract!,
        function: getStats,
        params: [_credentials!.address],
      );

      return {
        'balance': result[0] as BigInt,
        'totalClaimed': result[1] as BigInt,
        'lastClaimTime': result[2] as BigInt,
        'nextClaimIn': result[3] as BigInt,
      };
    } catch (e) {
      debugPrint('Error getting player stats: $e');
      return {};
    }
  }

  /// Get time until next claim is available
  Future<Duration> getTimeUntilNextClaim() async {
    if (_gameTokenContract == null || _credentials == null) {
      return Duration.zero;
    }

    try {
      final timeFunc = _gameTokenContract!.function('timeUntilNextClaim');
      final result = await _client!.call(
        contract: _gameTokenContract!,
        function: timeFunc,
        params: [_credentials!.address],
      );

      final seconds = (result[0] as BigInt).toInt();
      return Duration(seconds: seconds);
    } catch (e) {
      debugPrint('Error getting time until next claim: $e');
      return Duration.zero;
    }
  }

  /// Request a claim signature from the backend
  /// This requires a backend service that signs claim requests
  Future<Map<String, dynamic>?> requestClaimSignature(
    String coinSymbol,
    double amount,
  ) async {
    try {
      // Convert amount to wei (18 decimals)
      final amountWei = BigInt.from(amount * 1e18);

      // Request signature from backend
      // TODO: Implement your backend endpoint
      final response = await http.post(
        Uri.parse('$_backendUrl/api/claim/sign'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'player': _credentials?.address.hex,
          'amount': amountWei.toString(),
          'coinSymbol': coinSymbol,
          'chainId': _currentChain?.chainId,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      debugPrint('Backend returned ${response.statusCode}: ${response.body}');
      return null;
    } catch (e) {
      debugPrint('Error requesting claim signature: $e');
      return null;
    }
  }

  /// Claim tokens on-chain (requires signed message from backend)
  Future<String?> claimTokens({
    required BigInt amount,
    required Uint8List claimId,
    required BigInt expiry,
    required Uint8List signature,
    required IsarDBService db,
  }) async {
    if (_gameTokenContract == null || _credentials == null || _client == null) {
      throw Exception('Service not initialized or contract not deployed');
    }

    try {
      final claimFunc = _gameTokenContract!.function('claimTokens');

      final txHash = await _client!.sendTransaction(
        _credentials!,
        Transaction.callContract(
          contract: _gameTokenContract!,
          function: claimFunc,
          parameters: [amount, claimId, expiry, signature],
          maxGas: 200000,
        ),
        chainId: _currentChain!.chainId,
      );

      // Mark coins as claimed in local database
      final amountDouble = amount.toDouble() / 1e18;
      await db.markCoinsClaimed(
        _currentChain!.gameTokenSymbol,
        amountDouble,
        txHash,
      );

      notifyListeners();
      return txHash;
    } catch (e) {
      debugPrint('Error claiming tokens: $e');
      rethrow;
    }
  }

  /// Get global stats from contract
  Future<Map<String, dynamic>> getGlobalStats() async {
    if (_gameTokenContract == null) {
      return {};
    }

    try {
      final getStats = _gameTokenContract!.function('getGlobalStats');
      final result = await _client!.call(
        contract: _gameTokenContract!,
        function: getStats,
        params: [],
      );

      return {
        'totalSupply': result[0] as BigInt,
        'maxSupply': result[1] as BigInt,
        'totalClaimed': result[2] as BigInt,
        'claimCount': result[3] as BigInt,
      };
    } catch (e) {
      debugPrint('Error getting global stats: $e');
      return {};
    }
  }

  /// Check if claims are paused
  Future<bool> areClaimsPaused() async {
    if (_gameTokenContract == null) {
      return true;
    }

    try {
      final paused = _gameTokenContract!.function('claimsPaused');
      final result = await _client!.call(
        contract: _gameTokenContract!,
        function: paused,
        params: [],
      );
      return result[0] as bool;
    } catch (e) {
      debugPrint('Error checking claims paused: $e');
      return true;
    }
  }

  /// Format token amount for display
  String formatAmount(BigInt amount, {int decimals = 2}) {
    final value = amount.toDouble() / 1e18;
    return value.toStringAsFixed(decimals);
  }

  /// Get the ABI for GameToken contract
  String _getGameTokenABI() {
    return jsonEncode([
      // balanceOf
      {
        "inputs": [{"name": "account", "type": "address"}],
        "name": "balanceOf",
        "outputs": [{"name": "", "type": "uint256"}],
        "stateMutability": "view",
        "type": "function"
      },
      // claimTokens
      {
        "inputs": [
          {"name": "amount", "type": "uint256"},
          {"name": "claimId", "type": "bytes32"},
          {"name": "expiry", "type": "uint256"},
          {"name": "signature", "type": "bytes"}
        ],
        "name": "claimTokens",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
      },
      // getPlayerStats
      {
        "inputs": [{"name": "player", "type": "address"}],
        "name": "getPlayerStats",
        "outputs": [
          {"name": "balance", "type": "uint256"},
          {"name": "claimed", "type": "uint256"},
          {"name": "lastClaim", "type": "uint256"},
          {"name": "nextClaimIn", "type": "uint256"}
        ],
        "stateMutability": "view",
        "type": "function"
      },
      // timeUntilNextClaim
      {
        "inputs": [{"name": "player", "type": "address"}],
        "name": "timeUntilNextClaim",
        "outputs": [{"name": "", "type": "uint256"}],
        "stateMutability": "view",
        "type": "function"
      },
      // getGlobalStats
      {
        "inputs": [],
        "name": "getGlobalStats",
        "outputs": [
          {"name": "supply", "type": "uint256"},
          {"name": "maxSupply", "type": "uint256"},
          {"name": "claimed", "type": "uint256"},
          {"name": "claimCount", "type": "uint256"}
        ],
        "stateMutability": "view",
        "type": "function"
      },
      // claimsPaused
      {
        "inputs": [],
        "name": "claimsPaused",
        "outputs": [{"name": "", "type": "bool"}],
        "stateMutability": "view",
        "type": "function"
      },
      // totalClaimed (per address)
      {
        "inputs": [{"name": "", "type": "address"}],
        "name": "totalClaimed",
        "outputs": [{"name": "", "type": "uint256"}],
        "stateMutability": "view",
        "type": "function"
      },
    ]);
  }

  @override
  void dispose() {
    _client?.dispose();
    super.dispose();
  }
}
