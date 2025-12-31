import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/chat_message.dart';
import '../services/chat_service.dart';
import 'chat_room_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final ChatService _chatService = ChatService();

  List<ChatRoom> _rooms = [];
  Map<String, ChatMessage?> _lastMessages = {};
  bool _isLoading = true;
  String? _currentCity;
  String? _currentCountry;
  StreamSubscription? _roomsSubscription;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  @override
  void dispose() {
    _roomsSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initializeChat() async {
    await _chatService.initialize();
    await _detectLocation();
    _startWatchingRooms();
  }

  Future<void> _detectLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty && mounted) {
        final place = placemarks.first;

        // Prefer broader location names: city > district > state
        // Avoid small localities like "Mountain View", prefer "California"
        String? detectedCity;

        // First try subAdministrativeArea (district/county level)
        if (place.subAdministrativeArea != null &&
            place.subAdministrativeArea!.isNotEmpty) {
          detectedCity = place.subAdministrativeArea;
        }
        // Then try locality (city)
        else if (place.locality != null && place.locality!.isNotEmpty) {
          detectedCity = place.locality;
        }
        // Fall back to administrativeArea (state/province)
        else if (place.administrativeArea != null &&
                 place.administrativeArea!.isNotEmpty) {
          detectedCity = place.administrativeArea;
        }

        setState(() {
          _currentCity = detectedCity ?? 'Unknown';
          _currentCountry = place.country ?? '';
        });

        // Set current city in chat service for message tagging
        if (_currentCity != null && _currentCity != 'Unknown') {
          _chatService.setCurrentCity(_currentCity!);
        }

        // Auto-join the city chat room
        if (_currentCity != null && _currentCity != 'Unknown') {
          await _chatService.joinCityRoom(
            cityName: _currentCity!,
            country: _currentCountry ?? '',
          );
        }
      }
    } catch (e) {
      debugPrint('ChatListScreen: Error detecting location: $e');
    }
  }

  void _startWatchingRooms() {
    _roomsSubscription = _chatService.watchRooms().listen(
      (rooms) async {
        if (!mounted) return;

        final lastMessages = await _chatService.getLastMessagesForRooms(rooms);

        setState(() {
          _rooms = rooms;
          _lastMessages = lastMessages;
          _isLoading = false;
        });
      },
      onError: (error) {
        debugPrint('ChatListScreen: Error watching rooms: $error');
        if (mounted) {
          setState(() {
            // Show at least global room and user's city room on error
            _rooms = [
              ChatRoom.globalRoom,
              if (_currentCity != null && _currentCity != 'Unknown')
                ChatRoom(
                  id: ChatRoom.createRoomId(_currentCity!),
                  name: '$_currentCity Chat',
                  description: 'Chat with players in $_currentCity',
                  icon: ChatRoom.getCountryIcon(_currentCountry),
                  country: _currentCountry,
                ),
            ];
            _isLoading = false;
          });
        }
      },
    );
  }

  Future<void> _refreshRooms() async {
    final rooms = await _chatService.getRooms();
    final lastMessages = await _chatService.getLastMessagesForRooms(rooms);

    if (mounted) {
      setState(() {
        _rooms = rooms;
        _lastMessages = lastMessages;
      });
    }
  }

  String _formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return '';

    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';

    return '${timestamp.day}/${timestamp.month}';
  }

  @override
  Widget build(BuildContext context) {
    final currentRoomId = _currentCity != null
        ? ChatRoom.createRoomId(_currentCity!)
        : null;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chat Rooms',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            if (_currentCity != null)
              Text(
                '$_currentCity, $_currentCountry',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 12,
                ),
              ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            )
          : RefreshIndicator(
              onRefresh: _refreshRooms,
              child: _rooms.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _rooms.length,
                      itemBuilder: (context, index) {
                        final room = _rooms[index];
                        final lastMessage = _lastMessages[room.id];
                        final isCurrentCity = room.id == currentRoomId;

                        return _ChatRoomTile(
                          room: room,
                          lastMessage: lastMessage,
                          isCurrentCity: isCurrentCity,
                          formatTimestamp: _formatTimestamp,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatRoomScreen(roomId: room.id),
                              ),
                            ).then((_) => _refreshRooms());
                          },
                        );
                      },
                    ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: Colors.grey.shade600,
          ),
          const SizedBox(height: 16),
          Text(
            'No chat rooms yet',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to start chatting!',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatRoomTile extends StatelessWidget {
  final ChatRoom room;
  final ChatMessage? lastMessage;
  final bool isCurrentCity;
  final String Function(DateTime?) formatTimestamp;
  final VoidCallback onTap;

  const _ChatRoomTile({
    required this.room,
    required this.lastMessage,
    required this.isCurrentCity,
    required this.formatTimestamp,
    required this.onTap,
  });

  Color get _roomColor {
    if (room.isGlobal) return Colors.purple;
    if (isCurrentCity) return Colors.green;

    // Generate color based on room name for consistency
    final hash = room.id.hashCode;
    final colors = [
      Colors.blue,
      Colors.teal,
      Colors.orange,
      Colors.pink,
      Colors.indigo,
      Colors.cyan,
    ];
    return colors[hash.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
        border: isCurrentCity
            ? Border.all(color: _roomColor.withOpacity(0.5), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: _roomColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Room Icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: _roomColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      room.icon,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Room Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              room.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isCurrentCity) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _roomColor.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Your City',
                                style: TextStyle(
                                  color: _roomColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      if (lastMessage != null) ...[
                        Text(
                          '${lastMessage!.senderName}: ${lastMessage!.text}',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ] else ...[
                        Text(
                          room.description,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 13,
                          ),
                        ),
                      ],
                      const SizedBox(height: 4),
                      // Player count
                      Row(
                        children: [
                          Icon(
                            Icons.people,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${room.playerCount} ${room.playerCount == 1 ? 'player' : 'players'} online',
                            style: TextStyle(
                              color: room.playerCount > 0
                                  ? Colors.green.shade400
                                  : Colors.grey.shade500,
                              fontSize: 11,
                            ),
                          ),
                          if (room.country != null && !room.isGlobal) ...[
                            const SizedBox(width: 8),
                            Text(
                              room.country!,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                // Timestamp and arrow
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (lastMessage != null)
                      Text(
                        formatTimestamp(lastMessage!.timestamp),
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 11,
                        ),
                      ),
                    const SizedBox(height: 8),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
