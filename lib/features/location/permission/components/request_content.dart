import 'package:flutter/material.dart';

import 'package:adora_location_app/features/location/permission/vm/permission_viewmodel.dart';
import 'package:adora_location_app/routes/route.dart';

class RequestContent extends StatelessWidget {
  const RequestContent({super.key, required this.vm, required this.l10n});

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
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, shape: BoxShape.circle),
          child: Icon(Icons.location_on_outlined, size: 40, color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(height: 24),
        Text(
          l10n.permissionTitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.permissionBody,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
        if (vm.state == PermissionState.deniedOnce) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.amber[700], size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(l10n.permissionDeniedOnceBody, style: TextStyle(fontSize: 13, color: Colors.amber[900])),
                ),
              ],
            ),
          ),
        ],
        const Spacer(),
        FilledButton(
          onPressed: vm.loading ? null : vm.requestAlways,
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: vm.loading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Text(l10n.alwaysAllow),
        ),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: vm.loading ? null : vm.requestWhenInUse,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(l10n.allowWhileUsing),
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
