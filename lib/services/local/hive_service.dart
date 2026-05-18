import 'package:hive_flutter/hive_flutter.dart';

/// Bootstrap helper for Hive local storage.
///
/// **Must** be called in `main()` AND inside every background isolate —
/// each Dart isolate has its own heap, so Hive must be initialised
/// independently in each one before any box is opened.
class HiveService {
  HiveService._();

  static const String locationBoxName = 'location_log';

  static Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isBoxOpen(locationBoxName)) {
      await Hive.openBox<Map>(locationBoxName);
    }
  }

  static Future<void> dispose() => Hive.close();
}
