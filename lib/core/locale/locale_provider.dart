import 'package:flutter/material.dart';

/// Simple singleton [ValueNotifier] that holds the active [Locale].
/// No extra packages required — wire it into [MaterialApp.locale] via
/// [ListenableBuilder] in app.dart.
class LocaleProvider extends ValueNotifier<Locale> {
  LocaleProvider._() : super(const Locale('en'));

  static final LocaleProvider instance = LocaleProvider._();

  static const Locale en = Locale('en');
  static const Locale ja = Locale('ja');

  bool get isEnglish => value.languageCode == 'en';

  void setEnglish() => value = en;
  void setJapanese() => value = ja;

  void toggle() => value = isEnglish ? ja : en;
}
