import 'package:flutter/material.dart';

import 'package:adora_location_app/core/extensions/context_extension.dart';
import 'package:adora_location_app/features/location/home/vm/home_viewmodel.dart';
import 'package:adora_location_app/models/location_point.dart';

class LocationLogTile extends StatelessWidget {
  const LocationLogTile({super.key, required this.point, this.dense = false});

  final LocationPoint point;

  final bool dense;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localizations;
    final color = Color(HomeViewModel.badgeColorValue(point.source));

    final sourceLabel = switch (point.source) {
      LocationSource.foreground => l10n.sourceForeground,
      LocationSource.background => l10n.sourceBackground,
      LocationSource.terminated => l10n.sourceTerminated,
    };

    final timeStr =
        '${point.timestamp.toLocal().hour.toString().padLeft(2, '0')}:'
        '${point.timestamp.toLocal().minute.toString().padLeft(2, '0')}:'
        '${point.timestamp.toLocal().second.toString().padLeft(2, '0')}';

    return Padding(
      padding: EdgeInsets.symmetric(vertical: dense ? 4 : 6),
      child: Row(
        children: [
          Icon(Icons.location_on, size: dense ? 16 : 20, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${point.lat.toStringAsFixed(4)}° N, '
              '${point.lng.toStringAsFixed(4)}° E',
              style: TextStyle(fontSize: dense ? 13 : 14, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(timeStr, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(4)),
                child: Text(
                  sourceLabel,
                  style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
