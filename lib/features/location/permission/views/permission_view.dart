import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:adora_location_app/core/extensions/context_extension.dart';
import 'package:adora_location_app/features/location/permission/components/denied_forever_content.dart';
import 'package:adora_location_app/features/location/permission/components/request_content.dart';
import 'package:adora_location_app/features/location/permission/vm/permission_viewmodel.dart';
import 'package:adora_location_app/routes/route.dart';

class PermissionView extends ConsumerWidget {
  const PermissionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(permissionViewModelProvider);
    final l10n = context.localizations;

    ref.listen(permissionViewModelProvider, (_, next) {
      if (next.state == PermissionState.granted) {
        Navigator.of(context).pushReplacementNamed(AppRoute.shellView);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: vm.state == PermissionState.deniedForever
              ? DeniedForeverContent(vm: vm, l10n: l10n)
              : RequestContent(vm: vm, l10n: l10n),
        ),
      ),
    );
  }
}
