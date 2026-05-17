import 'package:adora_location_app/core/locale/locale_provider.dart';
import 'package:adora_location_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:adora_location_app/app_constants.dart';
import 'package:adora_location_app/routes/route.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: ListenableBuilder(
        listenable: LocaleProvider.instance,
        builder: (context, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppConstants.appName,
            locale: LocaleProvider.instance.value,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            initialRoute: AppRoute.splashView,
            onGenerateRoute: AppRoute.getRoute,
          );
        },
      ),
    );
  }
}
