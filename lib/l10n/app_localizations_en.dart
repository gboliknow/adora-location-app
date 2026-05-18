// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Adora Location App';

  @override
  String get canceledApiRequest => 'Request was cancelled.';

  @override
  String get apiConnectionTimeout => 'Connection timed out.';

  @override
  String get apiBadCertificate => 'Bad certificate.';

  @override
  String get apiConnectionError => 'No internet connection.';

  @override
  String get apiUnknownConnection => 'An unknown error occurred.';

  @override
  String get apiResponseTimeout => 'Response timed out.';

  @override
  String get apiBadRequest => 'Bad request.';

  @override
  String get permissionTitle => 'Allow location access';

  @override
  String get permissionBody =>
      'This app needs location access to track and log your position in the foreground and background.';

  @override
  String get allowWhileUsing => 'Allow while using app';

  @override
  String get alwaysAllow => 'Always allow';

  @override
  String get dontAllow => 'Don\'t allow';

  @override
  String get permissionDeniedTitle => 'Location access denied';

  @override
  String get permissionDeniedOnceBody => 'Background tracking requires \'Always\' permission. Please try again.';

  @override
  String get permissionDeniedForeverBody => 'Location permission is permanently denied. Please enable it in Settings.';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get trackerTitle => 'Tracker';

  @override
  String get liveLabel => 'Live';

  @override
  String get latitudeLabel => 'Latitude';

  @override
  String get longitudeLabel => 'Longitude';

  @override
  String get accuracyLabel => 'Accuracy';

  @override
  String get updatedLabel => 'Updated';

  @override
  String get backgroundTrackingTitle => 'Background Tracking';

  @override
  String get enableBackgroundTracking => 'Enable background tracking';

  @override
  String get backgroundTrackingSubtitle => 'Continues when app is closed';

  @override
  String get recentLogTitle => 'Recent Log';

  @override
  String get noLocationYet => 'Waiting for location…';

  @override
  String get sourceForeground => 'foreground';

  @override
  String get sourceBackground => 'background';

  @override
  String get sourceTerminated => 'terminated';

  @override
  String get logTitle => 'Location Log';

  @override
  String get clearLog => 'Clear';

  @override
  String get noLogEntries => 'No location entries yet.';

  @override
  String get gpsOffTitle => 'GPS is turned off';

  @override
  String get gpsOffBody => 'Enable location services to start tracking.';

  @override
  String get enableGps => 'Enable GPS';

  @override
  String get fixTimeoutMessage => 'Still searching for a GPS fix \u2014 try moving to an open area.';

  @override
  String get lowAccuracyWarning => 'Low accuracy \u2014 signal may be obstructed';
}
