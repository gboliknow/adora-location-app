import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adora_location_app/features/auth/login/vm/login_viewmodel.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: unused_local_variable
    final vm = ref.watch(loginViewModelProvider);
    return const Scaffold(body: Center(child: Text('Login')));
  }
}
