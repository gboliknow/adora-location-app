import 'package:flutter/material.dart';
import 'package:adora_location_app/l10n/app_localizations.dart';

extension BuildContextExtension on BuildContext {
  AppLocalizations get localizations => AppLocalizations.of(this)!;
}
