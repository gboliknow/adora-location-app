import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:adora_location_app/base/base_change_notifier.dart';
import 'package:adora_location_app/models/location_point.dart';
import 'package:adora_location_app/services/background/background_tracking_service.dart';

final homeViewModelProvider = ChangeNotifierProvider.autoDispose<HomeViewModel>((ref) {
  final vm = HomeViewModel();
  vm.startTimer();
  return vm;
});

/// Handles the background-tracking toggle and drives the "updated X ago" display.
class HomeViewModel extends BaseChangeNotifier {
  Timer? _timer;

  /// Starts a 1-second ticker so "updated X ago" text stays live.
  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => notifyListeners());
  }

  /// Toggle background tracking on or off.
  ///
  /// Returns [true] if the service is now running after the toggle.
  Future<bool> toggleBackground({required bool currentlyRunning}) async {
    setLoading(true);
    if (currentlyRunning) {
      await BackgroundTrackingService.stop();
      // Give the isolate a moment to shut down before querying state.
      await Future.delayed(const Duration(milliseconds: 300));
    } else {
      await BackgroundTrackingService.start();
      await Future.delayed(const Duration(milliseconds: 300));
    }
    setLoading(false);
    return BackgroundTrackingService.isRunning;
  }

  /// Human-readable "X ago" string for the most recent location timestamp.
  String timeAgo(DateTime? time) {
    if (time == null) return '';
    final diff = DateTime.now().difference(time);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    return '${diff.inHours}h ago';
  }

  /// Format a [LocationPoint] coordinate value for display.
  String formatCoord(double value, {int decimals = 5}) => value.toStringAsFixed(decimals);

  /// Source badge colour for a given [LocationSource].
  static int badgeColorValue(LocationSource source) {
    switch (source) {
      case LocationSource.foreground:
        return 0xFF4CAF50; // green
      case LocationSource.background:
        return 0xFFFF9800; // orange
      case LocationSource.terminated:
        return 0xFF9C27B0; // purple
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
