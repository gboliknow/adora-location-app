import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adora_location_app/base/base_change_notifier.dart';

final splashViewModelProvider = ChangeNotifierProvider<SplashViewModel>((ref) => SplashViewModel());

class SplashViewModel extends BaseChangeNotifier {
  // Splash logic here
}
