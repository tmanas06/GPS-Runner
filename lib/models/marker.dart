/// Represents a GPS marker placed by a player on the map
class GPSMarker {
  int id;
  String playerId;
  String playerName;
  double latitude;
  double longitude;
  String city; // 'delhi' or 'hyderabad'
  String color; // Hex color code
  String landmarkName;
  int timestamp;
  String activityProof; // 'running', 'walking', etc.
  double speedKmh;
  int stepsPerMin;
  String txHash; // Blockchain transaction hash
  bool syncedToChain;

  GPSMarker({
    this.id = 0,
    required this.playerId,
    required this.playerName,
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.color,
    required this.landmarkName,
    required this.activityProof,
    required this.speedKmh,
    required this.stepsPerMin,
    this.txHash = '',
    this.syncedToChain = false,
    int? timestamp,
  }) : timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;

  GPSMarker.create({
    required this.playerId,
    required this.playerName,
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.color,
    required this.landmarkName,
    required this.activityProof,
    required this.speedKmh,
    required this.stepsPerMin,
    this.txHash = '',
    this.syncedToChain = false,
  })  : id = 0,
        timestamp = DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toJson() => {
        'id': id,
        'playerId': playerId,
        'playerName': playerName,
        'latitude': latitude,
        'longitude': longitude,
        'city': city,
        'color': color,
        'landmarkName': landmarkName,
        'timestamp': timestamp,
        'activityProof': activityProof,
        'speedKmh': speedKmh,
        'stepsPerMin': stepsPerMin,
        'txHash': txHash,
        'syncedToChain': syncedToChain,
      };

  factory GPSMarker.fromJson(Map<String, dynamic> json) {
    return GPSMarker(
      id: json['id'] ?? 0,
      playerId: json['playerId'] ?? '',
      playerName: json['playerName'] ?? 'Anonymous',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      city: json['city'] ?? 'delhi',
      color: json['color'] ?? '#2196F3',
      landmarkName: json['landmarkName'] ?? 'Unknown',
      timestamp: json['timestamp'] ?? DateTime.now().millisecondsSinceEpoch,
      activityProof: json['activityProof'] ?? 'unknown',
      speedKmh: (json['speedKmh'] ?? 0).toDouble(),
      stepsPerMin: json['stepsPerMin'] ?? 0,
      txHash: json['txHash'] ?? '',
      syncedToChain: json['syncedToChain'] ?? false,
    );
  }

  GPSMarker copyWith({
    int? id,
    String? playerId,
    String? playerName,
    double? latitude,
    double? longitude,
    String? city,
    String? color,
    String? landmarkName,
    int? timestamp,
    String? activityProof,
    double? speedKmh,
    int? stepsPerMin,
    String? txHash,
    bool? syncedToChain,
  }) {
    return GPSMarker(
      id: id ?? this.id,
      playerId: playerId ?? this.playerId,
      playerName: playerName ?? this.playerName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      city: city ?? this.city,
      color: color ?? this.color,
      landmarkName: landmarkName ?? this.landmarkName,
      timestamp: timestamp ?? this.timestamp,
      activityProof: activityProof ?? this.activityProof,
      speedKmh: speedKmh ?? this.speedKmh,
      stepsPerMin: stepsPerMin ?? this.stepsPerMin,
      txHash: txHash ?? this.txHash,
      syncedToChain: syncedToChain ?? this.syncedToChain,
    );
  }
}

/// Live marker for real-time display (not persisted)
class LiveMarker {
  final String playerId;
  final String playerName;
  final double latitude;
  final double longitude;
  final String city;
  final String color;
  final String landmarkName;
  final DateTime lastUpdate;
  final bool isCurrentUser;

  LiveMarker({
    required this.playerId,
    required this.playerName,
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.color,
    required this.landmarkName,
    DateTime? lastUpdate,
    this.isCurrentUser = false,
  }) : lastUpdate = lastUpdate ?? DateTime.now();

  factory LiveMarker.fromGPSMarker(GPSMarker marker, {bool isCurrentUser = false}) {
    return LiveMarker(
      playerId: marker.playerId,
      playerName: marker.playerName,
      latitude: marker.latitude,
      longitude: marker.longitude,
      city: marker.city,
      color: marker.color,
      landmarkName: marker.landmarkName,
      lastUpdate: DateTime.fromMillisecondsSinceEpoch(marker.timestamp),
      isCurrentUser: isCurrentUser,
    );
  }
}
