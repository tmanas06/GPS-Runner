/// Mapbox configuration and map styles
class MapConfig {
  // Token can be overridden at build time with:
  // flutter build apk --dart-define=MAPBOX_TOKEN=your_token_here
  static const String mapboxAccessToken = String.fromEnvironment(
    'MAPBOX_TOKEN',
    defaultValue: 'pk.eyJ1IjoiYW56MTIiLCJhIjoiY21qa3pwcTBjMmNuODNlcXh1a3R4YTR2dyJ9.bkQFUY0siWoeVPc9zsvOsQ',
  );

  static bool get hasValidToken => mapboxAccessToken.isNotEmpty;

  // Check if using default token (should be rotated for production)
  static bool get isUsingDefaultToken =>
      mapboxAccessToken == 'pk.eyJ1IjoiYW56MTIiLCJhIjoiY21qa3pwcTBjMmNuODNlcXh1a3R4YTR2dyJ9.bkQFUY0siWoeVPc9zsvOsQ';
}

/// Available map styles
enum MapStyle {
  streets('Streets', 'streets-v12', '🛣️'),
  satellite('Satellite', 'satellite-v9', '🛰️'),
  satelliteStreets('Hybrid', 'satellite-streets-v12', '🗺️'),
  outdoors('Terrain', 'outdoors-v12', '⛰️'),
  dark('Dark', 'dark-v11', '🌙'),
  light('Light', 'light-v11', '☀️');

  final String label;
  final String styleId;
  final String icon;

  const MapStyle(this.label, this.styleId, this.icon);

  String get tileUrl {
    if (MapConfig.hasValidToken) {
      return 'https://api.mapbox.com/styles/v1/mapbox/$styleId/tiles/{z}/{x}/{y}@2x?access_token=${MapConfig.mapboxAccessToken}';
    }
    // Fallback to OpenStreetMap if no token
    return 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  }
}
