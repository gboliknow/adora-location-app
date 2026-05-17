import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:adora_location_app/models/location_point.dart';

// Drops readings worse than 50 m to avoid Wi-Fi/cell-tower noise.
// distanceFilter: 10 m prevents flooding the log when the user is stationary.
class LocationService {
  static const double _accuracyThresholdMeters = 50.0;

  static const LocationSettings _settings = LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10);

  Stream<LocationPoint> get stream {
    return Geolocator.getPositionStream(locationSettings: _settings)
        .where((pos) => pos.accuracy <= _accuracyThresholdMeters)
        .map(
          (pos) => LocationPoint(
            lat: pos.latitude,
            lng: pos.longitude,
            accuracy: pos.accuracy,
            timestamp: pos.timestamp,
            source: LocationSource.foreground,
          ),
        );
  }

  Future<LocationPoint?> getCurrentLocation() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      return LocationPoint(
        lat: pos.latitude,
        lng: pos.longitude,
        accuracy: pos.accuracy,
        timestamp: pos.timestamp,
        source: LocationSource.foreground,
      );
    } catch (_) {
      return null;
    }
  }

  Future<bool> get isReady async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();
}
