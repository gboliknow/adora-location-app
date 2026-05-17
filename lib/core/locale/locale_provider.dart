import 'package:flutter/material.dart';

/// Simple singleton [ValueNotifier] that holds the active [Locale].
/// No extra packages required — wire it into [MaterialApp.locale] via
/// [ListenableBuilder] in app.dart.
class LocaleProvider extends ValueNotifier<Locale> {
  LocaleProvider._() : super(const Locale('en'));

  static final LocaleProvider instance = LocaleProvider._();

  static const Locale en = Locale('en');
  static const Locale zh = Locale('zh');

  bool get isEnglish => value.languageCode == 'en';

  void setEnglish() => value = en;
  void setChinese() => value = zh;

  void toggle() => value = isEnglish ? zh : en;
}
