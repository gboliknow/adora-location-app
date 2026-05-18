import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:adora_location_app/models/location_point.dart';

/// Thin wrapper around [Geolocator] that provides typed [LocationPoint] streams.
///
/// Accuracy filter: readings worse than [_accuracyThresholdMeters] are dropped
/// to avoid Wi-Fi / cell-tower noise. Distance filter (10 m) prevents
/// flooding the log when the device is stationary.
class LocationService {
  /// Readings with accuracy worse than this are silently discarded.
  static const double _accuracyThresholdMeters = 50.0;

  /// Threshold above which the UI shows a low-accuracy warning.
  static const double lowAccuracyWarningMeters = 30.0;

  static const LocationSettings _settings = LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10);

  /// Continuous stream of high-accuracy foreground location fixes.
  ///
  /// Emits only when the device moves at least 10 m, and filters out fixes
  /// with accuracy > 50 m. Propagates [LocationServiceDisabledException]
  /// if the device's location service is turned off mid-stream.
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

  /// One-shot current position with a 30-second timeout.
  ///
  /// Returns [null] if the GPS cannot provide a fix in time or if an
  /// unrecoverable error occurs (e.g. permission revoked).
  Future<LocationPoint?> getCurrentLocation() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      ).timeout(const Duration(seconds: 30));
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

  /// Live stream of whether the device's location service (GPS) is enabled.
  ///
  /// Emits [false] when the user disables location services in system
  /// settings, so the UI can show a "GPS is off" prompt without polling.
  Stream<bool> watchServiceEnabled() {
    return Geolocator.getServiceStatusStream().map((status) => status == ServiceStatus.enabled);
  }

  /// [true] if both location service is on AND permission is granted.
  Future<bool> get isReady async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

  /// Opens the device's location settings screen.
  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();
}
