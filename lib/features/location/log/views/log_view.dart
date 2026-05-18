import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:adora_location_app/core/extensions/context_extension.dart';
import 'package:adora_location_app/core/locale/locale_toggle.dart';
import 'package:adora_location_app/features/location/log/vm/log_viewmodel.dart';
import 'package:adora_location_app/features/location/widgets/location_log_tile.dart';
import 'package:adora_location_app/providers/location_providers.dart';

class LogView extends ConsumerWidget {
  const LogView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(logViewModelProvider);
    final l10n = context.localizations;
    final logAsync = ref.watch(locationLogProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.logTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          const LocaleToggle(),
          logAsync.maybeWhen(
            data: (log) => log.isNotEmpty
                ? IconButton(
                    tooltip: l10n.clearLog,
                    icon: vm.loading
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.delete_outline),
                    onPressed: vm.loading ? null : () => _confirmClear(context, vm, l10n),
                  )
                : const SizedBox.shrink(),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: logAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (log) {
          if (log.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_off_outlined, size: 48, color: Colors.grey[300]),
                  const SizedBox(height: 12),
                  Text(l10n.noLogEntries, style: TextStyle(color: Colors.grey[500], fontSize: 15)),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: log.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade100),
            itemBuilder: (_, i) => LocationLogTile(point: log[i]),
          );
        },
      ),
    );
  }

  void _confirmClear(BuildContext context, LogViewModel vm, dynamic l10n) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.clearLog),
        content: Text(l10n.noLogEntries),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.dontAllow)),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              vm.clearLog();
            },
            child: Text(l10n.clearLog),
          ),
        ],
      ),
    );
  }
}
