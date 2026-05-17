import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:adora_location_app/core/extensions/context_extension.dart';
import 'package:adora_location_app/features/auth/splash/vm/splash_viewmodel.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  @override
  void initState() {
    super.initState();
    // Kick off the permission check after the first frame so
    // the Navigator is available when we push.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(splashViewModelProvider).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Navigate as soon as nextRoute is set.
    ref.listen(splashViewModelProvider, (_, vm) {
      if (vm.nextRoute != null) {
        Navigator.of(context).pushReplacementNamed(vm.nextRoute!);
      }
    });

    final l10n = context.localizations;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, shape: BoxShape.circle),
              child: Icon(Icons.location_on, size: 44, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 20),
            Text(l10n.appName, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
