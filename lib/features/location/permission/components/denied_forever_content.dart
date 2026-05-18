import 'package:flutter/material.dart';

import 'package:adora_location_app/features/location/permission/vm/permission_viewmodel.dart';
import 'package:adora_location_app/routes/route.dart';

class DeniedForeverContent extends StatelessWidget {
  const DeniedForeverContent({super.key, required this.vm, required this.l10n});

  final PermissionViewModel vm;
  final dynamic l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Spacer(),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(color: Colors.red.shade50, shape: BoxShape.circle),
          child: Icon(Icons.location_off_outlined, size: 40, color: Colors.red[600]),
        ),
        const SizedBox(height: 24),
        Text(
          l10n.permissionDeniedTitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.permissionDeniedForeverBody,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
        const Spacer(),
        FilledButton(
          onPressed: vm.openSettings,
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(l10n.openSettings),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () => Navigator.of(context).pushReplacementNamed(AppRoute.shellView),
          child: Text(l10n.dontAllow, style: TextStyle(color: Colors.grey[600])),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
