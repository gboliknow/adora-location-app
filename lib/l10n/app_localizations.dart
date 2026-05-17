import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Adora Location App'**
  String get appName;

  /// No description provided for @canceledApiRequest.
  ///
  /// In en, this message translates to:
  /// **'Request was cancelled.'**
  String get canceledApiRequest;

  /// No description provided for @apiConnectionTimeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timed out.'**
  String get apiConnectionTimeout;

  /// No description provided for @apiBadCertificate.
  ///
  /// In en, this message translates to:
  /// **'Bad certificate.'**
  String get apiBadCertificate;

  /// No description provided for @apiConnectionError.
  ///
  /// In en, this message translates to:
  /// **'No internet connection.'**
  String get apiConnectionError;

  /// No description provided for @apiUnknownConnection.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred.'**
  String get apiUnknownConnection;

  /// No description provided for @apiResponseTimeout.
  ///
  /// In en, this message translates to:
  /// **'Response timed out.'**
  String get apiResponseTimeout;

  /// No description provided for @apiBadRequest.
  ///
  /// In en, this message translates to:
  /// **'Bad request.'**
  String get apiBadRequest;

  /// No description provided for @permissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Allow location access'**
  String get permissionTitle;

  /// No description provided for @permissionBody.
  ///
  /// In en, this message translates to:
  /// **'This app needs location access to track and log your position in the foreground and background.'**
  String get permissionBody;

  /// No description provided for @allowWhileUsing.
  ///
  /// In en, this message translates to:
  /// **'Allow while using app'**
  String get allowWhileUsing;

  /// No description provided for @alwaysAllow.
  ///
  /// In en, this message translates to:
  /// **'Always allow'**
  String get alwaysAllow;

  /// No description provided for @dontAllow.
  ///
  /// In en, this message translates to:
  /// **'Don\'t allow'**
  String get dontAllow;

  /// No description provided for @permissionDeniedTitle.
  ///
  /// In en, this message translates to:
  /// **'Location access denied'**
  String get permissionDeniedTitle;

  /// No description provided for @permissionDeniedOnceBody.
  ///
  /// In en, this message translates to:
  /// **'Background tracking requires \'Always\' permission. Please try again.'**
  String get permissionDeniedOnceBody;

  /// No description provided for @permissionDeniedForeverBody.
  ///
  /// In en, this message translates to:
  /// **'Location permission is permanently denied. Please enable it in Settings.'**
  String get permissionDeniedForeverBody;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @trackerTitle.
  ///
  /// In en, this message translates to:
  /// **'Tracker'**
  String get trackerTitle;

  /// No description provided for @liveLabel.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get liveLabel;

  /// No description provided for @latitudeLabel.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get latitudeLabel;

  /// No description provided for @longitudeLabel.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get longitudeLabel;

  /// No description provided for @accuracyLabel.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get accuracyLabel;

  /// No description provided for @updatedLabel.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get updatedLabel;

  /// No description provided for @backgroundTrackingTitle.
  ///
  /// In en, this message translates to:
  /// **'Background Tracking'**
  String get backgroundTrackingTitle;

  /// No description provided for @enableBackgroundTracking.
  ///
  /// In en, this message translates to:
  /// **'Enable background tracking'**
  String get enableBackgroundTracking;

  /// No description provided for @backgroundTrackingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Continues when app is closed'**
  String get backgroundTrackingSubtitle;

  /// No description provided for @recentLogTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent Log'**
  String get recentLogTitle;

  /// No description provided for @noLocationYet.
  ///
  /// In en, this message translates to:
  /// **'Waiting for location…'**
  String get noLocationYet;

  /// No description provided for @sourceForeground.
  ///
  /// In en, this message translates to:
  /// **'foreground'**
  String get sourceForeground;

  /// No description provided for @sourceBackground.
  ///
  /// In en, this message translates to:
  /// **'background'**
  String get sourceBackground;

  /// No description provided for @sourceTerminated.
  ///
  /// In en, this message translates to:
  /// **'terminated'**
  String get sourceTerminated;

  /// No description provided for @logTitle.
  ///
  /// In en, this message translates to:
  /// **'Location Log'**
  String get logTitle;

  /// No description provided for @clearLog.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearLog;

  /// No description provided for @noLogEntries.
  ///
  /// In en, this message translates to:
  /// **'No location entries yet.'**
  String get noLogEntries;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
