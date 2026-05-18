import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:adora_location_app/features/auth/splash/views/splash_view.dart';
import 'package:adora_location_app/features/location/permission/views/permission_view.dart';
import 'package:adora_location_app/features/location/shell/shell_view.dart';

class AppRoute {
  AppRoute._();

  static const String splashView = '/';
  static const String permissionView = '/permission';
  static const String shellView = '/home';

  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashView:
        return _buildRoute(settings, const SplashView());
      case permissionView:
        return _buildRoute(settings, const PermissionView());
      case shellView:
        return _buildRoute(settings, const ShellView());
      default:
        return _buildRoute(settings, const SplashView());
    }
  }

  static PageRoute<dynamic> _buildRoute(RouteSettings settings, Widget page) {
    if (Platform.isIOS) {
      return CupertinoPageRoute(settings: settings, builder: (_) => page);
    }
    return MaterialPageRoute(settings: settings, builder: (_) => page);
  }
}
