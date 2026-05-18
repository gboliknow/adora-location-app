import 'package:flutter/material.dart';
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
  PermissionViewModel(this._permissionService) {
    _checkCurrentStatus();
  }

  final PermissionService _permissionService;

  PermissionState _state = PermissionState.initial;
  PermissionState get state => _state;

  /// Called on init and when returning from Settings — syncs state to the
  /// real iOS/Android permission status without triggering a new request dialog.
  Future<void> recheckStatus() async {
    final isGranted = await _permissionService.isGranted;
    if (isGranted) {
      _state = PermissionState.granted;
      notifyListeners();
      return;
    }
    final denied = await _permissionService.isPermanentlyDenied;
    if (denied) {
      _state = PermissionState.deniedForever;
    } else {
      _state = PermissionState.initial;
    }
    notifyListeners();
  }

  Future<void> _checkCurrentStatus() => recheckStatus();

  /// Request "Always" location permission — the level needed for background tracking.
  /// Updates [state] so the view can react without knowing about [PermissionService].
  Future<void> requestAlways() async {
    try {
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
    } catch (e) {
      debugPrint('Error requesting permission: $e');
      setLoading(false);
    }
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
