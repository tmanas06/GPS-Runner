import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String senderColor;
  final String senderCity;
  final String text;
  final DateTime timestamp;
  final String roomId;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderColor,
    this.senderCity = '',
    required this.text,
    required this.timestamp,
    required this.roomId,
  });

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      id: doc.id,
      senderId: data['senderId'] ?? '',
      senderName: data['senderName'] ?? 'Unknown',
      senderColor: data['senderColor'] ?? '#2196F3',
      senderCity: data['senderCity'] ?? '',
      text: data['text'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      roomId: data['roomId'] ?? 'global',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'senderColor': senderColor,
      'senderCity': senderCity,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
      'roomId': roomId,
    };
  }

  ChatMessage copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? senderColor,
    String? senderCity,
    String? text,
    DateTime? timestamp,
    String? roomId,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderColor: senderColor ?? this.senderColor,
      senderCity: senderCity ?? this.senderCity,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      roomId: roomId ?? this.roomId,
    );
  }
}

/// Dynamic chat room that can be created based on player locations
class ChatRoom {
  final String id;
  final String name;
  final String description;
  final String icon;
  final int playerCount;
  final DateTime? lastActivity;
  final String? country;
  final bool isGlobal;

  const ChatRoom({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.playerCount = 0,
    this.lastActivity,
    this.country,
    this.isGlobal = false,
  });

  /// Create a room ID from city name (lowercase, no spaces)
  static String createRoomId(String cityName) {
    return cityName.toLowerCase().replaceAll(' ', '_').replaceAll(RegExp(r'[^a-z0-9_]'), '');
  }

  /// Create a ChatRoom from Firestore document
  factory ChatRoom.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatRoom(
      id: doc.id,
      name: data['name'] ?? doc.id,
      description: data['description'] ?? 'Chat with local players',
      icon: data['icon'] ?? '📍',
      playerCount: data['playerCount'] ?? 0,
      lastActivity: (data['lastActivity'] as Timestamp?)?.toDate(),
      country: data['country'],
      isGlobal: data['isGlobal'] ?? false,
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'icon': icon,
      'playerCount': playerCount,
      'lastActivity': lastActivity != null ? Timestamp.fromDate(lastActivity!) : FieldValue.serverTimestamp(),
      'country': country,
      'isGlobal': isGlobal,
    };
  }

  /// Copy with modified fields
  ChatRoom copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    int? playerCount,
    DateTime? lastActivity,
    String? country,
    bool? isGlobal,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      playerCount: playerCount ?? this.playerCount,
      lastActivity: lastActivity ?? this.lastActivity,
      country: country ?? this.country,
      isGlobal: isGlobal ?? this.isGlobal,
    );
  }

  /// The global chat room (always available)
  static const ChatRoom globalRoom = ChatRoom(
    id: 'global',
    name: 'Global Chat',
    description: 'Chat with all players worldwide',
    icon: '🌍',
    isGlobal: true,
  );

  /// Get icon based on country (can be extended)
  static String getCountryIcon(String? country) {
    if (country == null) return '📍';

    final countryIcons = {
      'India': '🇮🇳',
      'United States': '🇺🇸',
      'United Kingdom': '🇬🇧',
      'Canada': '🇨🇦',
      'Australia': '🇦🇺',
      'Germany': '🇩🇪',
      'France': '🇫🇷',
      'Japan': '🇯🇵',
      'China': '🇨🇳',
      'Brazil': '🇧🇷',
      'Mexico': '🇲🇽',
      'Spain': '🇪🇸',
      'Italy': '🇮🇹',
      'Russia': '🇷🇺',
      'South Korea': '🇰🇷',
    };

    return countryIcons[country] ?? '📍';
  }
}
