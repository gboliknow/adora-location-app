import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

enum PermissionResult { granted, deniedOnce, deniedForever, locationServiceOff }

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
