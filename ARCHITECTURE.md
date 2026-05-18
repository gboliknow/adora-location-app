# Architecture

## Layer overview

```
┌─────────────────────────────────────────┐
│              Presentation               │
│  Views (ConsumerWidget / StatefulWidget)│
│  ViewModels (ChangeNotifier via Riverpod)│
└─────────────────┬───────────────────────┘
                  │ watch / read providers
┌─────────────────▼───────────────────────┐
│               Providers                 │
│  location_providers.dart                │
│  StreamProvider / FutureProvider        │
└──────┬──────────────────────────────────┘
       │ depends on
┌──────▼──────────────────────────────────┐
│               Services                  │
│  LocationService   – geolocator stream  │
│  PermissionService – permission_handler │
│  BackgroundTrackingService – bg service │
│  NotificationService – Android channel  │
│  HiveService – local storage init       │
└──────┬──────────────────────────────────┘
       │ persists to
┌──────▼──────────────────────────────────┐
│              Repository                 │
│  LocationRepository – Hive box wrapper  │
└─────────────────────────────────────────┘
```

## State management

Riverpod 2.x is used throughout.

| Provider | Type | Purpose |
|---|---|---|
| `locationServiceProvider` | `Provider` | Singleton `LocationService` |
| `locationRepoProvider` | `Provider` | Singleton `LocationRepository` |
| `permissionServiceProvider` | `Provider` | Singleton `PermissionService` |
| `locationLogProvider` | `StreamProvider` | Full sorted log; merges Hive + BG pings |
| `latestLocationProvider` | `Provider` | Derived — head of `locationLogProvider` |
| `gpsServiceProvider` | `StreamProvider<bool>` | Live GPS-enabled state via `getServiceStatusStream` |
| `isBackgroundRunningProvider` | `FutureProvider<bool>` | Background service running state |
| `foregroundTrackingProvider` | `StreamProvider.autoDispose` | Saves foreground fixes while HomeView is mounted |
| `permissionViewModelProvider` | `ChangeNotifierProvider` | Permission request flow state |
| `homeViewModelProvider` | `ChangeNotifierProvider.autoDispose` | Tracker UI state + toggle logic |

ViewModels extend `BaseChangeNotifier` (adds a `loading` flag). The view layer only reads/watches providers — it never directly instantiates services.

## Background tracking

### Android
`flutter_background_service` runs `onAndroidStart` as a **foreground service** (persistent notification required by the OS). The isolate opens its own Hive box, streams `Geolocator.getPositionStream`, saves each fix, then calls `service.invoke('locationUpdate')` to ping the UI isolate.

### iOS
`flutter_background_service` uses **BGTaskScheduler** (`BGAppRefreshTask`). The task identifier `dev.flutter.background.refresh` is hardcoded by the plugin — it must appear in `BGTaskSchedulerPermittedIdentifiers` in `Info.plist`. The OS grants ~30 s of CPU time per wake-up; `CLLocationManager` with `allowsBackgroundLocationUpdates = true` continues accumulating fixes between wake-ups. There is **no persistent notification** on iOS (unlike Android).

## Location log merge strategy

The `locationLogProvider` needs to react to writes from two sources that cannot share an in-memory stream:

1. **Same-isolate writes** (foreground `LocationService`) — watched via Hive's `box.watch()`.
2. **Cross-isolate writes** (background service isolate) — the isolate cannot share a `StreamController` with main, so it sends a lightweight `'locationUpdate'` event over `FlutterBackgroundService.invoke`, which the UI listens to and uses as a re-read trigger.

Both signals feed a shared `StreamController<void>` that triggers a `repo.getAll()` re-read.

## Permission flow (iOS)

iOS requires a two-step permission request:

1. `Permission.location.request()` → shows "When In Use" dialog.
2. `Permission.locationAlways.request()` → OS redirects user to Settings to upgrade.

`PermissionService` handles this automatically. The `PermissionViewModel` calls `_checkCurrentStatus()` on init (to handle the case where permission was already granted), and `PermissionView` calls `recheckStatus()` when the app resumes from background (to detect the user returning from Settings).

**Critical iOS build requirement**: `permission_handler` compiles location support only when `PERMISSION_LOCATION=1` is set in `GCC_PREPROCESSOR_DEFINITIONS` inside the Podfile `post_install` block. Without it, all location permission requests silently return `permanentlyDenied` without showing any dialog.

## Error / edge-case handling

| Scenario | Detection | UI response |
|---|---|---|
| GPS turned off | `gpsServiceProvider` emits `false` | `GpsOffCard` with "Enable GPS" button |
| No GPS fix after 30 s | `HomeViewModel.elapsedSeconds > 30 && latest == null` | `EmptyLocationCard(timedOut: true)` with hint to move outdoors |
| Low accuracy (> 30 m) | `latest.accuracy > LocationService.lowAccuracyWarningMeters` | Amber accuracy text + warning icon in `CoordsCard` |
| Permission permanently denied | `PermissionState.deniedForever` | `DeniedForeverContent` with "Open Settings" button |
| Permission denied once | `PermissionState.deniedOnce` | `RequestContent` with rationale + retry button |

## File structure

```
lib/
├── app.dart                        # MaterialApp + theme + locale
├── app_constants.dart
├── main.dart                       # Bootstrap: Hive → Notification → BG service
├── base/
│   └── base_change_notifier.dart   # Shared loading-flag ChangeNotifier
├── core/
│   ├── extensions/context_extension.dart
│   └── locale/                     # EN/JA locale toggle
├── features/
│   ├── auth/
│   │   ├── login/                  # Login view + VM (placeholder)
│   │   └── splash/                 # Splash: routes to permission or home
│   └── location/
│       ├── home/                   # Tracker screen (coords, toggle, log)
│       ├── log/                    # Full location history
│       ├── permission/             # Permission request / denied screens
│       ├── shell/                  # Bottom-nav shell
│       └── widgets/                # Shared location widgets
├── l10n/                           # ARB files + generated Dart classes (EN + JA)
├── models/
│   └── location_point.dart         # Immutable GPS fix snapshot
├── providers/
│   └── location_providers.dart     # All Riverpod providers
├── repositories/
│   └── location_repository.dart    # Hive-backed location store (capped 500)
├── routes/
│   └── route.dart
└── services/
    ├── background/
    │   ├── android_background_handler.dart  # Isolate entry-point
    │   ├── background_tracking_service.dart # Platform-agnostic facade
    │   └── notification_service.dart        # Android notification channel
    ├── local/
    │   └── hive_service.dart
    ├── location/
    │   └── location_service.dart
    └── permission/
        └── permission_service.dart
```
