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

/// City configuration with bounds and contract info
class CityConfig {
  final String id;
  final String name;
  final String emoji;
  final double minLat;
  final double maxLat;
  final double minLng;
  final double maxLng;
  final String contractAddress;
  final String defaultColor;
  final LatLng center;
  final List<Landmark> landmarks;

  const CityConfig({
    required this.id,
    required this.name,
    required this.emoji,
    required this.minLat,
    required this.maxLat,
    required this.minLng,
    required this.maxLng,
    required this.contractAddress,
    required this.defaultColor,
    required this.center,
    required this.landmarks,
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

  /// Convert bounds to 1e6 integers for blockchain
  int get minLat1e6 => (minLat * 1e6).round();
  int get maxLat1e6 => (maxLat * 1e6).round();
  int get minLng1e6 => (minLng * 1e6).round();
  int get maxLng1e6 => (maxLng * 1e6).round();
}

/// City bounds and configuration manager
class CityBounds {
  // Contract addresses - UPDATE AFTER DEPLOYMENT
  static const String delhiContractAddress =
      '0x1234567890123456789012345678901234567890'; // TODO: Update after deploy
  static const String hydContractAddress =
      '0x0987654321098765432109876543210987654321'; // TODO: Update after deploy

  // Delhi bounds: 28.4-28.8°N, 76.9-77.4°E
  static const delhi = CityConfig(
    id: 'delhi',
    name: 'Delhi',
    emoji: '🏛️',
    minLat: 28.4,
    maxLat: 28.8,
    minLng: 76.9,
    maxLng: 77.4,
    contractAddress: delhiContractAddress,
    defaultColor: '#2196F3', // Blue
    center: LatLng(28.6139, 77.2090),
    landmarks: [
      Landmark(
        name: 'India Gate',
        location: LatLng(28.6129, 77.2295),
        radiusMeters: 200,
        points: 50,
      ),
      Landmark(
        name: 'Red Fort',
        location: LatLng(28.6562, 77.2410),
        radiusMeters: 300,
        points: 50,
      ),
      Landmark(
        name: 'Connaught Place',
        location: LatLng(28.6315, 77.2167),
        radiusMeters: 400,
        points: 30,
      ),
      Landmark(
        name: 'Lotus Temple',
        location: LatLng(28.5535, 77.2588),
        radiusMeters: 150,
        points: 40,
      ),
      Landmark(
        name: 'Qutub Minar',
        location: LatLng(28.5245, 77.1855),
        radiusMeters: 200,
        points: 50,
      ),
      Landmark(
        name: 'Humayun Tomb',
        location: LatLng(28.5933, 77.2507),
        radiusMeters: 200,
        points: 40,
      ),
      Landmark(
        name: 'Akshardham Temple',
        location: LatLng(28.6127, 77.2773),
        radiusMeters: 300,
        points: 40,
      ),
      Landmark(
        name: 'Jama Masjid',
        location: LatLng(28.6507, 77.2334),
        radiusMeters: 200,
        points: 40,
      ),
      Landmark(
        name: 'Rashtrapati Bhavan',
        location: LatLng(28.6143, 77.1994),
        radiusMeters: 300,
        points: 30,
      ),
      Landmark(
        name: 'Chandni Chowk',
        location: LatLng(28.6506, 77.2303),
        radiusMeters: 500,
        points: 20,
      ),
    ],
  );

  // Hyderabad bounds: 17.3-17.5°N, 78.3-78.6°E
  static const hyderabad = CityConfig(
    id: 'hyderabad',
    name: 'Hyderabad',
    emoji: '🕌',
    minLat: 17.3,
    maxLat: 17.5,
    minLng: 78.3,
    maxLng: 78.6,
    contractAddress: hydContractAddress,
    defaultColor: '#4CAF50', // Green
    center: LatLng(17.3850, 78.4867),
    landmarks: [
      Landmark(
        name: 'Charminar',
        location: LatLng(17.3616, 78.4747),
        radiusMeters: 200,
        points: 50,
      ),
      Landmark(
        name: 'Golconda Fort',
        location: LatLng(17.3833, 78.4011),
        radiusMeters: 400,
        points: 50,
      ),
      Landmark(
        name: 'Hussain Sagar Lake',
        location: LatLng(17.4239, 78.4738),
        radiusMeters: 500,
        points: 30,
      ),
      Landmark(
        name: 'Birla Mandir',
        location: LatLng(17.4062, 78.4691),
        radiusMeters: 150,
        points: 40,
      ),
      Landmark(
        name: 'Ramoji Film City',
        location: LatLng(17.2543, 78.6808),
        radiusMeters: 1000,
        points: 50,
      ),
      Landmark(
        name: 'Salar Jung Museum',
        location: LatLng(17.3714, 78.4804),
        radiusMeters: 150,
        points: 40,
      ),
      Landmark(
        name: 'Mecca Masjid',
        location: LatLng(17.3604, 78.4736),
        radiusMeters: 150,
        points: 40,
      ),
      Landmark(
        name: 'Nehru Zoo',
        location: LatLng(17.3499, 78.4519),
        radiusMeters: 400,
        points: 30,
      ),
      Landmark(
        name: 'Tank Bund',
        location: LatLng(17.4156, 78.4747),
        radiusMeters: 300,
        points: 25,
      ),
      Landmark(
        name: 'HITEC City',
        location: LatLng(17.4435, 78.3772),
        radiusMeters: 500,
        points: 20,
      ),
    ],
  );

  static final List<CityConfig> allCities = [delhi, hyderabad];

  /// Detect city from coordinates
  static CityConfig? detect(double lat, double lng) {
    for (final city in allCities) {
      if (city.containsPoint(lat, lng)) {
        return city;
      }
    }
    return null;
  }

  /// Get city by ID
  static CityConfig? getById(String id) {
    return allCities.where((c) => c.id == id).firstOrNull;
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
}
