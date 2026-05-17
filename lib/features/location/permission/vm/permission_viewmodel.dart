import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:adora_location_app/base/base_change_notifier.dart';
import 'package:adora_location_app/providers/location_providers.dart';
import 'package:adora_location_app/services/permission/permission_service.dart';

/// Tracks the current state of the permission request flow.
enum PermissionState {
  initial, // First launch — show rationale
  deniedOnce, // User tapped deny — show try-again message
  deniedForever, // Permanently denied — show open-settings prompt
  granted, // Permission granted — UI navigates away
}

final permissionViewModelProvider = ChangeNotifierProvider<PermissionViewModel>(
  (ref) => PermissionViewModel(ref.read(permissionServiceProvider)),
);

class PermissionViewModel extends BaseChangeNotifier {
  PermissionViewModel(this._permissionService);

  final PermissionService _permissionService;

  PermissionState _state = PermissionState.initial;
  PermissionState get state => _state;

  /// Request "Always" location permission — the level needed for background tracking.
  /// Updates [state] so the view can react without knowing about [PermissionService].
  Future<void> requestAlways() async {
    setLoading(true);
    final result = await _permissionService.requestLocationPermission();
    setLoading(false);

    switch (result) {
      case PermissionResult.granted:
        _state = PermissionState.granted;
      case PermissionResult.deniedOnce:
      case PermissionResult.locationServiceOff:
        _state = PermissionState.deniedOnce;
      case PermissionResult.deniedForever:
        _state = PermissionState.deniedForever;
    }
    notifyListeners();
  }

  /// Request "When in use" only — background tracking won't work but foreground will.
  Future<void> requestWhenInUse() async {
    setLoading(true);
    final granted = await _permissionService.isGranted;
    if (!granted) {
      await _permissionService.requestLocationPermission();
    }
    final nowGranted = await _permissionService.isGranted;
    setLoading(false);

    _state = nowGranted ? PermissionState.granted : PermissionState.deniedOnce;
    notifyListeners();
  }

  /// Open the OS settings page so the user can manually change permissions.
  Future<void> openSettings() => _permissionService.openSettings();

  void reset() {
    _state = PermissionState.initial;
    notifyListeners();
  }
}
