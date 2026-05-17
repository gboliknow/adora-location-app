import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:adora_location_app/features/location/widgets/location_log_tile.dart';
import 'package:adora_location_app/models/location_point.dart';

class RecentLogSection extends StatelessWidget {
  const RecentLogSection({super.key, required this.logAsync, required this.l10n});

  final AsyncValue<List<LocationPoint>> logAsync;
  final dynamic l10n;

  @override
  Widget build(BuildContext context) {
    return logAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, e) => const SizedBox.shrink(),
      data: (log) {
        if (log.isEmpty) return const SizedBox.shrink();
        final preview = log.take(3).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                l10n.recentLogTitle,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.5),
              ),
            ),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(children: preview.map((p) => LocationLogTile(point: p, dense: true)).toList()),
              ),
            ),
          ],
        );
      },
    );
  }
}
