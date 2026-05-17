import 'package:hive_flutter/hive_flutter.dart';

// Must be called in main() AND in the background isolate — each isolate
// needs its own Hive init.
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
