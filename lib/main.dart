import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:adora_location_app/app.dart';
import 'package:adora_location_app/services/local/hive_service.dart';
import 'package:adora_location_app/services/background/notification_service.dart';
import 'package:adora_location_app/services/background/background_tracking_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation order matters:
  //   1. Hive — must be ready before any repository or background isolate access.
  //   2. NotificationService — creates the Android channel before the service needs it.
  //   3. BackgroundTrackingService — configures flutter_background_service engines.
  await HiveService.init();
  await NotificationService.init();
  await BackgroundTrackingService.init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) => runApp(const MyApp()));
}
