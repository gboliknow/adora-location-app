import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adora_location_app/models/location_point.dart';
import 'package:adora_location_app/repositories/location_repository.dart';
import 'package:adora_location_app/services/location/location_service.dart';
import 'package:adora_location_app/services/permission/permission_service.dart';

final locationServiceProvider = Provider<LocationService>((ref) => LocationService());

final locationRepoProvider = Provider<LocationRepository>((ref) => LocationRepository());

final permissionServiceProvider = Provider<PermissionService>((ref) => PermissionService());

final locationStreamProvider = StreamProvider<LocationPoint>((ref) => ref.watch(locationServiceProvider).stream);

final locationLogProvider = StreamProvider<List<LocationPoint>>((ref) => ref.watch(locationRepoProvider).watch());

// Derived from locationLogProvider so it stays reactive without a separate stream.
final latestLocationProvider = Provider<LocationPoint?>((ref) {
  final log = ref.watch(locationLogProvider).valueOrNull;
  return (log != null && log.isNotEmpty) ? log.first : null;
});
