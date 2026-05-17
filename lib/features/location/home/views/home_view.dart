import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:adora_location_app/core/extensions/context_extension.dart';
import 'package:adora_location_app/features/location/home/components/background_toggle_card.dart';
import 'package:adora_location_app/features/location/home/components/coords_card.dart';
import 'package:adora_location_app/features/location/home/components/empty_location_card.dart';
import 'package:adora_location_app/features/location/home/components/map_placeholder.dart';
import 'package:adora_location_app/features/location/home/components/recent_log_section.dart';
import 'package:adora_location_app/features/location/home/vm/home_viewmodel.dart';
import 'package:adora_location_app/providers/location_providers.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(homeViewModelProvider);
    final l10n = context.localizations;
    final latest = ref.watch(latestLocationProvider);
    final logAsync = ref.watch(locationLogProvider);
    final isRunningAsync = ref.watch(isBackgroundRunningProvider);
    final isRunning = isRunningAsync.valueOrNull ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.trackerTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          if (latest != null)
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    l10n.liveLabel,
                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ],
              ),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(isBackgroundRunningProvider),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MapPlaceholder(latest: latest),
              const SizedBox(height: 16),

              if (latest != null) ...[
                CoordsCard(vm: vm, latest: latest, l10n: l10n),
                const SizedBox(height: 16),
              ] else
                EmptyLocationCard(l10n: l10n),

              BackgroundToggleCard(
                vm: vm,
                isRunning: isRunning,
                l10n: l10n,
                onToggle: (val) async {
                  await vm.toggleBackground(currentlyRunning: isRunning);
                  ref.invalidate(isBackgroundRunningProvider);
                },
              ),
              const SizedBox(height: 16),

              RecentLogSection(logAsync: logAsync, l10n: l10n),
            ],
          ),
        ),
      ),
    );
  }
}
