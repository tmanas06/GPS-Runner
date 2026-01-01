import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:latlong2/latlong.dart';

/// Landmark definition with coordinates
class Landmark {
  final String name;
  final LatLng location;
  final double radiusMeters;
  final int points;

  const Landmark({
    required this.name,
    required this.location,
    this.radiusMeters = 100,
    this.points = 10,
  });

  bool containsPoint(double lat, double lng) {
    const distance = Distance();
    final d = distance.as(LengthUnit.Meter, location, LatLng(lat, lng));
    return d <= radiusMeters;
  }
}

/// City configuration with bounds
class CityConfig {
  final String id;
  final String name;
  final String stateId;
  final String emoji;
  final double minLat;
  final double maxLat;
  final double minLng;
  final double maxLng;
  final String defaultColor;
  final LatLng center;
  final List<Landmark> landmarks;

  const CityConfig({
    required this.id,
    required this.name,
    required this.stateId,
    required this.emoji,
    required this.minLat,
    required this.maxLat,
    required this.minLng,
    required this.maxLng,
    required this.defaultColor,
    required this.center,
    this.landmarks = const [],
  });

  bool containsPoint(double lat, double lng) {
    return lat >= minLat && lat <= maxLat && lng >= minLng && lng <= maxLng;
  }

  Landmark? getLandmarkAt(double lat, double lng) {
    for (final landmark in landmarks) {
      if (landmark.containsPoint(lat, lng)) {
        return landmark;
      }
    }
    return null;
  }

  /// Convert to 1e6 integers for blockchain
  int get minLat1e6 => (minLat * 1e6).round();
  int get maxLat1e6 => (maxLat * 1e6).round();
  int get minLng1e6 => (minLng * 1e6).round();
  int get maxLng1e6 => (maxLng * 1e6).round();

  /// Get city hash for blockchain
  String get cityHash => _hashString(id);

  /// Get state hash for blockchain
  String get stateHash => _hashString(stateId);
}

/// State configuration
class StateConfig {
  final String id;
  final String name;
  final String emoji;
  final double minLat;
  final double maxLat;
  final double minLng;
  final double maxLng;
  final LatLng center;
  final List<CityConfig> cities;

  const StateConfig({
    required this.id,
    required this.name,
    required this.emoji,
    required this.minLat,
    required this.maxLat,
    required this.minLng,
    required this.maxLng,
    required this.center,
    required this.cities,
  });

  bool containsPoint(double lat, double lng) {
    return lat >= minLat && lat <= maxLat && lng >= minLng && lng <= maxLng;
  }

  CityConfig? detectCity(double lat, double lng) {
    for (final city in cities) {
      if (city.containsPoint(lat, lng)) {
        return city;
      }
    }
    // Return a generic city for the state if no specific city matches
    return null;
  }

  /// Get state hash for blockchain
  String get stateHash => _hashString(id);
}

/// Helper function to hash strings for blockchain
String _hashString(String input) {
  final bytes = utf8.encode(input.toLowerCase());
  final digest = sha256.convert(bytes);
  return '0x${digest.toString().substring(0, 64)}';
}

/// India bounds and configuration manager
class CityBounds {
  // Unified India contract address - UPDATE AFTER DEPLOYMENT
  static const String indiaContractAddress =
      '0x0000000000000000000000000000000000000000'; // TODO: Update after deploy

  // Legacy contract addresses (for migration)
  static const String delhiContractAddress =
      '0x1234567890123456789012345678901234567890';
  static const String hydContractAddress =
      '0x0987654321098765432109876543210987654321';

  // ============ Indian States ============

  static const delhi = StateConfig(
    id: 'delhi',
    name: 'Delhi',
    emoji: '🏛️',
    minLat: 28.40,
    maxLat: 28.88,
    minLng: 76.84,
    maxLng: 77.35,
    center: LatLng(28.6139, 77.2090),
    cities: [
      CityConfig(
        id: 'new_delhi',
        name: 'New Delhi',
        stateId: 'delhi',
        emoji: '🏛️',
        minLat: 28.50,
        maxLat: 28.70,
        minLng: 77.10,
        maxLng: 77.30,
        defaultColor: '#2196F3',
        center: LatLng(28.6139, 77.2090),
        landmarks: [
          Landmark(name: 'India Gate', location: LatLng(28.6129, 77.2295), radiusMeters: 200, points: 50),
          Landmark(name: 'Red Fort', location: LatLng(28.6562, 77.2410), radiusMeters: 300, points: 50),
          Landmark(name: 'Connaught Place', location: LatLng(28.6315, 77.2167), radiusMeters: 400, points: 30),
          Landmark(name: 'Lotus Temple', location: LatLng(28.5535, 77.2588), radiusMeters: 150, points: 40),
          Landmark(name: 'Qutub Minar', location: LatLng(28.5245, 77.1855), radiusMeters: 200, points: 50),
        ],
      ),
      CityConfig(
        id: 'south_delhi',
        name: 'South Delhi',
        stateId: 'delhi',
        emoji: '🏙️',
        minLat: 28.40,
        maxLat: 28.55,
        minLng: 77.10,
        maxLng: 77.35,
        defaultColor: '#3F51B5',
        center: LatLng(28.5245, 77.2066),
      ),
      CityConfig(
        id: 'north_delhi',
        name: 'North Delhi',
        stateId: 'delhi',
        emoji: '🏙️',
        minLat: 28.70,
        maxLat: 28.88,
        minLng: 77.15,
        maxLng: 77.25,
        defaultColor: '#673AB7',
        center: LatLng(28.7500, 77.2000),
      ),
    ],
  );

  static const telangana = StateConfig(
    id: 'telangana',
    name: 'Telangana',
    emoji: '🕌',
    minLat: 15.80,
    maxLat: 19.90,
    minLng: 77.20,
    maxLng: 81.35,
    center: LatLng(17.3850, 78.4867),
    cities: [
      CityConfig(
        id: 'hyderabad',
        name: 'Hyderabad',
        stateId: 'telangana',
        emoji: '🕌',
        minLat: 17.20,
        maxLat: 17.60,
        minLng: 78.20,
        maxLng: 78.70,
        defaultColor: '#4CAF50',
        center: LatLng(17.3850, 78.4867),
        landmarks: [
          Landmark(name: 'Charminar', location: LatLng(17.3616, 78.4747), radiusMeters: 200, points: 50),
          Landmark(name: 'Golconda Fort', location: LatLng(17.3833, 78.4011), radiusMeters: 400, points: 50),
          Landmark(name: 'Hussain Sagar', location: LatLng(17.4239, 78.4738), radiusMeters: 500, points: 30),
          Landmark(name: 'HITEC City', location: LatLng(17.4435, 78.3772), radiusMeters: 500, points: 20),
        ],
      ),
      CityConfig(
        id: 'warangal',
        name: 'Warangal',
        stateId: 'telangana',
        emoji: '🏰',
        minLat: 17.90,
        maxLat: 18.10,
        minLng: 79.50,
        maxLng: 79.70,
        defaultColor: '#8BC34A',
        center: LatLng(17.9784, 79.5941),
      ),
    ],
  );

  static const maharashtra = StateConfig(
    id: 'maharashtra',
    name: 'Maharashtra',
    emoji: '🌆',
    minLat: 15.60,
    maxLat: 22.00,
    minLng: 72.60,
    maxLng: 80.90,
    center: LatLng(19.0760, 72.8777),
    cities: [
      CityConfig(
        id: 'mumbai',
        name: 'Mumbai',
        stateId: 'maharashtra',
        emoji: '🌆',
        minLat: 18.85,
        maxLat: 19.30,
        minLng: 72.75,
        maxLng: 73.00,
        defaultColor: '#FF5722',
        center: LatLng(19.0760, 72.8777),
        landmarks: [
          Landmark(name: 'Gateway of India', location: LatLng(18.9220, 72.8347), radiusMeters: 200, points: 50),
          Landmark(name: 'Marine Drive', location: LatLng(18.9432, 72.8235), radiusMeters: 500, points: 30),
          Landmark(name: 'Chhatrapati Shivaji Terminus', location: LatLng(18.9398, 72.8355), radiusMeters: 200, points: 40),
        ],
      ),
      CityConfig(
        id: 'pune',
        name: 'Pune',
        stateId: 'maharashtra',
        emoji: '🏫',
        minLat: 18.40,
        maxLat: 18.65,
        minLng: 73.70,
        maxLng: 74.00,
        defaultColor: '#FF9800',
        center: LatLng(18.5204, 73.8567),
        landmarks: [
          Landmark(name: 'Shaniwar Wada', location: LatLng(18.5195, 73.8553), radiusMeters: 150, points: 40),
          Landmark(name: 'Aga Khan Palace', location: LatLng(18.5525, 73.9015), radiusMeters: 200, points: 40),
        ],
      ),
      CityConfig(
        id: 'nagpur',
        name: 'Nagpur',
        stateId: 'maharashtra',
        emoji: '🍊',
        minLat: 21.05,
        maxLat: 21.25,
        minLng: 78.95,
        maxLng: 79.20,
        defaultColor: '#FFC107',
        center: LatLng(21.1458, 79.0882),
      ),
    ],
  );

  static const karnataka = StateConfig(
    id: 'karnataka',
    name: 'Karnataka',
    emoji: '🏯',
    minLat: 11.60,
    maxLat: 18.45,
    minLng: 74.05,
    maxLng: 78.60,
    center: LatLng(12.9716, 77.5946),
    cities: [
      CityConfig(
        id: 'bengaluru',
        name: 'Bengaluru',
        stateId: 'karnataka',
        emoji: '💻',
        minLat: 12.80,
        maxLat: 13.20,
        minLng: 77.40,
        maxLng: 77.80,
        defaultColor: '#9C27B0',
        center: LatLng(12.9716, 77.5946),
        landmarks: [
          Landmark(name: 'Vidhana Soudha', location: LatLng(12.9791, 77.5913), radiusMeters: 200, points: 40),
          Landmark(name: 'Cubbon Park', location: LatLng(12.9763, 77.5929), radiusMeters: 500, points: 30),
          Landmark(name: 'Lalbagh', location: LatLng(12.9507, 77.5848), radiusMeters: 400, points: 30),
        ],
      ),
      CityConfig(
        id: 'mysuru',
        name: 'Mysuru',
        stateId: 'karnataka',
        emoji: '🏰',
        minLat: 12.25,
        maxLat: 12.40,
        minLng: 76.55,
        maxLng: 76.75,
        defaultColor: '#E91E63',
        center: LatLng(12.2958, 76.6394),
        landmarks: [
          Landmark(name: 'Mysore Palace', location: LatLng(12.3052, 76.6552), radiusMeters: 300, points: 50),
        ],
      ),
    ],
  );

  static const tamilNadu = StateConfig(
    id: 'tamil_nadu',
    name: 'Tamil Nadu',
    emoji: '🛕',
    minLat: 8.00,
    maxLat: 13.60,
    minLng: 76.20,
    maxLng: 80.40,
    center: LatLng(13.0827, 80.2707),
    cities: [
      CityConfig(
        id: 'chennai',
        name: 'Chennai',
        stateId: 'tamil_nadu',
        emoji: '🏖️',
        minLat: 12.85,
        maxLat: 13.25,
        minLng: 80.10,
        maxLng: 80.35,
        defaultColor: '#00BCD4',
        center: LatLng(13.0827, 80.2707),
        landmarks: [
          Landmark(name: 'Marina Beach', location: LatLng(13.0500, 80.2824), radiusMeters: 500, points: 30),
          Landmark(name: 'Fort St. George', location: LatLng(13.0798, 80.2876), radiusMeters: 300, points: 40),
        ],
      ),
      CityConfig(
        id: 'coimbatore',
        name: 'Coimbatore',
        stateId: 'tamil_nadu',
        emoji: '🏭',
        minLat: 10.90,
        maxLat: 11.10,
        minLng: 76.90,
        maxLng: 77.10,
        defaultColor: '#009688',
        center: LatLng(11.0168, 76.9558),
      ),
      CityConfig(
        id: 'madurai',
        name: 'Madurai',
        stateId: 'tamil_nadu',
        emoji: '🛕',
        minLat: 9.85,
        maxLat: 10.00,
        minLng: 78.05,
        maxLng: 78.20,
        defaultColor: '#795548',
        center: LatLng(9.9252, 78.1198),
        landmarks: [
          Landmark(name: 'Meenakshi Temple', location: LatLng(9.9195, 78.1193), radiusMeters: 300, points: 50),
        ],
      ),
    ],
  );

  static const gujarat = StateConfig(
    id: 'gujarat',
    name: 'Gujarat',
    emoji: '🦁',
    minLat: 20.10,
    maxLat: 24.70,
    minLng: 68.10,
    maxLng: 74.50,
    center: LatLng(23.0225, 72.5714),
    cities: [
      CityConfig(
        id: 'ahmedabad',
        name: 'Ahmedabad',
        stateId: 'gujarat',
        emoji: '🏛️',
        minLat: 22.90,
        maxLat: 23.15,
        minLng: 72.45,
        maxLng: 72.70,
        defaultColor: '#FFEB3B',
        center: LatLng(23.0225, 72.5714),
        landmarks: [
          Landmark(name: 'Sabarmati Ashram', location: LatLng(23.0607, 72.5800), radiusMeters: 200, points: 50),
        ],
      ),
      CityConfig(
        id: 'surat',
        name: 'Surat',
        stateId: 'gujarat',
        emoji: '💎',
        minLat: 21.10,
        maxLat: 21.30,
        minLng: 72.75,
        maxLng: 72.95,
        defaultColor: '#CDDC39',
        center: LatLng(21.1702, 72.8311),
      ),
    ],
  );

  static const rajasthan = StateConfig(
    id: 'rajasthan',
    name: 'Rajasthan',
    emoji: '🏜️',
    minLat: 23.05,
    maxLat: 30.20,
    minLng: 69.50,
    maxLng: 78.30,
    center: LatLng(26.9124, 75.7873),
    cities: [
      CityConfig(
        id: 'jaipur',
        name: 'Jaipur',
        stateId: 'rajasthan',
        emoji: '🏰',
        minLat: 26.80,
        maxLat: 27.05,
        minLng: 75.70,
        maxLng: 75.90,
        defaultColor: '#E91E63',
        center: LatLng(26.9124, 75.7873),
        landmarks: [
          Landmark(name: 'Hawa Mahal', location: LatLng(26.9239, 75.8267), radiusMeters: 150, points: 50),
          Landmark(name: 'Amber Fort', location: LatLng(26.9855, 75.8513), radiusMeters: 400, points: 50),
          Landmark(name: 'City Palace', location: LatLng(26.9258, 75.8237), radiusMeters: 300, points: 40),
        ],
      ),
      CityConfig(
        id: 'udaipur',
        name: 'Udaipur',
        stateId: 'rajasthan',
        emoji: '🏯',
        minLat: 24.50,
        maxLat: 24.65,
        minLng: 73.60,
        maxLng: 73.80,
        defaultColor: '#F06292',
        center: LatLng(24.5854, 73.7125),
        landmarks: [
          Landmark(name: 'City Palace Udaipur', location: LatLng(24.5764, 73.6913), radiusMeters: 300, points: 50),
          Landmark(name: 'Lake Pichola', location: LatLng(24.5726, 73.6784), radiusMeters: 500, points: 30),
        ],
      ),
      CityConfig(
        id: 'jodhpur',
        name: 'Jodhpur',
        stateId: 'rajasthan',
        emoji: '🏰',
        minLat: 26.20,
        maxLat: 26.40,
        minLng: 72.95,
        maxLng: 73.15,
        defaultColor: '#CE93D8',
        center: LatLng(26.2389, 73.0243),
        landmarks: [
          Landmark(name: 'Mehrangarh Fort', location: LatLng(26.2979, 73.0188), radiusMeters: 400, points: 50),
        ],
      ),
    ],
  );

  static const westBengal = StateConfig(
    id: 'west_bengal',
    name: 'West Bengal',
    emoji: '🌸',
    minLat: 21.50,
    maxLat: 27.25,
    minLng: 85.80,
    maxLng: 89.90,
    center: LatLng(22.5726, 88.3639),
    cities: [
      CityConfig(
        id: 'kolkata',
        name: 'Kolkata',
        stateId: 'west_bengal',
        emoji: '🌉',
        minLat: 22.40,
        maxLat: 22.70,
        minLng: 88.20,
        maxLng: 88.50,
        defaultColor: '#607D8B',
        center: LatLng(22.5726, 88.3639),
        landmarks: [
          Landmark(name: 'Victoria Memorial', location: LatLng(22.5448, 88.3426), radiusMeters: 300, points: 50),
          Landmark(name: 'Howrah Bridge', location: LatLng(22.5851, 88.3468), radiusMeters: 400, points: 40),
        ],
      ),
    ],
  );

  static const kerala = StateConfig(
    id: 'kerala',
    name: 'Kerala',
    emoji: '🌴',
    minLat: 8.20,
    maxLat: 12.80,
    minLng: 74.85,
    maxLng: 77.45,
    center: LatLng(10.8505, 76.2711),
    cities: [
      CityConfig(
        id: 'kochi',
        name: 'Kochi',
        stateId: 'kerala',
        emoji: '⚓',
        minLat: 9.90,
        maxLat: 10.10,
        minLng: 76.20,
        maxLng: 76.40,
        defaultColor: '#26A69A',
        center: LatLng(9.9312, 76.2673),
        landmarks: [
          Landmark(name: 'Fort Kochi', location: LatLng(9.9639, 76.2433), radiusMeters: 500, points: 30),
        ],
      ),
      CityConfig(
        id: 'thiruvananthapuram',
        name: 'Thiruvananthapuram',
        stateId: 'kerala',
        emoji: '🛕',
        minLat: 8.40,
        maxLat: 8.60,
        minLng: 76.90,
        maxLng: 77.05,
        defaultColor: '#4DB6AC',
        center: LatLng(8.5241, 76.9366),
      ),
    ],
  );

  static const uttarPradesh = StateConfig(
    id: 'uttar_pradesh',
    name: 'Uttar Pradesh',
    emoji: '🕌',
    minLat: 23.85,
    maxLat: 30.45,
    minLng: 77.05,
    maxLng: 84.65,
    center: LatLng(26.8467, 80.9462),
    cities: [
      CityConfig(
        id: 'lucknow',
        name: 'Lucknow',
        stateId: 'uttar_pradesh',
        emoji: '🏛️',
        minLat: 26.75,
        maxLat: 27.00,
        minLng: 80.85,
        maxLng: 81.05,
        defaultColor: '#8D6E63',
        center: LatLng(26.8467, 80.9462),
        landmarks: [
          Landmark(name: 'Bara Imambara', location: LatLng(26.8691, 80.9128), radiusMeters: 300, points: 50),
        ],
      ),
      CityConfig(
        id: 'varanasi',
        name: 'Varanasi',
        stateId: 'uttar_pradesh',
        emoji: '🛕',
        minLat: 25.25,
        maxLat: 25.40,
        minLng: 82.95,
        maxLng: 83.10,
        defaultColor: '#A1887F',
        center: LatLng(25.3176, 82.9739),
        landmarks: [
          Landmark(name: 'Dashashwamedh Ghat', location: LatLng(25.3109, 83.0107), radiusMeters: 200, points: 50),
          Landmark(name: 'Kashi Vishwanath', location: LatLng(25.3109, 83.0107), radiusMeters: 150, points: 50),
        ],
      ),
      CityConfig(
        id: 'agra',
        name: 'Agra',
        stateId: 'uttar_pradesh',
        emoji: '🕌',
        minLat: 27.10,
        maxLat: 27.25,
        minLng: 77.95,
        maxLng: 78.10,
        defaultColor: '#BCAAA4',
        center: LatLng(27.1767, 78.0081),
        landmarks: [
          Landmark(name: 'Taj Mahal', location: LatLng(27.1751, 78.0421), radiusMeters: 400, points: 100),
          Landmark(name: 'Agra Fort', location: LatLng(27.1795, 78.0211), radiusMeters: 300, points: 50),
        ],
      ),
    ],
  );

  static const punjab = StateConfig(
    id: 'punjab',
    name: 'Punjab',
    emoji: '🌾',
    minLat: 29.55,
    maxLat: 32.60,
    minLng: 73.85,
    maxLng: 76.95,
    center: LatLng(31.1471, 75.3412),
    cities: [
      CityConfig(
        id: 'amritsar',
        name: 'Amritsar',
        stateId: 'punjab',
        emoji: '🕌',
        minLat: 31.55,
        maxLat: 31.75,
        minLng: 74.80,
        maxLng: 75.00,
        defaultColor: '#FFD54F',
        center: LatLng(31.6340, 74.8723),
        landmarks: [
          Landmark(name: 'Golden Temple', location: LatLng(31.6200, 74.8765), radiusMeters: 300, points: 100),
          Landmark(name: 'Jallianwala Bagh', location: LatLng(31.6206, 74.8800), radiusMeters: 150, points: 50),
        ],
      ),
      CityConfig(
        id: 'chandigarh',
        name: 'Chandigarh',
        stateId: 'punjab',
        emoji: '🏛️',
        minLat: 30.65,
        maxLat: 30.80,
        minLng: 76.70,
        maxLng: 76.85,
        defaultColor: '#FFF176',
        center: LatLng(30.7333, 76.7794),
        landmarks: [
          Landmark(name: 'Rock Garden', location: LatLng(30.7525, 76.8086), radiusMeters: 300, points: 40),
        ],
      ),
    ],
  );

  static const andhraPradesh = StateConfig(
    id: 'andhra_pradesh',
    name: 'Andhra Pradesh',
    emoji: '🌊',
    minLat: 12.60,
    maxLat: 19.15,
    minLng: 76.75,
    maxLng: 84.80,
    center: LatLng(15.9129, 79.7400),
    cities: [
      CityConfig(
        id: 'visakhapatnam',
        name: 'Visakhapatnam',
        stateId: 'andhra_pradesh',
        emoji: '🏖️',
        minLat: 17.65,
        maxLat: 17.85,
        minLng: 83.15,
        maxLng: 83.40,
        defaultColor: '#4FC3F7',
        center: LatLng(17.6868, 83.2185),
      ),
      CityConfig(
        id: 'vijayawada',
        name: 'Vijayawada',
        stateId: 'andhra_pradesh',
        emoji: '🛕',
        minLat: 16.45,
        maxLat: 16.60,
        minLng: 80.55,
        maxLng: 80.75,
        defaultColor: '#81D4FA',
        center: LatLng(16.5062, 80.6480),
      ),
      CityConfig(
        id: 'tirupati',
        name: 'Tirupati',
        stateId: 'andhra_pradesh',
        emoji: '🛕',
        minLat: 13.60,
        maxLat: 13.75,
        minLng: 79.35,
        maxLng: 79.50,
        defaultColor: '#B3E5FC',
        center: LatLng(13.6288, 79.4192),
        landmarks: [
          Landmark(name: 'Tirumala Temple', location: LatLng(13.6833, 79.3475), radiusMeters: 500, points: 100),
        ],
      ),
    ],
  );

  // List of all states
  static final List<StateConfig> allStates = [
    delhi,
    telangana,
    maharashtra,
    karnataka,
    tamilNadu,
    gujarat,
    rajasthan,
    westBengal,
    kerala,
    uttarPradesh,
    punjab,
    andhraPradesh,
  ];

  // Flattened list of all cities
  static List<CityConfig> get allCities {
    final cities = <CityConfig>[];
    for (final state in allStates) {
      cities.addAll(state.cities);
    }
    return cities;
  }

  /// Detect state from coordinates
  static StateConfig? detectState(double lat, double lng) {
    for (final state in allStates) {
      if (state.containsPoint(lat, lng)) {
        return state;
      }
    }
    return null;
  }

  /// Detect city from coordinates
  static CityConfig? detect(double lat, double lng) {
    final state = detectState(lat, lng);
    if (state == null) return null;

    final city = state.detectCity(lat, lng);
    if (city != null) return city;

    // Return first city as default for the state
    return state.cities.isNotEmpty ? state.cities.first : null;
  }

  /// Get city by ID
  static CityConfig? getById(String id) {
    return allCities.where((c) => c.id == id).firstOrNull;
  }

  /// Get state by ID
  static StateConfig? getStateById(String id) {
    return allStates.where((s) => s.id == id).firstOrNull;
  }

  /// Check if coordinates are within India
  static bool isInIndia(double lat, double lng) {
    // India bounds: 6°N to 35.5°N, 68°E to 97.5°E
    return lat >= 6.0 && lat <= 35.5 && lng >= 68.0 && lng <= 97.5;
  }

  /// Check if coordinates are within any supported city
  static bool isSupported(double lat, double lng) {
    return detect(lat, lng) != null;
  }

  /// Get nearest landmark in any city
  static (CityConfig?, Landmark?) getNearestLandmark(double lat, double lng) {
    CityConfig? nearestCity;
    Landmark? nearestLandmark;
    double minDistance = double.infinity;
    const distance = Distance();

    for (final city in allCities) {
      for (final landmark in city.landmarks) {
        final d = distance.as(
          LengthUnit.Meter,
          landmark.location,
          LatLng(lat, lng),
        );
        if (d < minDistance) {
          minDistance = d;
          nearestCity = city;
          nearestLandmark = landmark;
        }
      }
    }

    // Only return if within 2km of a landmark
    if (minDistance <= 2000) {
      return (nearestCity, nearestLandmark);
    }
    return (nearestCity, null);
  }

  /// Get hash for a city (for blockchain)
  static String getCityHash(String cityId) => _hashString(cityId);

  /// Get hash for a state (for blockchain)
  static String getStateHash(String stateId) => _hashString(stateId);
}
