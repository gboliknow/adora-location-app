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

  @override
  String get permissionTitle => '允许位置访问';

  @override
  String get permissionBody => '此应用需要位置权限，以便在前台和后台记录您的位置。';

  @override
  String get allowWhileUsing => '使用时允许';

  @override
  String get alwaysAllow => '始终允许';

  @override
  String get dontAllow => '不允许';

  @override
  String get permissionDeniedTitle => '位置访问被拒绝';

  @override
  String get permissionDeniedOnceBody => '后台追踪需要「始终」位置权限，请重试。';

  @override
  String get permissionDeniedForeverBody => '位置权限已被永久拒绝，请在设置中开启。';

  @override
  String get openSettings => '打开设置';

  @override
  String get trackerTitle => '追踪器';

  @override
  String get liveLabel => '实时';

  @override
  String get latitudeLabel => '纬度';

  @override
  String get longitudeLabel => '经度';

  @override
  String get accuracyLabel => '精度';

  @override
  String get updatedLabel => '更新于';

  @override
  String get backgroundTrackingTitle => '后台追踪';

  @override
  String get enableBackgroundTracking => '启用后台追踪';

  @override
  String get backgroundTrackingSubtitle => '应用关闭后继续追踪';

  @override
  String get recentLogTitle => '最近记录';

  @override
  String get noLocationYet => '等待位置信息…';

  @override
  String get sourceForeground => '前台';

  @override
  String get sourceBackground => '后台';

  @override
  String get sourceTerminated => '已终止';

  @override
  String get logTitle => '位置日志';

  @override
  String get clearLog => '清除';

  @override
  String get noLogEntries => '暂无位置记录。';
}
