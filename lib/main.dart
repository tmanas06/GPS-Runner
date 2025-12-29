import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';

import 'firebase_options.dart';
import 'services/gps_service.dart';
import 'services/blockchain_service.dart';
import 'services/anti_cheat.dart';
import 'services/isar_db.dart';
import 'services/auth_service.dart';
import 'screens/runner_screen.dart';
import 'screens/city_selector.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/how_to_play_screen.dart';
import 'models/city_bounds.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('=== APP STARTING ===');

  // Lock orientation
  try {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    debugPrint('=== Orientation set ===');
  } catch (e) {
    debugPrint('Orientation error: $e');
  }

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
    ),
  );

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('=== Firebase initialized ===');
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
    // Continue without Firebase for development
  }

  debugPrint('=== Running app ===');
  runApp(const GPSRunnerApp());
}

class GPSRunnerApp extends StatelessWidget {
  const GPSRunnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('=== Building GPSRunnerApp ===');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          debugPrint('=== Creating GPSService ===');
          return GPSService();
        }),
        ChangeNotifierProvider(create: (_) {
          debugPrint('=== Creating BlockchainService ===');
          return BlockchainService();
        }),
        ChangeNotifierProvider(create: (_) {
          debugPrint('=== Creating AntiCheatService ===');
          return AntiCheatService();
        }),
        ChangeNotifierProvider(create: (_) {
          debugPrint('=== Creating IsarDBService ===');
          return IsarDBService();
        }),
        ChangeNotifierProvider(create: (_) {
          debugPrint('=== Creating AuthService ===');
          return AuthService();
        }),
      ],
      child: MaterialApp(
        title: 'GPS Runner Web3',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
          fontFamily: 'Roboto',
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

/// Splash screen with initialization
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  String _status = 'Initializing...';
  bool _hasError = false;
  String? _errorMessage;
  bool _isFirstTimeUser = false;

  @override
  void initState() {
    super.initState();
    debugPrint('=== SplashScreen initState ===');

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _controller.forward();
    debugPrint('=== Starting _initialize ===');
    _initialize();
  }

  Future<void> _initialize() async {
    debugPrint('=== _initialize started ===');
    try {
      // Request permissions
      debugPrint('=== Requesting permissions ===');
      setState(() => _status = 'Requesting permissions...');
      await _requestPermissions();
      debugPrint('=== Permissions done ===');

      // Check if first time user
      _isFirstTimeUser = await HowToPlayScreen.isFirstTimeUser();
      debugPrint('=== First time user: $_isFirstTimeUser ===');

      // Initialize database
      debugPrint('=== Initializing database ===');
      setState(() => _status = 'Initializing database...');
      final db = context.read<IsarDBService>();
      await db.initialize();
      debugPrint('=== Database done ===');

      // Initialize auth
      debugPrint('=== Initializing auth ===');
      setState(() => _status = 'Setting up authentication...');
      final auth = context.read<AuthService>();
      await auth.initialize();
      debugPrint('=== Auth done, isAuthenticated: ${auth.isAuthenticated} ===');

      // Check if already authenticated
      if (auth.isAuthenticated) {
        // Initialize GPS
        debugPrint('=== Initializing GPS ===');
        setState(() => _status = 'Setting up GPS...');
        final gps = context.read<GPSService>();
        await gps.initialize();
        debugPrint('=== GPS done ===');

        // Initialize blockchain
        debugPrint('=== Initializing blockchain ===');
        setState(() => _status = 'Connecting to blockchain...');
        final blockchain = context.read<BlockchainService>();
        if (auth.privateKey != null) {
          await blockchain.initialize(auth.privateKey!);
        }
        debugPrint('=== Blockchain done ===');

        // Done - navigate to map screen
        setState(() => _status = 'Ready!');
        await Future.delayed(const Duration(milliseconds: 500));

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const ProfileScreen(),
            ),
          );

          // Show tutorial for first time users
          if (_isFirstTimeUser) {
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const HowToPlayScreen(isFirstTime: true),
                  ),
                );
              }
            });
          }
        }
      } else {
        // Show login screen
        setState(() => _status = 'Ready!');
        await Future.delayed(const Duration(milliseconds: 500));

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const LoginScreen(),
            ),
          );

          // Show tutorial for first time users after login screen loads
          if (_isFirstTimeUser) {
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const HowToPlayScreen(isFirstTime: true),
                  ),
                );
              }
            });
          }
        }
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
        _status = 'Error occurred';
      });
    }
  }

  Future<void> _requestPermissions() async {
    final permissions = [
      Permission.location,
      Permission.locationAlways,
      Permission.activityRecognition,
      Permission.notification,
    ];

    for (final permission in permissions) {
      final status = await permission.status;
      if (status.isDenied) {
        await permission.request();
      }
    }
  }

  void _navigateToGame(CityConfig city) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const RunnerScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade900,
              Colors.purple.shade900,
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.catching_pokemon,
                      color: Colors.amber,
                      size: 64,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Title
                  const Text(
                    'CRYPTO WALKER',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Subtitle
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.amber.shade700,
                          Colors.orange.shade700,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'WALK TO EARN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Loading indicator
                  if (!_hasError) ...[
                    const SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation(Colors.amber),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _status,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],

                  // Error display
                  if (_hasError) ...[
                    Icon(
                      Icons.error_outline,
                      color: Colors.red.shade400,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Initialization Error',
                      style: TextStyle(
                        color: Colors.red.shade400,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        _errorMessage ?? 'Unknown error',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _hasError = false;
                          _errorMessage = null;
                        });
                        _initialize();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],

                  const SizedBox(height: 48),

                  // Crypto coins preview
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _CryptoBadge(symbol: '₿', name: 'BTC', color: Colors.orange),
                      const SizedBox(width: 16),
                      _CryptoBadge(symbol: 'Ξ', name: 'ETH', color: Colors.blue),
                      const SizedBox(width: 16),
                      _CryptoBadge(symbol: 'Ð', name: 'DOGE', color: Colors.amber),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Blockchain badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.purple.withOpacity(0.5),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.purple,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Polygon Amoy Testnet',
                          style: TextStyle(
                            color: Colors.purple,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _CryptoBadge extends StatelessWidget {
  final String symbol;
  final String name;
  final Color color;

  const _CryptoBadge({
    required this.symbol,
    required this.name,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Text(
              symbol,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
