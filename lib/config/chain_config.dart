/// Multi-chain configuration for GPS Runner
/// Supports Mantle, Polygon, and BNB chains (testnets & mainnets)

enum ChainType {
  mantleSepolia,
  mantleMainnet,
  polygonAmoy,
  polygonMainnet,
  bnbTestnet,
  bnbMainnet,
}

class ChainConfig {
  final ChainType type;
  final String name;
  final String shortName;
  final int chainId;
  final String rpcUrl;
  final String explorerUrl;
  final String nativeCurrency;
  final String nativeSymbol;
  final int decimals;
  final bool isTestnet;
  final String? faucetUrl;

  // Contract addresses (populated after deployment)
  String? indiaRunnerAddress;
  String? runTokenAddress;
  String? landmarkYieldAddress;
  String? markerStakingAddress;
  String? governanceAddress;
  String? gameTokenAddress; // gMNT, gPOL, or gBNB depending on chain

  ChainConfig({
    required this.type,
    required this.name,
    required this.shortName,
    required this.chainId,
    required this.rpcUrl,
    required this.explorerUrl,
    required this.nativeCurrency,
    required this.nativeSymbol,
    this.decimals = 18,
    required this.isTestnet,
    this.faucetUrl,
    this.indiaRunnerAddress,
    this.runTokenAddress,
    this.landmarkYieldAddress,
    this.markerStakingAddress,
    this.governanceAddress,
    this.gameTokenAddress,
  });

  String get explorerTxUrl => '$explorerUrl/tx/';
  String get explorerAddressUrl => '$explorerUrl/address/';

  bool get hasContracts =>
      indiaRunnerAddress != null &&
      runTokenAddress != null &&
      landmarkYieldAddress != null &&
      markerStakingAddress != null &&
      governanceAddress != null;

  /// Game token symbol for this chain
  String get gameTokenSymbol {
    switch (type) {
      case ChainType.mantleSepolia:
      case ChainType.mantleMainnet:
        return 'gMNT';
      case ChainType.polygonAmoy:
      case ChainType.polygonMainnet:
        return 'gPOL';
      case ChainType.bnbTestnet:
      case ChainType.bnbMainnet:
        return 'gBNB';
    }
  }

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'name': name,
        'chainId': chainId,
        'rpcUrl': rpcUrl,
        'explorerUrl': explorerUrl,
        'isTestnet': isTestnet,
        'contracts': {
          'indiaRunner': indiaRunnerAddress,
          'runToken': runTokenAddress,
          'landmarkYield': landmarkYieldAddress,
          'markerStaking': markerStakingAddress,
          'governance': governanceAddress,
          'gameToken': gameTokenAddress,
        },
      };
}

/// All supported chains configuration
class SupportedChains {
  // ============ TESTNETS ============

  static final mantleSepolia = ChainConfig(
    type: ChainType.mantleSepolia,
    name: 'Mantle Sepolia Testnet',
    shortName: 'Mantle Sepolia',
    chainId: 5003,
    rpcUrl: 'https://rpc.sepolia.mantle.xyz',
    explorerUrl: 'https://sepolia.mantlescan.xyz',
    nativeCurrency: 'Mantle',
    nativeSymbol: 'MNT',
    isTestnet: true,
    faucetUrl: 'https://faucet.sepolia.mantle.xyz',
    // Deployed contracts
    indiaRunnerAddress: '0x94ec3cA5359A20f01912f4F7e4D464C8A52f467b',
    runTokenAddress: '0x33c070F5225E8d5715692968183031dF1B401d44',
    landmarkYieldAddress: '0x2aCF95D108fF556A7134Acb01E01a44Ef176FCe3',
    markerStakingAddress: '0xd4DD97Be46D3DDB73BC559b327bF834BB7b5fAb3',
    governanceAddress: '0xFea52444879192b7Cd874fc4b7C64dD29F7791E9',
    gameTokenAddress: '0x79A5B42530fDa67638ED2Ac33fa8D1eb50c6B7F7', // gMNT
  );

  static final polygonAmoy = ChainConfig(
    type: ChainType.polygonAmoy,
    name: 'Polygon Amoy Testnet',
    shortName: 'Polygon Amoy',
    chainId: 80002,
    rpcUrl: 'https://rpc-amoy.polygon.technology',
    explorerUrl: 'https://amoy.polygonscan.com',
    nativeCurrency: 'MATIC',
    nativeSymbol: 'MATIC',
    isTestnet: true,
    faucetUrl: 'https://faucet.polygon.technology',
    // Deployed contracts
    indiaRunnerAddress: '0x2aCF95D108fF556A7134Acb01E01a44Ef176FCe3',
    runTokenAddress: '0xd4DD97Be46D3DDB73BC559b327bF834BB7b5fAb3',
    landmarkYieldAddress: '0xFea52444879192b7Cd874fc4b7C64dD29F7791E9',
    markerStakingAddress: '0xac82A2bc28ec31f48635E946cc76b9EE59592bC4',
    governanceAddress: '0x9F9bD55d3a73773b9A3b4F9A66d21D17cc7cc8AF',
    gameTokenAddress: '0x89586D8FF2A671F5951AdCf9222ac93C52cF4DF5', // gPOL
  );

  static final bnbTestnet = ChainConfig(
    type: ChainType.bnbTestnet,
    name: 'BNB Smart Chain Testnet',
    shortName: 'BSC Testnet',
    chainId: 97,
    rpcUrl: 'https://data-seed-prebsc-1-s1.bnbchain.org:8545',
    explorerUrl: 'https://testnet.bscscan.com',
    nativeCurrency: 'BNB',
    nativeSymbol: 'tBNB',
    isTestnet: true,
    faucetUrl: 'https://testnet.bnbchain.org/faucet-smart',
    // Deployed contracts
    indiaRunnerAddress: '0x94ec3cA5359A20f01912f4F7e4D464C8A52f467b',
    runTokenAddress: '0x33c070F5225E8d5715692968183031dF1B401d44',
    landmarkYieldAddress: '0x2aCF95D108fF556A7134Acb01E01a44Ef176FCe3',
    markerStakingAddress: '0xd4DD97Be46D3DDB73BC559b327bF834BB7b5fAb3',
    governanceAddress: '0xFea52444879192b7Cd874fc4b7C64dD29F7791E9',
    gameTokenAddress: '0x79A5B42530fDa67638ED2Ac33fa8D1eb50c6B7F7', // gBNB
  );

  // ============ MAINNETS ============

  static final mantleMainnet = ChainConfig(
    type: ChainType.mantleMainnet,
    name: 'Mantle',
    shortName: 'Mantle',
    chainId: 5000,
    rpcUrl: 'https://rpc.mantle.xyz',
    explorerUrl: 'https://mantlescan.xyz',
    nativeCurrency: 'Mantle',
    nativeSymbol: 'MNT',
    isTestnet: false,
    // TODO: Deploy contracts
  );

  static final polygonMainnet = ChainConfig(
    type: ChainType.polygonMainnet,
    name: 'Polygon',
    shortName: 'Polygon',
    chainId: 137,
    rpcUrl: 'https://polygon-rpc.com',
    explorerUrl: 'https://polygonscan.com',
    nativeCurrency: 'MATIC',
    nativeSymbol: 'MATIC',
    isTestnet: false,
    // TODO: Deploy contracts
  );

  static final bnbMainnet = ChainConfig(
    type: ChainType.bnbMainnet,
    name: 'BNB Smart Chain',
    shortName: 'BSC',
    chainId: 56,
    rpcUrl: 'https://bsc-dataseed.bnbchain.org',
    explorerUrl: 'https://bscscan.com',
    nativeCurrency: 'BNB',
    nativeSymbol: 'BNB',
    isTestnet: false,
    // TODO: Deploy contracts
  );

  // ============ HELPERS ============

  /// All testnets
  static List<ChainConfig> get testnets => [
        mantleSepolia,
        polygonAmoy,
        bnbTestnet,
      ];

  /// All mainnets
  static List<ChainConfig> get mainnets => [
        mantleMainnet,
        polygonMainnet,
        bnbMainnet,
      ];

  /// All chains
  static List<ChainConfig> get all => [...testnets, ...mainnets];

  /// Get chain by type
  static ChainConfig getByType(ChainType type) {
    return all.firstWhere((c) => c.type == type);
  }

  /// Get chain by chainId
  static ChainConfig? getByChainId(int chainId) {
    try {
      return all.firstWhere((c) => c.chainId == chainId);
    } catch (_) {
      return null;
    }
  }

  /// Default chain (Mantle Sepolia for development)
  static ChainConfig get defaultChain => mantleSepolia;

  /// Get chains with deployed contracts
  static List<ChainConfig> get deployedChains =>
      all.where((c) => c.hasContracts).toList();
}

/// Chain-specific contract addresses holder
class MultiChainContracts {
  final Map<ChainType, ChainConfig> _chains = {};

  MultiChainContracts() {
    // Initialize with default configs
    for (final chain in SupportedChains.all) {
      _chains[chain.type] = chain;
    }
  }

  ChainConfig? getChain(ChainType type) => _chains[type];

  void updateContracts(
    ChainType type, {
    String? indiaRunner,
    String? runToken,
    String? landmarkYield,
    String? markerStaking,
    String? governance,
    String? gameToken,
  }) {
    final chain = _chains[type];
    if (chain != null) {
      chain.indiaRunnerAddress = indiaRunner ?? chain.indiaRunnerAddress;
      chain.runTokenAddress = runToken ?? chain.runTokenAddress;
      chain.landmarkYieldAddress = landmarkYield ?? chain.landmarkYieldAddress;
      chain.markerStakingAddress = markerStaking ?? chain.markerStakingAddress;
      chain.governanceAddress = governance ?? chain.governanceAddress;
      chain.gameTokenAddress = gameToken ?? chain.gameTokenAddress;
    }
  }
}
