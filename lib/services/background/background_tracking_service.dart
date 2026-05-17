import 'package:flutter_background_service/flutter_background_service.dart';

import 'package:adora_location_app/services/background/android_background_handler.dart';
import 'package:adora_location_app/services/background/notification_service.dart';

/// Platform-agnostic facade for background location tracking.
///
/// The UI interacts only with [init], [start], [stop], and [isRunning].
/// All platform-specific wiring (Android foreground service / iOS BGTask)
/// lives inside this class and the handlers in android_background_handler.dart.
///
/// Initialisation order in main():
///   1. HiveService.init()
///   2. NotificationService.init()
///   3. BackgroundTrackingService.init()
class BackgroundTrackingService {
  BackgroundTrackingService._();

  static final _service = FlutterBackgroundService();

  /// Configure the background service engines for Android and iOS.
  ///
  /// Must be called once in [main()] — subsequent calls are safe but no-ops.
  static Future<void> init() async {
    await _service.configure(
      androidConfiguration: AndroidConfiguration(
        // Entry-point for the Android foreground-service isolate.
        onStart: onAndroidStart,
        // Do not auto-start on boot — the user must explicitly enable tracking.
        autoStart: false,
        isForegroundMode: true,
        notificationChannelId: NotificationService.channelId,
        initialNotificationTitle: 'Location Tracking',
        initialNotificationContent: 'Tap to open the app.',
        foregroundServiceNotificationId: NotificationService.foregroundNotificationId,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false,
        // onForeground runs when the app is active; reuses the same handler.
        onForeground: onAndroidStart,
        // onBackground is invoked by BGTaskScheduler (~30 s of CPU time).
        onBackground: onIosBackground,
      ),
    );
  }

  /// Start background location tracking.
  ///
  /// Returns [true] if the service started successfully, [false] otherwise
  /// (e.g. permissions not granted).
  static Future<bool> start() => _service.startService();

  /// Stop background location tracking.
  ///
  /// Sends a 'stopService' event to the running isolate; the isolate
  /// cancels its location stream and calls [service.stopSelf()].
  static Future<void> stop() async {
    _service.invoke('stopService');
  }

  /// Whether the background service is currently running.
  static Future<bool> get isRunning => _service.isRunning();
}
