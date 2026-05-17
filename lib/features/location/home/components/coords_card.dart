import 'package:flutter/material.dart';

import 'package:adora_location_app/features/location/home/vm/home_viewmodel.dart';
import 'package:adora_location_app/models/location_point.dart';

class CoordsCard extends StatelessWidget {
  const CoordsCard({super.key, required this.vm, required this.latest, required this.l10n});

  final HomeViewModel vm;
  final LocationPoint latest;
  final dynamic l10n;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          children: [
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: _CoordColumn(
                      label: l10n.latitudeLabel,
                      value: '${vm.formatCoord(latest.lat)}°',
                      suffix: latest.lat >= 0 ? 'N' : 'S',
                    ),
                  ),
                  VerticalDivider(thickness: 1, color: Colors.grey.shade200),
                  Expanded(
                    child: _CoordColumn(
                      label: l10n.longitudeLabel,
                      value: '${vm.formatCoord(latest.lng)}°',
                      suffix: latest.lng >= 0 ? 'E' : 'W',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${l10n.updatedLabel} ${vm.timeAgo(latest.timestamp)} · '
              '${l10n.accuracyLabel} ${latest.accuracy.toStringAsFixed(0)} m',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoordColumn extends StatelessWidget {
  const _CoordColumn({required this.label, required this.value, required this.suffix});

  final String label;
  final String value;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(width: 3),
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                suffix,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
