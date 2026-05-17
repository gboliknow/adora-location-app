// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'Adora 定位应用';

  @override
  String get canceledApiRequest => '请求已取消。';

  @override
  String get apiConnectionTimeout => '连接超时。';

  @override
  String get apiBadCertificate => '证书无效。';

  @override
  String get apiConnectionError => '无网络连接。';

  @override
  String get apiUnknownConnection => '发生未知错误。';

  @override
  String get apiResponseTimeout => '响应超时。';

  @override
  String get apiBadRequest => '无效请求。';
}
