import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

/// Outcome of a single [PermissionService.requestLocationPermission] call.
enum PermissionResult { granted, deniedOnce, deniedForever, locationServiceOff }

/// Abstracts platform permission dialogs behind a simple enum result.
///
/// iOS note: The OS requires "When In Use" to be granted before the app can
/// ask for "Always". [requestLocationPermission] handles this two-step flow
/// automatically.
///
/// **Podfile requirement** — `permission_handler` needs
/// `PERMISSION_LOCATION=1` in the iOS `GCC_PREPROCESSOR_DEFINITIONS` Podfile
/// block, otherwise all location requests silently return `permanentlyDenied`.
class PermissionService {
  Future<PermissionResult> requestLocationPermission() async {
    // iOS requires When-In-Use to be granted before Always can be requested.
    if (Platform.isIOS) {
      final whenInUse = await Permission.location.request();
      if (whenInUse.isPermanentlyDenied) return PermissionResult.deniedForever;
      if (whenInUse.isDenied) return PermissionResult.deniedOnce;

      await Permission.locationAlways.request();
      return PermissionResult.granted;
    }

    final location = await Permission.location.request();
    if (location.isPermanentlyDenied) return PermissionResult.deniedForever;
    if (location.isDenied) return PermissionResult.deniedOnce;

    final always = await Permission.locationAlways.request();
    if (always.isPermanentlyDenied) return PermissionResult.deniedForever;
    if (always.isDenied) return PermissionResult.deniedOnce;

    return PermissionResult.granted;
  }

  Future<bool> get isGranted async => await Permission.locationAlways.isGranted || await Permission.location.isGranted;

  Future<bool> get isAlwaysGranted => Permission.locationAlways.isGranted;

  Future<bool> get isPermanentlyDenied => Permission.location.isPermanentlyDenied;

  Future<void> openSettings() => openAppSettings();
}
