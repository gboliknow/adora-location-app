import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:adora_location_app/base/base_change_notifier.dart';
import 'package:adora_location_app/providers/location_providers.dart';
import 'package:adora_location_app/routes/route.dart';
import 'package:adora_location_app/services/permission/permission_service.dart';

final splashViewModelProvider = ChangeNotifierProvider<SplashViewModel>(
  (ref) => SplashViewModel(ref.read(permissionServiceProvider)),
);

class SplashViewModel extends BaseChangeNotifier {
  SplashViewModel(this._permissionService);

  final PermissionService _permissionService;

  /// Null until [init] has resolved.
  String? nextRoute;

  Future<void> init() async {
    await Future.delayed(const Duration(seconds: 1));

    final granted = await _permissionService.isGranted;
    nextRoute = granted ? AppRoute.shellView : AppRoute.permissionView;
    notifyListeners();
  }
}
