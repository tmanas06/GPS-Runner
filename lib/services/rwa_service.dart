import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import 'blockchain_service.dart';
import 'auth_service.dart';
import '../config/chain_config.dart';

/// Contract ABIs for RWA contracts
const String _runTokenABI = '''
[
  {"inputs": [{"name": "account", "type": "address"}], "name": "balanceOf", "outputs": [{"name": "", "type": "uint256"}], "stateMutability": "view", "type": "function"},
  {"inputs": [], "name": "totalSupply", "outputs": [{"name": "", "type": "uint256"}], "stateMutability": "view", "type": "function"},
  {"inputs": [{"name": "runAmount", "type": "uint256"}], "name": "activateBoost", "outputs": [], "stateMutability": "nonpayable", "type": "function"},
  {"inputs": [{"name": "player", "type": "address"}], "name": "getActiveBoost", "outputs": [{"name": "multiplier", "type": "uint256"}, {"name": "expiresAt", "type": "uint256"}], "stateMutability": "view", "type": "function"},
  {"inputs": [{"name": "player", "type": "address"}], "name": "hasActiveBoost", "outputs": [{"name": "", "type": "bool"}], "stateMutability": "view", "type": "function"},
  {"inputs": [], "name": "getTokenInfo", "outputs": [{"name": "supply", "type": "uint256"}, {"name": "maxSupply", "type": "uint256"}, {"name": "burned", "type": "uint256"}, {"name": "yieldPool", "type": "uint256"}, {"name": "feesCollected", "type": "uint256"}], "stateMutability": "view", "type": "function"},
  {"inputs": [{"name": "amount", "type": "uint256"}], "name": "stakeRUN", "outputs": [], "stateMutability": "nonpayable", "type": "function"},
  {"inputs": [{"name": "amount", "type": "uint256"}], "name": "unstakeRUN", "outputs": [], "stateMutability": "nonpayable", "type": "function"},
  {"inputs": [], "name": "claimLPYield", "outputs": [{"name": "", "type": "uint256"}], "stateMutability": "nonpayable", "type": "function"},
  {"inputs": [{"name": "user", "type": "address"}], "name": "getPendingLPYield", "outputs": [{"name": "", "type": "uint256"}], "stateMutability": "view", "type": "function"},
  {"inputs": [{"name": "user", "type": "address"}], "name": "getStakingInfo", "outputs": [{"name": "staked", "type": "uint256"}, {"name": "pendingYield", "type": "uint256"}, {"name": "totalStaked", "type": "uint256"}], "stateMutability": "view", "type": "function"},
  {"anonymous": false, "inputs": [{"indexed": true, "name": "player", "type": "address"}, {"indexed": false, "name": "runAmount", "type": "uint256"}, {"indexed": false, "name": "multiplier", "type": "uint256"}, {"indexed": false, "name": "expiresAt", "type": "uint256"}], "name": "BoostActivated", "type": "event"}
]
''';

const String _landmarkYieldABI = '''
[
  {"inputs": [{"name": "player", "type": "address"}, {"name": "landmarkHash", "type": "bytes32"}, {"name": "kmRun1e3", "type": "uint256"}, {"name": "gpsProofHash", "type": "bytes32"}], "name": "mintLandmarkYield", "outputs": [{"name": "tokenId", "type": "uint256"}], "stateMutability": "nonpayable", "type": "function"},
  {"inputs": [{"name": "tokenId", "type": "uint256"}], "name": "claimYield", "outputs": [{"name": "amount", "type": "uint256"}], "stateMutability": "nonpayable", "type": "function"},
  {"inputs": [{"name": "tokenId", "type": "uint256"}], "name": "getPendingYield", "outputs": [{"name": "", "type": "uint256"}], "stateMutability": "view", "type": "function"},
  {"inputs": [{"name": "user", "type": "address"}, {"name": "tokenId", "type": "uint256"}], "name": "getPendingYieldFor", "outputs": [{"name": "", "type": "uint256"}], "stateMutability": "view", "type": "function"},
  {"inputs": [{"name": "landmarkHash", "type": "bytes32"}], "name": "getLandmarkTokenId", "outputs": [{"name": "", "type": "uint256"}], "stateMutability": "pure", "type": "function"},
  {"inputs": [{"name": "landmarkId", "type": "uint256"}], "name": "depositToSponsorPool", "outputs": [], "stateMutability": "payable", "type": "function"},
  {"inputs": [{"name": "account", "type": "address"}, {"name": "id", "type": "uint256"}], "name": "balanceOf", "outputs": [{"name": "", "type": "uint256"}], "stateMutability": "view", "type": "function"},
  {"inputs": [{"name": "tokenId", "type": "uint256"}], "name": "getLandmarkInfo", "outputs": [{"name": "name", "type": "string"}, {"name": "cityHash", "type": "bytes32"}, {"name": "totalSupplyAmount", "type": "uint256"}, {"name": "sponsorPoolBalance", "type": "uint256"}, {"name": "accumulatedYield", "type": "uint256"}], "stateMutability": "view", "type": "function"},
  {"inputs": [{"name": "player", "type": "address"}, {"name": "landmarkHash", "type": "bytes32"}], "name": "canMint", "outputs": [{"name": "", "type": "bool"}, {"name": "reason", "type": "string"}], "stateMutability": "view", "type": "function"},
  {"anonymous": false, "inputs": [{"indexed": true, "name": "player", "type": "address"}, {"indexed": true, "name": "landmarkId", "type": "uint256"}, {"indexed": false, "name": "tokenId", "type": "uint256"}, {"indexed": false, "name": "yieldAmount", "type": "uint256"}, {"indexed": false, "name": "kmRun", "type": "uint256"}], "name": "LandmarkYieldMinted", "type": "event"},
  {"anonymous": false, "inputs": [{"indexed": true, "name": "player", "type": "address"}, {"indexed": true, "name": "tokenId", "type": "uint256"}, {"indexed": false, "name": "amount", "type": "uint256"}], "name": "YieldClaimed", "type": "event"}
]
''';

const String _markerStakingABI = '''
[
  {"inputs": [{"name": "markerId", "type": "uint256"}], "name": "stakeMarker", "outputs": [], "stateMutability": "nonpayable", "type": "function"},
  {"inputs": [{"name": "markerId", "type": "uint256"}], "name": "unstakeMarker", "outputs": [], "stateMutability": "nonpayable", "type": "function"},
  {"inputs": [], "name": "claimStakingYield", "outputs": [{"name": "", "type": "uint256"}], "stateMutability": "nonpayable", "type": "function"},
  {"inputs": [{"name": "staker", "type": "address"}], "name": "getPendingYield", "outputs": [{"name": "", "type": "uint256"}], "stateMutability": "view", "type": "function"},
  {"inputs": [{"name": "player", "type": "address"}], "name": "getLeaderboardMultiplier", "outputs": [{"name": "", "type": "uint256"}], "stateMutability": "view", "type": "function"},
  {"inputs": [{"name": "user", "type": "address"}], "name": "getUserStakedMarkers", "outputs": [{"name": "", "type": "uint256[]"}], "stateMutability": "view", "type": "function"},
  {"inputs": [{"name": "user", "type": "address"}], "name": "getStakingInfo", "outputs": [{"name": "stakedCount", "type": "uint256"}, {"name": "pendingYield", "type": "uint256"}, {"name": "multiplier", "type": "uint256"}, {"name": "rank", "type": "uint256"}], "stateMutability": "view", "type": "function"},
  {"inputs": [], "name": "getSeasonInfo", "outputs": [{"name": "season", "type": "uint256"}, {"name": "startTime", "type": "uint256"}, {"name": "poolAmount", "type": "uint256"}, {"name": "timeRemaining", "type": "uint256"}, {"name": "distributed", "type": "bool"}], "stateMutability": "view", "type": "function"},
  {"inputs": [{"name": "user", "type": "address"}], "name": "getEstimatedAPY", "outputs": [{"name": "", "type": "uint256"}], "stateMutability": "view", "type": "function"},
  {"inputs": [], "name": "totalStakedMarkers", "outputs": [{"name": "", "type": "uint256"}], "stateMutability": "view", "type": "function"},
  {"inputs": [{"name": "markerId", "type": "uint256"}], "name": "stakedMarkers", "outputs": [{"name": "owner", "type": "address"}, {"name": "landmarkHash", "type": "bytes32"}, {"name": "cityHash", "type": "bytes32"}, {"name": "stakedAt", "type": "uint256"}, {"name": "accumulatedYield", "type": "uint256"}, {"name": "lastClaimTime", "type": "uint256"}], "stateMutability": "view", "type": "function"},
  {"anonymous": false, "inputs": [{"indexed": true, "name": "owner", "type": "address"}, {"indexed": true, "name": "markerId", "type": "uint256"}, {"indexed": false, "name": "landmarkHash", "type": "bytes32"}], "name": "MarkerStaked", "type": "event"},
  {"anonymous": false, "inputs": [{"indexed": true, "name": "owner", "type": "address"}, {"indexed": true, "name": "markerId", "type": "uint256"}], "name": "MarkerUnstaked", "type": "event"},
  {"anonymous": false, "inputs": [{"indexed": true, "name": "owner", "type": "address"}, {"indexed": false, "name": "amount", "type": "uint256"}], "name": "YieldClaimed", "type": "event"}
]
''';

const String _governanceABI = '''
[
  {"inputs": [{"name": "name", "type": "string"}, {"name": "latitude1e6", "type": "int256"}, {"name": "longitude1e6", "type": "int256"}, {"name": "radiusMeters", "type": "uint256"}, {"name": "cityHash", "type": "bytes32"}, {"name": "points", "type": "uint256"}, {"name": "description", "type": "string"}], "name": "proposeLandmark", "outputs": [{"name": "", "type": "uint256"}], "stateMutability": "nonpayable", "type": "function"},
  {"inputs": [{"name": "name", "type": "string"}, {"name": "stateHash", "type": "bytes32"}, {"name": "minLat1e6", "type": "int256"}, {"name": "maxLat1e6", "type": "int256"}, {"name": "minLng1e6", "type": "int256"}, {"name": "maxLng1e6", "type": "int256"}, {"name": "description", "type": "string"}], "name": "proposeCity", "outputs": [{"name": "", "type": "uint256"}], "stateMutability": "nonpayable", "type": "function"},
  {"inputs": [{"name": "proposalId", "type": "uint256"}, {"name": "support", "type": "bool"}], "name": "vote", "outputs": [], "stateMutability": "nonpayable", "type": "function"},
  {"inputs": [{"name": "proposalId", "type": "uint256"}], "name": "executeProposal", "outputs": [], "stateMutability": "nonpayable", "type": "function"},
  {"inputs": [{"name": "proposalId", "type": "uint256"}], "name": "getProposal", "outputs": [{"name": "id", "type": "uint256"}, {"name": "proposer", "type": "address"}, {"name": "proposalType", "type": "uint8"}, {"name": "targetHash", "type": "bytes32"}, {"name": "description", "type": "string"}, {"name": "forVotes", "type": "uint256"}, {"name": "againstVotes", "type": "uint256"}, {"name": "startTime", "type": "uint256"}, {"name": "endTime", "type": "uint256"}, {"name": "status", "type": "uint8"}, {"name": "executed", "type": "bool"}], "stateMutability": "view", "type": "function"},
  {"inputs": [{"name": "proposalId", "type": "uint256"}], "name": "getProposalVotes", "outputs": [{"name": "forVotes", "type": "uint256"}, {"name": "againstVotes", "type": "uint256"}, {"name": "totalVotes", "type": "uint256"}, {"name": "quorumNeeded", "type": "uint256"}, {"name": "quorumReached", "type": "bool"}], "stateMutability": "view", "type": "function"},
  {"inputs": [{"name": "user", "type": "address"}], "name": "canPropose", "outputs": [{"name": "", "type": "bool"}, {"name": "votingPower", "type": "uint256"}, {"name": "threshold", "type": "uint256"}], "stateMutability": "view", "type": "function"},
  {"inputs": [{"name": "account", "type": "address"}], "name": "getVotingPower", "outputs": [{"name": "", "type": "uint256"}], "stateMutability": "view", "type": "function"},
  {"inputs": [{"name": "offset", "type": "uint256"}, {"name": "limit", "type": "uint256"}], "name": "getActiveProposals", "outputs": [{"name": "", "type": "uint256[]"}], "stateMutability": "view", "type": "function"},
  {"inputs": [], "name": "proposalCount", "outputs": [{"name": "", "type": "uint256"}], "stateMutability": "view", "type": "function"},
  {"inputs": [{"name": "landmarkHash", "type": "bytes32"}], "name": "isLandmarkApproved", "outputs": [{"name": "", "type": "bool"}], "stateMutability": "view", "type": "function"},
  {"inputs": [{"name": "cityHash", "type": "bytes32"}], "name": "isCityApproved", "outputs": [{"name": "", "type": "bool"}], "stateMutability": "view", "type": "function"},
  {"anonymous": false, "inputs": [{"indexed": true, "name": "proposalId", "type": "uint256"}, {"indexed": true, "name": "proposer", "type": "address"}, {"indexed": false, "name": "proposalType", "type": "uint8"}, {"indexed": false, "name": "description", "type": "string"}], "name": "ProposalCreated", "type": "event"},
  {"anonymous": false, "inputs": [{"indexed": true, "name": "proposalId", "type": "uint256"}, {"indexed": true, "name": "voter", "type": "address"}, {"indexed": false, "name": "support", "type": "bool"}, {"indexed": false, "name": "weight", "type": "uint256"}], "name": "Voted", "type": "event"}
]
''';

/// Service for RWA + Yield contract interactions
/// Multi-chain support: uses chain config from BlockchainService
class RWAService extends ChangeNotifier {
  static final RWAService _instance = RWAService._internal();
  factory RWAService() => _instance;
  RWAService._internal();

  // Current chain configuration
  ChainConfig? _currentChain;

  // Rate limiting
  static const int _rateLimitSeconds = 30;
  DateTime? _lastOperation;

  // Web3 client
  Web3Client? _client;
  EthPrivateKey? _credentials;

  // Contract instances
  DeployedContract? _runTokenContract;
  DeployedContract? _landmarkYieldContract;
  DeployedContract? _markerStakingContract;
  DeployedContract? _governanceContract;

  // Cached data
  RUNTokenInfo? _runInfo;
  StakingInfo? _stakingInfo;
  List<YieldToken> _yieldTokens = [];
  List<GovernanceProposal> _proposals = [];

  // Getters
  RUNTokenInfo? get runInfo => _runInfo;
  StakingInfo? get stakingInfo => _stakingInfo;
  List<YieldToken> get yieldTokens => List.unmodifiable(_yieldTokens);
  List<GovernanceProposal> get proposals => List.unmodifiable(_proposals);
  ChainConfig? get currentChain => _currentChain;
  String get chainName => _currentChain?.name ?? 'Not Connected';

  // Dynamic contract addresses from current chain
  String? get runTokenAddress => _currentChain?.runTokenAddress;
  String? get landmarkYieldAddress => _currentChain?.landmarkYieldAddress;
  String? get markerStakingAddress => _currentChain?.markerStakingAddress;
  String? get governanceAddress => _currentChain?.governanceAddress;

  bool get isRateLimited {
    if (_lastOperation == null) return false;
    return DateTime.now().difference(_lastOperation!).inSeconds < _rateLimitSeconds;
  }

  bool get isInitialized => _client != null && _credentials != null;
  bool get hasContracts => _currentChain?.hasContracts ?? false;

  /// Initialize the service with optional chain type
  Future<void> initialize({ChainType? chainType}) async {
    try {
      // Use specified chain or default
      _currentChain = chainType != null
          ? SupportedChains.getByType(chainType)
          : SupportedChains.defaultChain;

      _client = Web3Client(_currentChain!.rpcUrl, http.Client());

      // Get credentials from auth service
      final authService = AuthService();
      final privateKey = authService.privateKey;
      if (privateKey != null) {
        _credentials = EthPrivateKey.fromHex(privateKey);
      }

      // Initialize contracts if available on this chain
      if (_currentChain!.hasContracts) {
        _initializeContracts();
      } else {
        debugPrint('RWA contracts not deployed on ${_currentChain!.name}');
      }

      debugPrint('RWAService initialized on ${_currentChain!.name}');
    } catch (e) {
      debugPrint('RWAService initialization error: $e');
    }
  }

  /// Switch to a different chain
  Future<bool> switchChain(ChainType chainType) async {
    final newChain = SupportedChains.getByType(chainType);

    if (!newChain.hasContracts) {
      debugPrint('RWA contracts not deployed on ${newChain.name}');
      return false;
    }

    _currentChain = newChain;
    _client?.dispose();
    _client = Web3Client(_currentChain!.rpcUrl, http.Client());

    // Reinitialize contracts
    _initializeContracts();

    // Clear cached data
    _runInfo = null;
    _stakingInfo = null;
    _yieldTokens = [];
    _proposals = [];

    notifyListeners();
    debugPrint('RWAService switched to ${_currentChain!.name}');
    return true;
  }

  void _initializeContracts() {
    final runAddr = runTokenAddress;
    if (runAddr != null && runAddr.isNotEmpty) {
      _runTokenContract = DeployedContract(
        ContractAbi.fromJson(_runTokenABI, 'RUNToken'),
        EthereumAddress.fromHex(runAddr),
      );
    }

    final yieldAddr = landmarkYieldAddress;
    if (yieldAddr != null && yieldAddr.isNotEmpty) {
      _landmarkYieldContract = DeployedContract(
        ContractAbi.fromJson(_landmarkYieldABI, 'LandmarkYieldNFT'),
        EthereumAddress.fromHex(yieldAddr),
      );
    }

    final stakingAddr = markerStakingAddress;
    if (stakingAddr != null && stakingAddr.isNotEmpty) {
      _markerStakingContract = DeployedContract(
        ContractAbi.fromJson(_markerStakingABI, 'MarkerStakingPool'),
        EthereumAddress.fromHex(stakingAddr),
      );
    }

    final govAddr = governanceAddress;
    if (govAddr != null && govAddr.isNotEmpty) {
      _governanceContract = DeployedContract(
        ContractAbi.fromJson(_governanceABI, 'GovernanceVoting'),
        EthereumAddress.fromHex(govAddr),
      );
    }
  }

  /// Get current chain ID
  int get _chainId => _currentChain?.chainId ?? 5003;

  // ============ RUN Token ============

  /// Get RUN token balance
  Future<BigInt> getRUNBalance() async {
    if (_client == null || _runTokenContract == null || _credentials == null) {
      return BigInt.zero;
    }

    try {
      final result = await _client!.call(
        contract: _runTokenContract!,
        function: _runTokenContract!.function('balanceOf'),
        params: [_credentials!.address],
      );
      return result[0] as BigInt;
    } catch (e) {
      debugPrint('Error getting RUN balance: $e');
      return BigInt.zero;
    }
  }

  /// Activate run multiplier boost
  Future<String?> activateBoost(BigInt runAmount) async {
    if (!isInitialized || _runTokenContract == null) return null;
    if (isRateLimited) {
      debugPrint('Rate limited');
      return null;
    }

    try {
      final tx = Transaction.callContract(
        contract: _runTokenContract!,
        function: _runTokenContract!.function('activateBoost'),
        parameters: [runAmount],
      );

      final txHash = await _client!.sendTransaction(
        _credentials!,
        tx,
        chainId: _chainId,
      );

      _lastOperation = DateTime.now();
      notifyListeners();
      return txHash;
    } catch (e) {
      debugPrint('Error activating boost: $e');
      return null;
    }
  }

  /// Get active boost info
  Future<BoostInfo?> getActiveBoost() async {
    if (_client == null || _runTokenContract == null || _credentials == null) {
      return null;
    }

    try {
      final result = await _client!.call(
        contract: _runTokenContract!,
        function: _runTokenContract!.function('getActiveBoost'),
        params: [_credentials!.address],
      );

      final multiplier = (result[0] as BigInt).toInt();
      final expiresAt = (result[1] as BigInt).toInt();

      if (expiresAt == 0) return null;

      return BoostInfo(
        multiplier: multiplier,
        expiresAt: DateTime.fromMillisecondsSinceEpoch(expiresAt * 1000),
      );
    } catch (e) {
      debugPrint('Error getting boost: $e');
      return null;
    }
  }

  /// Stake RUN tokens for LP yield
  Future<String?> stakeRUN(BigInt amount) async {
    if (!isInitialized || _runTokenContract == null) return null;
    if (isRateLimited) return null;

    try {
      final tx = Transaction.callContract(
        contract: _runTokenContract!,
        function: _runTokenContract!.function('stakeRUN'),
        parameters: [amount],
      );

      final txHash = await _client!.sendTransaction(
        _credentials!,
        tx,
        chainId: _chainId,
      );

      _lastOperation = DateTime.now();
      notifyListeners();
      return txHash;
    } catch (e) {
      debugPrint('Error staking RUN: $e');
      return null;
    }
  }

  /// Unstake RUN tokens
  Future<String?> unstakeRUN(BigInt amount) async {
    if (!isInitialized || _runTokenContract == null) return null;
    if (isRateLimited) return null;

    try {
      final tx = Transaction.callContract(
        contract: _runTokenContract!,
        function: _runTokenContract!.function('unstakeRUN'),
        parameters: [amount],
      );

      final txHash = await _client!.sendTransaction(
        _credentials!,
        tx,
        chainId: _chainId,
      );

      _lastOperation = DateTime.now();
      notifyListeners();
      return txHash;
    } catch (e) {
      debugPrint('Error unstaking RUN: $e');
      return null;
    }
  }

  // ============ Landmark Yield NFT ============

  /// Mint landmark yield token after GPS proof
  Future<String?> mintLandmarkYield({
    required String landmarkHash,
    required double kmRun,
    required String gpsProofHash,
  }) async {
    if (!isInitialized || _landmarkYieldContract == null) return null;
    if (isRateLimited) {
      debugPrint('Rate limited');
      return null;
    }

    try {
      // Convert kmRun to 1e3 precision (5.5km -> 5500)
      final kmRun1e3 = BigInt.from((kmRun * 1000).round());

      final tx = Transaction.callContract(
        contract: _landmarkYieldContract!,
        function: _landmarkYieldContract!.function('mintLandmarkYield'),
        parameters: [
          _credentials!.address,
          _hexToBytes32(landmarkHash),
          kmRun1e3,
          _hexToBytes32(gpsProofHash),
        ],
      );

      final txHash = await _client!.sendTransaction(
        _credentials!,
        tx,
        chainId: _chainId,
      );

      _lastOperation = DateTime.now();
      notifyListeners();
      return txHash;
    } catch (e) {
      debugPrint('Error minting yield token: $e');
      return null;
    }
  }

  /// Claim pending yield from yield tokens
  Future<String?> claimYield(BigInt tokenId) async {
    if (!isInitialized || _landmarkYieldContract == null) return null;
    if (isRateLimited) return null;

    try {
      final tx = Transaction.callContract(
        contract: _landmarkYieldContract!,
        function: _landmarkYieldContract!.function('claimYield'),
        parameters: [tokenId],
      );

      final txHash = await _client!.sendTransaction(
        _credentials!,
        tx,
        chainId: _chainId,
      );

      _lastOperation = DateTime.now();
      notifyListeners();
      return txHash;
    } catch (e) {
      debugPrint('Error claiming yield: $e');
      return null;
    }
  }

  /// Get pending yield for a token
  Future<BigInt> getPendingYield(BigInt tokenId) async {
    if (_client == null || _landmarkYieldContract == null || _credentials == null) {
      return BigInt.zero;
    }

    try {
      final result = await _client!.call(
        contract: _landmarkYieldContract!,
        function: _landmarkYieldContract!.function('getPendingYieldFor'),
        params: [_credentials!.address, tokenId],
      );
      return result[0] as BigInt;
    } catch (e) {
      debugPrint('Error getting pending yield: $e');
      return BigInt.zero;
    }
  }

  // ============ Marker Staking ============

  /// Stake a marker to earn yield
  Future<String?> stakeMarker(int markerId) async {
    if (!isInitialized || _markerStakingContract == null) return null;
    if (isRateLimited) return null;

    try {
      final tx = Transaction.callContract(
        contract: _markerStakingContract!,
        function: _markerStakingContract!.function('stakeMarker'),
        parameters: [BigInt.from(markerId)],
      );

      final txHash = await _client!.sendTransaction(
        _credentials!,
        tx,
        chainId: _chainId,
      );

      _lastOperation = DateTime.now();
      notifyListeners();
      return txHash;
    } catch (e) {
      debugPrint('Error staking marker: $e');
      return null;
    }
  }

  /// Unstake a marker
  Future<String?> unstakeMarker(int markerId) async {
    if (!isInitialized || _markerStakingContract == null) return null;
    if (isRateLimited) return null;

    try {
      final tx = Transaction.callContract(
        contract: _markerStakingContract!,
        function: _markerStakingContract!.function('unstakeMarker'),
        parameters: [BigInt.from(markerId)],
      );

      final txHash = await _client!.sendTransaction(
        _credentials!,
        tx,
        chainId: _chainId,
      );

      _lastOperation = DateTime.now();
      notifyListeners();
      return txHash;
    } catch (e) {
      debugPrint('Error unstaking marker: $e');
      return null;
    }
  }

  /// Claim staking yield
  Future<String?> claimStakingYield() async {
    if (!isInitialized || _markerStakingContract == null) return null;
    if (isRateLimited) return null;

    try {
      final tx = Transaction.callContract(
        contract: _markerStakingContract!,
        function: _markerStakingContract!.function('claimStakingYield'),
        parameters: [],
      );

      final txHash = await _client!.sendTransaction(
        _credentials!,
        tx,
        chainId: _chainId,
      );

      _lastOperation = DateTime.now();
      notifyListeners();
      return txHash;
    } catch (e) {
      debugPrint('Error claiming staking yield: $e');
      return null;
    }
  }

  /// Get user's staked markers
  Future<List<int>> getStakedMarkers() async {
    if (_client == null || _markerStakingContract == null || _credentials == null) {
      return [];
    }

    try {
      final result = await _client!.call(
        contract: _markerStakingContract!,
        function: _markerStakingContract!.function('getUserStakedMarkers'),
        params: [_credentials!.address],
      );

      final markerIds = result[0] as List<dynamic>;
      return markerIds.map((id) => (id as BigInt).toInt()).toList();
    } catch (e) {
      debugPrint('Error getting staked markers: $e');
      return [];
    }
  }

  /// Get staking info for user
  Future<StakingInfo?> getStakingInfo() async {
    if (_client == null || _markerStakingContract == null || _credentials == null) {
      return null;
    }

    try {
      final result = await _client!.call(
        contract: _markerStakingContract!,
        function: _markerStakingContract!.function('getStakingInfo'),
        params: [_credentials!.address],
      );

      final stakedCount = (result[0] as BigInt).toInt();
      final pendingYield = result[1] as BigInt;
      final multiplier = (result[2] as BigInt).toInt();
      final rank = (result[3] as BigInt).toInt();

      // Get APY
      final apyResult = await _client!.call(
        contract: _markerStakingContract!,
        function: _markerStakingContract!.function('getEstimatedAPY'),
        params: [_credentials!.address],
      );
      final apyBps = (apyResult[0] as BigInt).toInt();

      _stakingInfo = StakingInfo(
        totalStakedMarkers: stakedCount,
        pendingYield: pendingYield,
        currentAPY: apyBps / 100, // Convert basis points to percentage
        leaderboardRank: rank,
        multiplier: multiplier / 100, // Convert 200 to 2.0
      );

      notifyListeners();
      return _stakingInfo;
    } catch (e) {
      debugPrint('Error getting staking info: $e');
      return null;
    }
  }

  // ============ Governance ============

  /// Get all active proposals
  Future<List<GovernanceProposal>> getActiveProposals() async {
    if (_client == null || _governanceContract == null) {
      return [];
    }

    try {
      final result = await _client!.call(
        contract: _governanceContract!,
        function: _governanceContract!.function('getActiveProposals'),
        params: [BigInt.zero, BigInt.from(20)],
      );

      final proposalIds = result[0] as List<dynamic>;
      _proposals = [];

      for (final idBigInt in proposalIds) {
        final id = (idBigInt as BigInt).toInt();
        final proposal = await _getProposal(id);
        if (proposal != null) {
          _proposals.add(proposal);
        }
      }

      notifyListeners();
      return _proposals;
    } catch (e) {
      debugPrint('Error getting proposals: $e');
      return [];
    }
  }

  Future<GovernanceProposal?> _getProposal(int proposalId) async {
    if (_client == null || _governanceContract == null) return null;

    try {
      final result = await _client!.call(
        contract: _governanceContract!,
        function: _governanceContract!.function('getProposal'),
        params: [BigInt.from(proposalId)],
      );

      return GovernanceProposal(
        id: (result[0] as BigInt).toInt(),
        proposer: (result[1] as EthereumAddress).hex,
        type: ProposalType.values[(result[2] as BigInt).toInt()],
        description: result[4] as String,
        forVotes: result[5] as BigInt,
        againstVotes: result[6] as BigInt,
        endTime: DateTime.fromMillisecondsSinceEpoch(
          (result[8] as BigInt).toInt() * 1000,
        ),
        status: ProposalStatus.values[(result[9] as BigInt).toInt()],
      );
    } catch (e) {
      debugPrint('Error getting proposal: $e');
      return null;
    }
  }

  /// Vote on a proposal
  Future<String?> vote(int proposalId, bool support) async {
    if (!isInitialized || _governanceContract == null) return null;
    if (isRateLimited) return null;

    try {
      final tx = Transaction.callContract(
        contract: _governanceContract!,
        function: _governanceContract!.function('vote'),
        parameters: [BigInt.from(proposalId), support],
      );

      final txHash = await _client!.sendTransaction(
        _credentials!,
        tx,
        chainId: _chainId,
      );

      _lastOperation = DateTime.now();
      notifyListeners();
      return txHash;
    } catch (e) {
      debugPrint('Error voting: $e');
      return null;
    }
  }

  /// Check if user can propose
  Future<bool> canPropose() async {
    if (_client == null || _governanceContract == null || _credentials == null) {
      return false;
    }

    try {
      final result = await _client!.call(
        contract: _governanceContract!,
        function: _governanceContract!.function('canPropose'),
        params: [_credentials!.address],
      );
      return result[0] as bool;
    } catch (e) {
      debugPrint('Error checking can propose: $e');
      return false;
    }
  }

  // ============ Yield Calculator ============

  /// Calculate monthly passive income estimate
  YieldEstimate calculateYieldEstimate({
    required int markerCount,
    required String city,
    required int leaderboardRank,
  }) {
    // Base yield: 8% APY
    double baseAPY = 8.0;

    // Leaderboard multiplier
    double multiplier = 1.0;
    if (leaderboardRank > 0 && leaderboardRank <= 10) {
      multiplier = 2.0;
    } else if (leaderboardRank <= 50) {
      multiplier = 1.5;
    }

    // Estimated monthly income (in INR for display)
    // Assuming average stake value per marker
    double avgStakeValueINR = 1000; // Per marker approximate value
    double totalStakeValue = markerCount * avgStakeValueINR;
    double monthlyYield = (totalStakeValue * baseAPY * multiplier) / 100 / 12;

    return YieldEstimate(
      markerCount: markerCount,
      city: city,
      baseAPY: baseAPY,
      multiplier: multiplier,
      effectiveAPY: baseAPY * multiplier,
      monthlyYieldINR: monthlyYield,
      annualYieldINR: monthlyYield * 12,
    );
  }

  /// Refresh all RWA data
  Future<void> refresh() async {
    await Future.wait([
      getStakingInfo(),
      getActiveProposals(),
    ]);
    notifyListeners();
  }

  // ============ Helpers ============

  List<int> _hexToBytes32(String hex) {
    if (hex.startsWith('0x')) hex = hex.substring(2);
    final bytes = <int>[];
    for (var i = 0; i < hex.length; i += 2) {
      bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
    }
    // Pad to 32 bytes
    while (bytes.length < 32) {
      bytes.insert(0, 0);
    }
    return bytes;
  }
}

// ============ Data Models ============

class RUNTokenInfo {
  final BigInt balance;
  final BigInt totalSupply;
  final BigInt burned;
  final BigInt yieldPoolBalance;
  final BoostInfo? activeBoost;

  RUNTokenInfo({
    required this.balance,
    required this.totalSupply,
    required this.burned,
    required this.yieldPoolBalance,
    this.activeBoost,
  });
}

class BoostInfo {
  final int multiplier; // 120 = 1.2x
  final DateTime expiresAt;

  BoostInfo({
    required this.multiplier,
    required this.expiresAt,
  });

  bool get isActive => DateTime.now().isBefore(expiresAt);
  double get multiplierValue => multiplier / 100;

  Duration get timeRemaining => expiresAt.difference(DateTime.now());
}

class YieldToken {
  final BigInt tokenId;
  final String landmarkName;
  final String landmarkHash;
  final BigInt balance;
  final BigInt pendingYield;
  final DateTime mintedAt;

  YieldToken({
    required this.tokenId,
    required this.landmarkName,
    required this.landmarkHash,
    required this.balance,
    required this.pendingYield,
    required this.mintedAt,
  });
}

class StakingInfo {
  final int totalStakedMarkers;
  final BigInt pendingYield;
  final double currentAPY;
  final int leaderboardRank;
  final double multiplier;

  StakingInfo({
    required this.totalStakedMarkers,
    required this.pendingYield,
    required this.currentAPY,
    required this.leaderboardRank,
    required this.multiplier,
  });

  String get formattedAPY => '${currentAPY.toStringAsFixed(1)}%';
  String get formattedMultiplier => '${multiplier.toStringAsFixed(1)}x';
}

class StakedMarker {
  final int markerId;
  final String landmarkHash;
  final String landmarkName;
  final DateTime stakedAt;
  final BigInt accumulatedYield;

  StakedMarker({
    required this.markerId,
    required this.landmarkHash,
    required this.landmarkName,
    required this.stakedAt,
    required this.accumulatedYield,
  });
}

class GovernanceProposal {
  final int id;
  final String proposer;
  final ProposalType type;
  final String description;
  final BigInt forVotes;
  final BigInt againstVotes;
  final DateTime endTime;
  final ProposalStatus status;

  GovernanceProposal({
    required this.id,
    required this.proposer,
    required this.type,
    required this.description,
    required this.forVotes,
    required this.againstVotes,
    required this.endTime,
    required this.status,
  });

  bool get isActive => status == ProposalStatus.active;

  double get forPercentage {
    final total = forVotes + againstVotes;
    if (total == BigInt.zero) return 0;
    return (forVotes.toDouble() / total.toDouble()) * 100;
  }

  Duration get timeRemaining => endTime.difference(DateTime.now());
}

enum ProposalType { newLandmark, newCity, parameterChange, custom }
enum ProposalStatus { active, passed, failed, executed, cancelled }

class YieldEstimate {
  final int markerCount;
  final String city;
  final double baseAPY;
  final double multiplier;
  final double effectiveAPY;
  final double monthlyYieldINR;
  final double annualYieldINR;

  YieldEstimate({
    required this.markerCount,
    required this.city,
    required this.baseAPY,
    required this.multiplier,
    required this.effectiveAPY,
    required this.monthlyYieldINR,
    required this.annualYieldINR,
  });

  String get formattedMonthly => 'Rs.${monthlyYieldINR.toStringAsFixed(0)}';
  String get formattedAnnual => 'Rs.${annualYieldINR.toStringAsFixed(0)}';
}
