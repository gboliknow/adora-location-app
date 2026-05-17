import 'package:permission_handler/permission_handler.dart';

enum PermissionResult { granted, deniedOnce, deniedForever, locationServiceOff }

class PermissionService {
  // OS requires "when in use" first; only then can we escalate to "always".
  Future<PermissionResult> requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isPermanentlyDenied) return PermissionResult.deniedForever;
    if (status.isDenied) return PermissionResult.deniedOnce;

    final alwaysStatus = await Permission.locationAlways.request();
    if (alwaysStatus.isPermanentlyDenied) return PermissionResult.deniedForever;
    if (alwaysStatus.isDenied) return PermissionResult.deniedOnce;

    return PermissionResult.granted;
  }

  Future<bool> get isAlwaysGranted => Permission.locationAlways.isGranted;
  Future<bool> get isGranted => Permission.location.isGranted;
  Future<void> openSettings() => openAppSettings();
}
