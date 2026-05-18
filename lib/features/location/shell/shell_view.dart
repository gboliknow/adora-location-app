import 'package:flutter/material.dart';

import 'package:adora_location_app/core/extensions/context_extension.dart';
import 'package:adora_location_app/features/location/home/views/home_view.dart';
import 'package:adora_location_app/features/location/log/views/log_view.dart';

class ShellView extends StatefulWidget {
  const ShellView({super.key});

  @override
  State<ShellView> createState() => _ShellViewState();
}

class _ShellViewState extends State<ShellView> {
  int _index = 0;

  static const _pages = [HomeView(), LogView()];

  @override
  Widget build(BuildContext context) {
    final l10n = context.localizations;

    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.map_outlined),
            selectedIcon: const Icon(Icons.map),
            label: l10n.trackerTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.list_alt_outlined),
            selectedIcon: const Icon(Icons.list_alt),
            label: l10n.logTitle,
          ),
        ],
      ),
    );
  }
}
