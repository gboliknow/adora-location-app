import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Creates the Android notification channel required by the foreground location service.
///
/// Must be called once in [main()] — before [BackgroundTrackingService.init()] —
/// so the channel exists when the service posts its first notification.
/// On iOS this is a no-op.
class NotificationService {
  NotificationService._();

  /// Notification channel ID — must match [AndroidConfiguration.notificationChannelId].
  static const String channelId = 'location_tracking';
  static const String channelName = 'Location Tracking';

  /// Notification ID used for the persistent foreground service notification.
  static const int foregroundNotificationId = 888;

  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  /// Initialise the notification plugin and create the Android channel.
  /// Safe to call multiple times — the OS ignores duplicate channel creation.
  static Future<void> init() async {
    if (!Platform.isAndroid) return;

    const initSettings = InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher'));
    await _plugin.initialize(initSettings);

    // Importance.low = silent (no sound/vibration) but persists in the tray.
    const channel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: 'Shows live latitude and longitude while location tracking is active.',
      importance: Importance.low,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
}
