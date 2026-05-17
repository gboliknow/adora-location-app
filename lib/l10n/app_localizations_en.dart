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
}
