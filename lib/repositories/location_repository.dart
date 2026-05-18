import 'package:hive_flutter/hive_flutter.dart';
import 'package:adora_location_app/models/location_point.dart';
import 'package:adora_location_app/services/local/hive_service.dart';

/// Hive-backed store for [LocationPoint] history.
///
/// Capped at [_maxEntries] (500) to prevent unbounded flash storage growth —
/// the oldest entry is deleted whenever the cap is exceeded.
///
/// Thread-safety: Hive boxes are not thread-safe across Dart isolates.
/// Each isolate (main + background) must open its own box via [HiveService.init].
class LocationRepository {
  static const int _maxEntries = 500;

  Box<Map> get _box => Hive.box<Map>(HiveService.locationBoxName);

  Future<void> save(LocationPoint point) async {
    await _box.add(point.toJson());
    if (_box.length > _maxEntries) await _box.deleteAt(0);
  }

  List<LocationPoint> getAll() {
    return _box.values.map((e) => LocationPoint.fromJson(Map<String, dynamic>.from(e))).toList().reversed.toList();
  }

  LocationPoint? getLatest() {
    if (_box.isEmpty) return null;
    return LocationPoint.fromJson(Map<String, dynamic>.from(_box.getAt(_box.length - 1)!));
  }

  Stream<List<LocationPoint>> watch() {
    return _box.watch().map((_) => getAll());
  }

  Future<void> clear() => _box.clear();

  int get count => _box.length;
}
