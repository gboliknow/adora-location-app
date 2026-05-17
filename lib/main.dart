import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:adora_location_app/app.dart';
import 'package:adora_location_app/services/local/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive must be initialised before any repository access.
  // The background isolate calls HiveService.init() independently (Phase 3).
  await HiveService.init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) => runApp(const MyApp()));
}
