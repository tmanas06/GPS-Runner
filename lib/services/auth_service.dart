import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';

/// Authentication state
enum AuthState {
  unknown,
  checking,
  authenticated,
  unauthenticated,
  error,
}

/// Auth provider type
enum AuthProvider {
  anonymous,
  google,
}

/// User profile data
class PlayerProfile {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String color;
  final String walletAddress;
  final AuthProvider authProvider;
  final int totalMarkers;
  final int delhiMarkers;
  final int hydMarkers;
  final DateTime createdAt;

  PlayerProfile({
    required this.id,
    required this.name,
    this.email = '',
    this.photoUrl,
    required this.color,
    required this.walletAddress,
    this.authProvider = AuthProvider.anonymous,
    this.totalMarkers = 0,
    this.delhiMarkers = 0,
    this.hydMarkers = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  PlayerProfile copyWith({
    String? name,
    String? email,
    String? photoUrl,
    String? color,
    String? walletAddress,
    AuthProvider? authProvider,
    int? totalMarkers,
    int? delhiMarkers,
    int? hydMarkers,
  }) {
    return PlayerProfile(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      color: color ?? this.color,
      walletAddress: walletAddress ?? this.walletAddress,
      authProvider: authProvider ?? this.authProvider,
      totalMarkers: totalMarkers ?? this.totalMarkers,
      delhiMarkers: delhiMarkers ?? this.delhiMarkers,
      hydMarkers: hydMarkers ?? this.hydMarkers,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'photoUrl': photoUrl,
        'color': color,
        'walletAddress': walletAddress,
        'authProvider': authProvider.name,
        'totalMarkers': totalMarkers,
        'delhiMarkers': delhiMarkers,
        'hydMarkers': hydMarkers,
        'createdAt': createdAt.toIso8601String(),
      };

  factory PlayerProfile.fromJson(Map<String, dynamic> json) {
    return PlayerProfile(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Anonymous Runner',
      email: json['email'] ?? '',
      photoUrl: json['photoUrl'],
      color: json['color'] ?? '#2196F3',
      walletAddress: json['walletAddress'] ?? '',
      authProvider: json['authProvider'] == 'google'
          ? AuthProvider.google
          : AuthProvider.anonymous,
      totalMarkers: json['totalMarkers'] ?? 0,
      delhiMarkers: json['delhiMarkers'] ?? 0,
      hydMarkers: json['hydMarkers'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}

/// Authentication service with Google Sign-In + Secure Wallet
class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Firebase & Google
  FirebaseAuth? _auth;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );
  bool _firebaseAvailable = false;

  // Secure storage for private keys
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  AuthState _state = AuthState.unknown;
  PlayerProfile? _profile;
  String? _errorMessage;
  String? _privateKey;
  GoogleSignInAccount? _googleAccount;

  // Storage keys
  static const String _profileKey = 'player_profile_v2';
  static const String _walletKey = 'wallet_private_key';
  static const String _localUserIdKey = 'local_user_id';

  // Getters
  AuthState get state => _state;
  PlayerProfile? get profile => _profile;
  String? get errorMessage => _errorMessage;
  String? get playerId => _profile?.id;
  String? get playerName => _profile?.name;
  String? get playerColor => _profile?.color;
  String? get playerEmail => _profile?.email;
  String? get privateKey => _privateKey;
  bool get isAuthenticated => _state == AuthState.authenticated;
  bool get isGoogleSignedIn => _googleAccount != null;
  GoogleSignInAccount? get googleAccount => _googleAccount;
  String get walletAddress => _profile?.walletAddress ?? '';

  /// Initialize auth service
  Future<void> initialize() async {
    _state = AuthState.checking;
    notifyListeners();

    try {
      // Try to initialize Firebase
      try {
        _auth = FirebaseAuth.instance;
        _firebaseAvailable = true;
      } catch (e) {
        debugPrint('Firebase not available, using local auth: $e');
        _firebaseAvailable = false;
      }

      // Check for existing Google Sign-In
      final isSignedIn = await _googleSignIn.isSignedIn();
      if (isSignedIn) {
        _googleAccount = await _googleSignIn.signInSilently();
        if (_googleAccount != null) {
          await _loadProfileForGoogle(_googleAccount!);
          _state = AuthState.authenticated;
          notifyListeners();
          return;
        }
      }

      // Check for existing Firebase/local user
      if (_firebaseAvailable && _auth != null) {
        final currentUser = _auth!.currentUser;
        if (currentUser != null) {
          await _loadProfile(currentUser.uid);
          _state = AuthState.authenticated;
        } else {
          _state = AuthState.unauthenticated;
        }
      } else {
        final prefs = await SharedPreferences.getInstance();
        final localUserId = prefs.getString(_localUserIdKey);
        if (localUserId != null) {
          await _loadProfile(localUserId);
          _state = AuthState.authenticated;
        } else {
          _state = AuthState.unauthenticated;
        }
      }

      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _state = AuthState.error;
      _errorMessage = e.toString();
      notifyListeners();
      debugPrint('Auth error: $e');
    }
  }

  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    _state = AuthState.checking;
    _errorMessage = null;
    notifyListeners();

    try {
      // Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _state = AuthState.unauthenticated;
        _errorMessage = 'Sign in cancelled';
        notifyListeners();
        return false;
      }

      _googleAccount = googleUser;

      // Get auth credentials for Firebase
      if (_firebaseAvailable && _auth != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await _auth!.signInWithCredential(credential);
      }

      // Load or create profile
      await _loadProfileForGoogle(googleUser);

      _state = AuthState.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _state = AuthState.error;
      _errorMessage = e.toString();
      notifyListeners();
      debugPrint('Google Sign-In error: $e');
      return false;
    }
  }

  /// Load profile for Google user
  Future<void> _loadProfileForGoogle(GoogleSignInAccount googleUser) async {
    final prefs = await SharedPreferences.getInstance();
    final uniqueId = 'google_${googleUser.id}';

    // Try to load existing profile
    final profileJson = prefs.getString('${_profileKey}_$uniqueId');
    if (profileJson != null) {
      try {
        _profile = PlayerProfile.fromJson(jsonDecode(profileJson));
      } catch (e) {
        debugPrint('Error parsing profile: $e');
      }
    }

    // Load or generate wallet from secure storage
    _privateKey = await _secureStorage.read(key: '${_walletKey}_$uniqueId');
    if (_privateKey == null) {
      _privateKey = _generatePrivateKeyFromGoogle(googleUser);
      await _secureStorage.write(
        key: '${_walletKey}_$uniqueId',
        value: _privateKey!,
      );
    }

    // Create new profile if needed
    if (_profile == null || _profile!.id != uniqueId) {
      final walletAddress = _deriveWalletAddress(_privateKey!);
      _profile = PlayerProfile(
        id: uniqueId,
        name: googleUser.displayName ?? _generateRunnerName(),
        email: googleUser.email,
        photoUrl: googleUser.photoUrl,
        color: _generateColor(),
        walletAddress: walletAddress,
        authProvider: AuthProvider.google,
      );
      await _saveProfile();
    }
  }

  /// Sign in anonymously
  Future<bool> signInAnonymously() async {
    _state = AuthState.checking;
    _errorMessage = null;
    notifyListeners();

    try {
      String userId;

      if (_firebaseAvailable && _auth != null) {
        final result = await _auth!.signInAnonymously();
        final user = result.user;
        if (user == null) {
          _state = AuthState.error;
          _errorMessage = 'Sign in failed';
          notifyListeners();
          return false;
        }
        userId = user.uid;
      } else {
        final prefs = await SharedPreferences.getInstance();
        var localId = prefs.getString(_localUserIdKey);
        if (localId == null) {
          localId = const Uuid().v4();
          await prefs.setString(_localUserIdKey, localId);
        }
        userId = localId;
      }

      await _loadProfile(userId);
      _state = AuthState.authenticated;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _state = AuthState.error;
      _errorMessage = e.message ?? 'Authentication failed';
      notifyListeners();
      return false;
    } catch (e) {
      _state = AuthState.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Load or create player profile
  Future<void> _loadProfile(String uid) async {
    final prefs = await SharedPreferences.getInstance();

    // Try to load existing profile
    final profileJson = prefs.getString('${_profileKey}_$uid');
    if (profileJson != null) {
      try {
        _profile = PlayerProfile.fromJson(jsonDecode(profileJson));
      } catch (e) {
        debugPrint('Error parsing profile: $e');
      }
    }

    // Load wallet from secure storage
    _privateKey = await _secureStorage.read(key: '${_walletKey}_$uid');
    if (_privateKey == null) {
      _privateKey = _generatePrivateKey();
      await _secureStorage.write(key: '${_walletKey}_$uid', value: _privateKey!);
    }

    // Create new profile if needed
    if (_profile == null || _profile!.id != uid) {
      final walletAddress = _deriveWalletAddress(_privateKey!);
      _profile = PlayerProfile(
        id: uid,
        name: _generateRunnerName(),
        color: _generateColor(),
        walletAddress: walletAddress,
        authProvider: AuthProvider.anonymous,
      );
      await _saveProfile();
    }
  }

  /// Save profile to local storage
  Future<void> _saveProfile() async {
    if (_profile == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      '${_profileKey}_${_profile!.id}',
      jsonEncode(_profile!.toJson()),
    );
  }

  /// Derive wallet address from private key
  String _deriveWalletAddress(String privateKey) {
    // Simple address derivation (first 40 chars of hash)
    final bytes = utf8.encode(privateKey);
    final hash = sha256.convert(bytes);
    return '0x${hash.toString().substring(0, 40)}';
  }

  /// Generate private key deterministically from Google account
  String _generatePrivateKeyFromGoogle(GoogleSignInAccount googleUser) {
    // Create deterministic key from Google ID + email
    final seed = '${googleUser.id}_${googleUser.email}_gpsrunner_v1';
    final bytes = utf8.encode(seed);
    final hash1 = sha256.convert(bytes);
    final hash2 = sha256.convert(utf8.encode(hash1.toString()));
    return hash1.toString().substring(0, 32) + hash2.toString().substring(0, 32);
  }

  /// Update player name
  Future<void> updateName(String name) async {
    if (_profile == null) return;

    _profile = _profile!.copyWith(name: name);
    await _saveProfile();
    notifyListeners();
  }

  /// Update player color
  Future<void> updateColor(String color) async {
    if (_profile == null) return;

    _profile = _profile!.copyWith(color: color);
    await _saveProfile();
    notifyListeners();
  }

  /// Update wallet address
  Future<void> updateWalletAddress(String address) async {
    if (_profile == null) return;

    _profile = _profile!.copyWith(walletAddress: address);
    await _saveProfile();
    notifyListeners();
  }

  /// Update marker counts
  Future<void> updateMarkerCounts({
    int? total,
    int? delhi,
    int? hyd,
  }) async {
    if (_profile == null) return;

    _profile = _profile!.copyWith(
      totalMarkers: total ?? _profile!.totalMarkers,
      delhiMarkers: delhi ?? _profile!.delhiMarkers,
      hydMarkers: hyd ?? _profile!.hydMarkers,
    );
    await _saveProfile();
    notifyListeners();
  }

  /// Export private key (for backup)
  Future<String?> exportPrivateKey() async {
    return _privateKey;
  }

  /// Sign out
  Future<void> signOut() async {
    // Sign out from Google
    if (_googleAccount != null) {
      await _googleSignIn.signOut();
      _googleAccount = null;
    }

    // Sign out from Firebase
    if (_firebaseAvailable && _auth != null) {
      await _auth!.signOut();
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_localUserIdKey);

    _profile = null;
    _privateKey = null;
    _state = AuthState.unauthenticated;
    notifyListeners();
  }

  /// Delete account and data
  Future<void> deleteAccount() async {
    if (_profile != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('${_profileKey}_${_profile!.id}');
      await _secureStorage.delete(key: '${_walletKey}_${_profile!.id}');
    }

    // Sign out from Google
    if (_googleAccount != null) {
      await _googleSignIn.signOut();
      _googleAccount = null;
    }

    if (_firebaseAvailable && _auth != null) {
      try {
        await _auth!.currentUser?.delete();
      } catch (e) {
        debugPrint('Error deleting Firebase user: $e');
      }
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_localUserIdKey);

    _profile = null;
    _privateKey = null;
    _state = AuthState.unauthenticated;
    notifyListeners();
  }

  String _generateRunnerName() {
    final adjectives = [
      'Swift', 'Fast', 'Quick', 'Rapid', 'Speedy',
      'Flying', 'Racing', 'Turbo', 'Lightning', 'Flash',
      'Shadow', 'Storm', 'Thunder', 'Blaze', 'Cosmic',
    ];
    final nouns = [
      'Runner', 'Pacer', 'Sprinter', 'Dasher', 'Racer',
      'Jogger', 'Walker', 'Strider', 'Traveler', 'Explorer',
      'Phoenix', 'Tiger', 'Eagle', 'Panther', 'Wolf',
    ];

    final random = DateTime.now().millisecondsSinceEpoch;
    final adj = adjectives[random % adjectives.length];
    final noun = nouns[(random ~/ 100) % nouns.length];
    final num = (random % 100).toString().padLeft(2, '0');

    return '$adj$noun$num';
  }

  String _generateColor() {
    final colors = [
      '#2196F3', '#4CAF50', '#F44336', '#FF9800',
      '#9C27B0', '#00BCD4', '#E91E63', '#FFEB3B',
    ];

    final random = DateTime.now().millisecondsSinceEpoch;
    return colors[random % colors.length];
  }

  String _generatePrivateKey() {
    const uuid = Uuid();
    final part1 = uuid.v4().replaceAll('-', '');
    final part2 = uuid.v4().replaceAll('-', '');
    return part1 + part2;
  }

  /// Get shortened display name
  String get displayName {
    if (_profile == null) return 'Anonymous';
    if (_profile!.name.length <= 12) return _profile!.name;
    return '${_profile!.name.substring(0, 12)}...';
  }

  /// Get shortened wallet address
  String get shortWalletAddress {
    final addr = _profile?.walletAddress ?? '';
    if (addr.length < 12) return addr;
    return '${addr.substring(0, 6)}...${addr.substring(addr.length - 4)}';
  }
}
