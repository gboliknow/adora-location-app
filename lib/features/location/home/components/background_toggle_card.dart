import 'package:flutter/material.dart';

import 'package:adora_location_app/features/location/home/vm/home_viewmodel.dart';

class BackgroundToggleCard extends StatelessWidget {
  const BackgroundToggleCard({
    super.key,
    required this.vm,
    required this.isRunning,
    required this.l10n,
    required this.onToggle,
  });

  final HomeViewModel vm;
  final bool isRunning;
  final dynamic l10n;
  final void Function(bool) onToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 4),
              child: Text(
                l10n.backgroundTrackingTitle,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.5),
              ),
            ),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text(
                l10n.enableBackgroundTracking,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              subtitle: Text(l10n.backgroundTrackingSubtitle, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              value: isRunning,
              onChanged: vm.loading ? null : onToggle,
            ),
          ],
        ),
      ),
    );
  }
}
