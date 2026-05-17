import 'dart:async';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adora_location_app/models/location_point.dart';
import 'package:adora_location_app/repositories/location_repository.dart';
import 'package:adora_location_app/services/location/location_service.dart';
import 'package:adora_location_app/services/permission/permission_service.dart';
import 'package:adora_location_app/services/background/background_tracking_service.dart';

final locationServiceProvider = Provider<LocationService>((ref) => LocationService());

final locationRepoProvider = Provider<LocationRepository>((ref) => LocationRepository());

final permissionServiceProvider = Provider<PermissionService>((ref) => PermissionService());

final locationStreamProvider = StreamProvider<LocationPoint>((ref) => ref.watch(locationServiceProvider).stream);

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

// Derived from locationLogProvider so it stays reactive without a separate stream.
final latestLocationProvider = Provider<LocationPoint?>((ref) {
  final log = ref.watch(locationLogProvider).valueOrNull;
  return (log != null && log.isNotEmpty) ? log.first : null;
});

/// Whether the background service is currently running.
/// Exposed as a [FutureProvider] so the UI toggle can reflect live state.
final isBackgroundRunningProvider = FutureProvider<bool>((_) => BackgroundTrackingService.isRunning);
