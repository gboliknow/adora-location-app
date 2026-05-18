// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'Adora ロケーションアプリ';

  @override
  String get canceledApiRequest => 'リクエストがキャンセルされました。';

  @override
  String get apiConnectionTimeout => '接続がタイムアウトしました。';

  @override
  String get apiBadCertificate => '証明書が無効です。';

  @override
  String get apiConnectionError => 'インターネット接続がありません。';

  @override
  String get apiUnknownConnection => '不明なエラーが発生しました。';

  @override
  String get apiResponseTimeout => 'レスポンスがタイムアウトしました。';

  @override
  String get apiBadRequest => '不正なリクエストです。';

  @override
  String get permissionTitle => '位置情報へのアクセスを許可';

  @override
  String get permissionBody => 'このアプリは、フォアグラウンドおよびバックグラウンドで位置情報を記録するために位置情報へのアクセスが必要です。';

  @override
  String get allowWhileUsing => '使用中のみ許可';

  @override
  String get alwaysAllow => '常に許可';

  @override
  String get dontAllow => '許可しない';

  @override
  String get permissionDeniedTitle => '位置情報へのアクセスが拒否されました';

  @override
  String get permissionDeniedOnceBody => 'バックグラウンド追跡には「常に許可」が必要です。もう一度お試しください。';

  @override
  String get permissionDeniedForeverBody => '位置情報のアクセス許可が永久に拒否されました。設定で有効にしてください。';

  @override
  String get openSettings => '設定を開く';

  @override
  String get trackerTitle => 'トラッカー';

  @override
  String get liveLabel => 'ライブ';

  @override
  String get latitudeLabel => '緯度';

  @override
  String get longitudeLabel => '経度';

  @override
  String get accuracyLabel => '精度';

  @override
  String get updatedLabel => '更新済み';

  @override
  String get backgroundTrackingTitle => 'バックグラウンド追跡';

  @override
  String get enableBackgroundTracking => 'バックグラウンド追跡を有効にする';

  @override
  String get backgroundTrackingSubtitle => 'アプリを閉じても追跡を継続';

  @override
  String get recentLogTitle => '最近のログ';

  @override
  String get noLocationYet => '位置情報を待っています…';

  @override
  String get sourceForeground => '前景';

  @override
  String get sourceBackground => '背景';

  @override
  String get sourceTerminated => '終了';

  @override
  String get logTitle => '位置ログ';

  @override
  String get clearLog => 'クリア';

  @override
  String get noLogEntries => '位置情報の記録がありません。';

  @override
  String get gpsOffTitle => 'GPSがオフになっています';

  @override
  String get gpsOffBody => '位置情報サービスを有効にして追跡を開始してください。';

  @override
  String get enableGps => 'GPSを有効にする';

  @override
  String get fixTimeoutMessage => 'GPSを探しています \u2014 屋外に移動してみてください。';

  @override
  String get lowAccuracyWarning => '精度が低い \u2014 信号が遮断されている可能性があります';
}
