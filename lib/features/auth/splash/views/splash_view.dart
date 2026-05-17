import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adora_location_app/features/auth/splash/vm/splash_viewmodel.dart';

class SplashView extends ConsumerWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: unused_local_variable
    final vm = ref.watch(splashViewModelProvider);
    return const Scaffold(body: Center(child: Text('Splash 564')));
  }
}
