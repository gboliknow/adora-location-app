import 'dart:async';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';

import 'package:adora_location_app/models/location_point.dart';
import 'package:adora_location_app/repositories/location_repository.dart';
import 'package:adora_location_app/services/local/hive_service.dart';

/// Top-level isolate entry-point for the Android foreground service.
///
/// Each background isolate is a separate Dart VM context — Hive and all
/// singletons must be re-initialised here independently of [main()].
///
/// The [@pragma] annotation prevents the tree-shaker from removing this
/// function in release builds.
@pragma('vm:entry-point')
Future<void> onAndroidStart(ServiceInstance service) async {
  // Re-initialise Hive inside this isolate — mandatory for every isolate.
  await HiveService.init();

  final repo = LocationRepository();

  final locationSettings = AndroidSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10,
    intervalDuration: const Duration(seconds: 30),
  );

  StreamSubscription<Position>? locationSub;

  void startLocationStream() {
    locationSub = Geolocator.getPositionStream(locationSettings: locationSettings).listen((pos) async {
      // Drop readings noisier than 50 m (Wi-Fi / cell-tower artefacts).
      if (pos.accuracy > 50.0) return;

      final point = LocationPoint(
        lat: pos.latitude,
        lng: pos.longitude,
        accuracy: pos.accuracy,
        timestamp: pos.timestamp,
        source: LocationSource.background,
      );

      await repo.save(point);

      // Ping the UI isolate so its locationLogProvider re-reads Hive.
      service.invoke('locationUpdate');

      // Update the sticky foreground notification with live coordinates.
      if (service is AndroidServiceInstance) {
        service.setForegroundNotificationInfo(
          title: 'Location Tracking Active',
          content:
              'Lat: ${point.lat.toStringAsFixed(5)},  '
              'Lng: ${point.lng.toStringAsFixed(5)}  '
              '±${point.accuracy.toStringAsFixed(0)} m',
        );
      }
    });
  }

  // Listen for the graceful stop event sent from
  // BackgroundTrackingService.stop() → FlutterBackgroundService.invoke('stopService').
  service.on('stopService').listen((_) async {
    await locationSub?.cancel();
    await service.stopSelf();
  });

  startLocationStream();
}

/// iOS BGTaskScheduler wakeup handler.
///
/// Called when the OS grants a background CPU slot (~30 s budget).
/// By this point, [AppDelegate]'s CLLocationManager has already received
/// the significant-location-change event and updated the system's last
/// known position — so [Geolocator.getLastKnownPosition()] returns the
/// fresh coordinate without needing to start a new stream.
///
/// Hive must be re-initialised here because this runs in its own isolate,
/// separate from both [main()] and [onAndroidStart].
@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  // Every isolate needs its own Hive init.
  await HiveService.init();

  final repo = LocationRepository();

  // The OS already detected the location change — getLastKnownPosition()
  // returns it instantly without opening a stream or consuming extra battery.
  final pos = await Geolocator.getLastKnownPosition();

  if (pos != null && pos.accuracy <= 50.0) {
    await repo.save(
      LocationPoint(
        lat: pos.latitude,
        lng: pos.longitude,
        accuracy: pos.accuracy,
        timestamp: pos.timestamp,
        source: LocationSource.background,
      ),
    );
  }

  // Return true to signal the isolate completed successfully.
  return true;
}
