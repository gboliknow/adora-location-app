import 'package:flutter/material.dart';

/// Base class for all view models in this app.
///
/// Adds a [loading] flag with [setLoading] so every view model can drive
/// loading spinners without duplicating boilerplate.
class BaseChangeNotifier extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool val) {
    _loading = val;
    notifyListeners();
  }
}
