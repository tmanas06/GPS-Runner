import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_message.dart';
import 'auth_service.dart';

/// Chat service for real-time messaging using Firebase Firestore
/// Supports dynamic location-based chat rooms
class ChatService extends ChangeNotifier {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  static const String _messagesCollection = 'messages';
  static const String _roomsCollection = 'chat_rooms';
  static const String _presenceCollection = 'chat_presence';
  static const int _messagesPerPage = 50;
  static const Duration _rateLimitDuration = Duration(seconds: 2);
  static const Duration _presenceTimeout = Duration(minutes: 5);

  DateTime? _lastMessageTime;
  bool _isInitialized = false;
  String? _currentRoomId;
  String? _currentCity;
  Timer? _presenceTimer;

  bool get isInitialized => _isInitialized;
  String? get currentRoomId => _currentRoomId;
  String? get currentCity => _currentCity;

  /// Set the current city for the user
  void setCurrentCity(String city) {
    _currentCity = city;
  }

  /// Initialize the chat service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _firestore.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );

      // Ensure global room exists
      await _ensureGlobalRoomExists();

      _isInitialized = true;
      debugPrint('ChatService: Initialized successfully');
    } catch (e) {
      debugPrint('ChatService: Initialization error: $e');
    }
  }

  /// Ensure the global chat room exists
  Future<void> _ensureGlobalRoomExists() async {
    try {
      final globalDoc = await _firestore.collection(_roomsCollection).doc('global').get();
      if (!globalDoc.exists) {
        await _firestore.collection(_roomsCollection).doc('global').set(
          ChatRoom.globalRoom.toFirestore(),
        );
      }
    } catch (e) {
      debugPrint('ChatService: Error creating global room: $e');
    }
  }

  /// Get current user's profile
  PlayerProfile? get currentUser => _authService.profile;

  /// Check if rate limited
  bool get isRateLimited {
    if (_lastMessageTime == null) return false;
    return DateTime.now().difference(_lastMessageTime!) < _rateLimitDuration;
  }

  /// Seconds until rate limit expires
  int get secondsUntilCanSend {
    if (_lastMessageTime == null) return 0;
    final elapsed = DateTime.now().difference(_lastMessageTime!);
    final remaining = _rateLimitDuration - elapsed;
    return remaining.isNegative ? 0 : remaining.inSeconds + 1;
  }

  /// Join or create a city chat room based on location
  Future<ChatRoom?> joinCityRoom({
    required String cityName,
    required String country,
  }) async {
    final user = currentUser;
    if (user == null) return null;

    try {
      final roomId = ChatRoom.createRoomId(cityName);
      final roomRef = _firestore.collection(_roomsCollection).doc(roomId);

      // Check if room exists, create if not
      final roomDoc = await roomRef.get();

      if (!roomDoc.exists) {
        // Create new city room
        final newRoom = ChatRoom(
          id: roomId,
          name: '$cityName Chat',
          description: 'Chat with players in $cityName',
          icon: ChatRoom.getCountryIcon(country),
          playerCount: 1,
          lastActivity: DateTime.now(),
          country: country,
        );

        await roomRef.set(newRoom.toFirestore());
        debugPrint('ChatService: Created new room for $cityName');

        // Update presence for city room
        await _updatePresence(roomId, user.id);
        _currentRoomId = roomId;

        // Also update presence for global room
        await _updatePresence('global', user.id);
        await _updateRoomPlayerCount('global');

        return newRoom;
      } else {
        // Room exists, update player count and presence
        await _updatePresence(roomId, user.id);
        _currentRoomId = roomId;

        // Also update presence for global room
        await _updatePresence('global', user.id);
        await _updateRoomPlayerCount('global');

        return ChatRoom.fromFirestore(roomDoc);
      }
    } catch (e) {
      debugPrint('ChatService: Error joining city room: $e');
      // Return a local room object even if Firestore fails
      _currentRoomId = ChatRoom.createRoomId(cityName);
      return ChatRoom(
        id: _currentRoomId!,
        name: '$cityName Chat',
        description: 'Chat with players in $cityName',
        icon: ChatRoom.getCountryIcon(country),
        playerCount: 0,
        country: country,
      );
    }
  }

  /// Update player presence in a room
  Future<void> _updatePresence(String roomId, String odId) async {
    try {
      final odRef = _firestore
          .collection(_presenceCollection)
          .doc('${roomId}_$odId');

      await odRef.set({
        'odId': odId,
        'roomId': roomId,
        'lastSeen': FieldValue.serverTimestamp(),
        'userName': currentUser?.name ?? 'Unknown',
      });

      // Start presence timer
      _startPresenceTimer(roomId, odId);

      // Update room's player count
      await _updateRoomPlayerCount(roomId);
    } catch (e) {
      debugPrint('ChatService: Error updating presence: $e');
    }
  }

  /// Start timer to keep presence alive
  void _startPresenceTimer(String roomId, String odId) {
    _presenceTimer?.cancel();
    _presenceTimer = Timer.periodic(const Duration(minutes: 2), (_) {
      _updatePresence(roomId, odId);
      // Also keep global room presence alive
      if (roomId != 'global') {
        _updatePresence('global', odId);
      }
    });
  }

  /// Update room's active player count
  Future<void> _updateRoomPlayerCount(String roomId) async {
    try {
      // Simple query - just get all presence docs for this room
      // No compound index needed
      final allPresence = await _firestore
          .collection(_presenceCollection)
          .where('roomId', isEqualTo: roomId)
          .get();

      // Filter active users in memory (last 5 minutes)
      final cutoffTime = DateTime.now().subtract(_presenceTimeout);
      int activeCount = 0;

      for (final doc in allPresence.docs) {
        final lastSeen = (doc.data()['lastSeen'] as Timestamp?)?.toDate();
        if (lastSeen != null && lastSeen.isAfter(cutoffTime)) {
          activeCount++;
        }
      }

      await _firestore.collection(_roomsCollection).doc(roomId).update({
        'playerCount': activeCount,
        'lastActivity': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('ChatService: Error updating player count: $e');
    }
  }

  /// Leave current room (cleanup presence)
  Future<void> leaveCurrentRoom() async {
    final user = currentUser;
    if (user == null) return;

    try {
      _presenceTimer?.cancel();

      // Leave city room presence
      if (_currentRoomId != null) {
        await _firestore
            .collection(_presenceCollection)
            .doc('${_currentRoomId}_${user.id}')
            .delete();
        await _updateRoomPlayerCount(_currentRoomId!);
      }

      // Also leave global room presence
      await _firestore
          .collection(_presenceCollection)
          .doc('global_${user.id}')
          .delete();
      await _updateRoomPlayerCount('global');

      _currentRoomId = null;
    } catch (e) {
      debugPrint('ChatService: Error leaving room: $e');
    }
  }

  /// Get all active chat rooms (sorted by player count)
  Stream<List<ChatRoom>> watchRooms() {
    return _firestore
        .collection(_roomsCollection)
        .orderBy('playerCount', descending: true)
        .snapshots()
        .map((snapshot) {
      final rooms = snapshot.docs
          .map((doc) => ChatRoom.fromFirestore(doc))
          .toList();

      // Ensure global room exists in list
      if (!rooms.any((r) => r.isGlobal || r.id == 'global')) {
        rooms.insert(0, ChatRoom.globalRoom);
      }

      // Always put global room first
      rooms.sort((a, b) {
        if (a.isGlobal || a.id == 'global') return -1;
        if (b.isGlobal || b.id == 'global') return 1;
        return b.playerCount.compareTo(a.playerCount);
      });

      return rooms;
    }).handleError((error) {
      debugPrint('ChatService: Error watching rooms: $error');
      return [ChatRoom.globalRoom];
    });
  }

  /// Get rooms list once
  Future<List<ChatRoom>> getRooms() async {
    try {
      final snapshot = await _firestore
          .collection(_roomsCollection)
          .orderBy('playerCount', descending: true)
          .get();

      final rooms = snapshot.docs
          .map((doc) => ChatRoom.fromFirestore(doc))
          .toList();

      // Ensure global room exists in list
      if (!rooms.any((r) => r.isGlobal || r.id == 'global')) {
        rooms.insert(0, ChatRoom.globalRoom);
      }

      // Always put global room first
      rooms.sort((a, b) {
        if (a.isGlobal || a.id == 'global') return -1;
        if (b.isGlobal || b.id == 'global') return 1;
        return b.playerCount.compareTo(a.playerCount);
      });

      return rooms;
    } catch (e) {
      debugPrint('ChatService: Error getting rooms: $e');
      return [ChatRoom.globalRoom];
    }
  }

  /// Send a message to a chat room
  Future<bool> sendMessage({
    required String roomId,
    required String text,
  }) async {
    final user = currentUser;
    if (user == null) {
      debugPrint('ChatService: Cannot send message - no user logged in');
      return false;
    }

    if (isRateLimited) {
      debugPrint('ChatService: Rate limited - wait $secondsUntilCanSend seconds');
      return false;
    }

    final trimmedText = text.trim();
    if (trimmedText.isEmpty || trimmedText.length > 500) {
      debugPrint('ChatService: Invalid message length');
      return false;
    }

    try {
      final message = ChatMessage(
        id: '',
        senderId: user.id,
        senderName: user.name,
        senderColor: user.color,
        senderCity: _currentCity ?? '',
        text: trimmedText,
        timestamp: DateTime.now(),
        roomId: roomId,
      );

      await _firestore.collection(_messagesCollection).add(message.toFirestore());
      _lastMessageTime = DateTime.now();

      // Update room's last activity
      await _firestore.collection(_roomsCollection).doc(roomId).update({
        'lastActivity': FieldValue.serverTimestamp(),
      });

      debugPrint('ChatService: Message sent successfully!');
      return true;
    } catch (e) {
      debugPrint('ChatService: Error sending message: $e');
      return false;
    }
  }

  /// Get real-time stream of messages for a room
  Stream<List<ChatMessage>> getMessagesStream(String roomId) {
    return _firestore
        .collection(_messagesCollection)
        .where('roomId', isEqualTo: roomId)
        .orderBy('timestamp', descending: true)
        .limit(_messagesPerPage)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ChatMessage.fromFirestore(doc))
          .toList();
    });
  }

  /// Get paginated messages (for loading older messages)
  Future<List<ChatMessage>> getOlderMessages({
    required String roomId,
    required DateTime beforeTimestamp,
    int limit = _messagesPerPage,
  }) async {
    try {
      final snapshot = await _firestore
          .collection(_messagesCollection)
          .where('roomId', isEqualTo: roomId)
          .where('timestamp', isLessThan: Timestamp.fromDate(beforeTimestamp))
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => ChatMessage.fromFirestore(doc))
          .toList();
    } catch (e) {
      debugPrint('ChatService: Error fetching older messages: $e');
      return [];
    }
  }

  /// Get recent messages for a room (one-time fetch)
  Future<List<ChatMessage>> getRecentMessages(String roomId, {int limit = _messagesPerPage}) async {
    try {
      final snapshot = await _firestore
          .collection(_messagesCollection)
          .where('roomId', isEqualTo: roomId)
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => ChatMessage.fromFirestore(doc))
          .toList();
    } catch (e) {
      debugPrint('ChatService: Error fetching recent messages: $e');
      return [];
    }
  }

  /// Get the last message for each room
  Future<Map<String, ChatMessage?>> getLastMessagesForRooms(List<ChatRoom> rooms) async {
    final Map<String, ChatMessage?> lastMessages = {};

    for (final room in rooms) {
      try {
        final snapshot = await _firestore
            .collection(_messagesCollection)
            .where('roomId', isEqualTo: room.id)
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty) {
          lastMessages[room.id] = ChatMessage.fromFirestore(snapshot.docs.first);
        } else {
          lastMessages[room.id] = null;
        }
      } catch (e) {
        debugPrint('ChatService: Error fetching last message for ${room.id}: $e');
        lastMessages[room.id] = null;
      }
    }

    return lastMessages;
  }

  /// Delete a message (only own messages)
  Future<bool> deleteMessage(String messageId) async {
    final user = currentUser;
    if (user == null) return false;

    try {
      final doc = await _firestore.collection(_messagesCollection).doc(messageId).get();
      if (!doc.exists) return false;

      final message = ChatMessage.fromFirestore(doc);
      if (message.senderId != user.id) {
        debugPrint('ChatService: Cannot delete message - not owner');
        return false;
      }

      await _firestore.collection(_messagesCollection).doc(messageId).delete();
      debugPrint('ChatService: Message deleted');
      return true;
    } catch (e) {
      debugPrint('ChatService: Error deleting message: $e');
      return false;
    }
  }

  /// Clean up resources
  void cleanup() {
    _presenceTimer?.cancel();
    leaveCurrentRoom();
  }
}
