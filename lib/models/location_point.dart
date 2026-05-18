/// Where in the app lifecycle a fix was captured.
enum LocationSource { foreground, background, terminated }

/// Immutable snapshot of a single GPS fix.
///
/// [accuracy] is in metres — lower is better. [source] records whether the
/// fix came from the foreground stream, the background isolate, or a
/// terminated-state significant-location-change event.
class LocationPoint {
  final double lat;
  final double lng;
  final double accuracy; // metres; lower = better

  final DateTime timestamp;
  final LocationSource source;

  const LocationPoint({
    required this.lat,
    required this.lng,
    required this.accuracy,
    required this.timestamp,
    required this.source,
  });

  Map<String, dynamic> toJson() => {
    'lat': lat,
    'lng': lng,
    'accuracy': accuracy,
    'timestamp': timestamp.toIso8601String(),
    'source': source.name,
  };

  factory LocationPoint.fromJson(Map<String, dynamic> json) {
    return LocationPoint(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      accuracy: (json['accuracy'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      source: LocationSource.values.firstWhere(
        (e) => e.name == json['source'],
        orElse: () => LocationSource.foreground,
      ),
    );
  }

  @override
  String toString() =>
      'LocationPoint(lat: $lat, lng: $lng, accuracy: ${accuracy.toStringAsFixed(1)}m, '
      'source: ${source.name}, timestamp: $timestamp)';
}
