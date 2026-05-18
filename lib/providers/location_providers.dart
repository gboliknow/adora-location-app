import 'dart:async';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adora_location_app/models/location_point.dart';
import 'package:adora_location_app/repositories/location_repository.dart';
import 'package:adora_location_app/services/location/location_service.dart';
import 'package:adora_location_app/services/permission/permission_service.dart';
import 'package:adora_location_app/services/background/background_tracking_service.dart';

/// Singleton [LocationService] shared across the app.
final locationServiceProvider = Provider<LocationService>((ref) => LocationService());

/// Singleton [LocationRepository] for persisting and reading location history.
final locationRepoProvider = Provider<LocationRepository>((ref) => LocationRepository());

/// Singleton [PermissionService] for querying and requesting location permissions.
final permissionServiceProvider = Provider<PermissionService>((ref) => PermissionService());

/// Raw foreground location stream — emits typed [LocationPoint]s filtered to
/// ≤ 50 m accuracy. Only active while a subscriber is listening.
final locationStreamProvider = StreamProvider<LocationPoint>((ref) => ref.watch(locationServiceProvider).stream);

/// Live stream of whether the device's location service (GPS toggle) is enabled.
///
/// Emits [false] immediately when the user turns GPS off in system settings.
/// The HomeView watches this to show a "GPS is off" prompt.
final gpsServiceProvider = StreamProvider<bool>((ref) {
  return ref.watch(locationServiceProvider).watchServiceEnabled();
});

/// Reactive, persisted location log — combines same-isolate Hive writes with
/// cross-isolate 'locationUpdate' pings from the background service.
///
/// Always emits the full sorted list (newest first) from Hive so cold-starts
/// and foreground writes are reflected without delay.
final locationLogProvider = StreamProvider<List<LocationPoint>>((ref) async* {
  final repo = ref.watch(locationRepoProvider);

  // Emit the persisted list immediately (covers cold-start and foreground writes).
  yield repo.getAll();

  // Signal controller: merges Hive box events (same-isolate writes) with
  // 'locationUpdate' pings that the background isolate sends after each save.
  final signal = StreamController<void>.broadcast();

  final hiveSub = repo.watch().listen((_) => signal.add(null));
  final bgSub = FlutterBackgroundService().on('locationUpdate').listen((_) => signal.add(null));

  ref.onDispose(() {
    hiveSub.cancel();
    bgSub.cancel();
    signal.close();
  });

  await for (final _ in signal.stream) {
    yield repo.getAll();
  }
});

/// Derived from [locationLogProvider] — the most recent [LocationPoint] or
/// [null] if no fix has been recorded yet.
final latestLocationProvider = Provider<LocationPoint?>((ref) {
  final log = ref.watch(locationLogProvider).valueOrNull;
  return (log != null && log.isNotEmpty) ? log.first : null;
});

/// Whether the background service is currently running.
/// Exposed as a [FutureProvider] so the UI toggle can reflect live state.
final isBackgroundRunningProvider = FutureProvider<bool>((_) => BackgroundTrackingService.isRunning);

/// Saves every foreground location fix to the repository while the HomeView
/// is mounted. Keeps the log and the coords card live even with background
/// tracking OFF.
final foregroundTrackingProvider = StreamProvider.autoDispose<void>((ref) async* {
  final service = ref.watch(locationServiceProvider);
  final repo = ref.watch(locationRepoProvider);

  await for (final point in service.stream) {
    await repo.save(point);
  }
});
