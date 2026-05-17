import 'package:flutter/material.dart';
import 'package:adora_location_app/core/locale/locale_provider.dart';

/// Drop-in toggle button that switches between English and Chinese.
/// Place it anywhere — AppBar actions, settings screen, etc.
///
/// Example:
/// ```dart
/// AppBar(actions: const [LocaleToggle()])
/// ```
class LocaleToggle extends StatelessWidget {
  const LocaleToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: LocaleProvider.instance,
      builder: (context, locale, _) {
        final isEn = locale.languageCode == 'en';
        return TextButton(
          onPressed: LocaleProvider.instance.toggle,
          child: Text(isEn ? '中文' : 'EN', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        );
      },
    );
  }
}
