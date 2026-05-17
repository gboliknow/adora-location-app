import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:adora_location_app/base/base_change_notifier.dart';
import 'package:adora_location_app/providers/location_providers.dart';

final logViewModelProvider = ChangeNotifierProvider.autoDispose<LogViewModel>((ref) => LogViewModel(ref));

class LogViewModel extends BaseChangeNotifier {
  LogViewModel(this._ref);

  final Ref _ref;

  /// Delete all location entries from Hive.
  Future<void> clearLog() async {
    setLoading(true);
    await _ref.read(locationRepoProvider).clear();
    setLoading(false);
  }
}
