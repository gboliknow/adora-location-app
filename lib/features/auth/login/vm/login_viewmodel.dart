import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adora_location_app/base/base_change_notifier.dart';

final loginViewModelProvider = ChangeNotifierProvider<LoginViewModel>((ref) => LoginViewModel());

class LoginViewModel extends BaseChangeNotifier {
  // Login logic here
}
