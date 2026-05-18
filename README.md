# Adora Location App

A Flutter app that tracks and logs your GPS position in the foreground and background on iOS and Android.

## Features

- **Foreground tracking** — live coordinate display with a "Live" badge, updated every 10 m of movement.
- **Background tracking** — continuous logging even when the app is minimised or the screen is off.
- **Location log** — persistent history of up to 500 fixes (newest first), colour-coded by source: green (foreground), orange (background), purple (terminated).
- **GPS-off detection** — instant banner with a direct link to location settings when GPS is disabled.
- **Low-accuracy warning** — amber indicator when fix accuracy exceeds 30 m.
- **No-fix timeout** — after 30 s without a fix the UI suggests moving to an open area.
- **Permission flow** — guided two-step iOS permission request (When-In-Use → Always) with "Open Settings" fallback for permanently denied state.
- **Localisation** — English and Japanese.

---

## Requirements

| Tool | Version |
|---|---|
| Flutter | 3.38.9 (stable) |
| Dart | ^3.10.8 |
| Xcode | 15+ (iOS 14+ target) |
| Android Studio / SDK | API 21+ |
| CocoaPods | 1.14+ |

---

## Setup

### 1. Clone and install dependencies

```bash
git clone https://github.com/gboliknow/adora-location-app.git
cd adora-location-app
flutter pub get
```

### 2. iOS — pod install (required after first clone)

```bash
cd ios && pod install && cd ..
```

> **Important**: The `ios/Podfile` contains a `post_install` block that sets
> `PERMISSION_LOCATION=1` and `PERMISSION_NOTIFICATIONS=1` in
> `GCC_PREPROCESSOR_DEFINITIONS`. **Do not remove this block.** Without it,
> `permission_handler` compiles out all iOS location code and every permission
> request silently returns `permanentlyDenied` with no dialog shown.

### 3. Run

```bash
# iOS simulator or device
flutter run -d <device-id>

# List available devices
flutter devices
```

---

## iOS background tracking — important limitations

| Limitation | Detail |
|---|---|
| **BGAppRefresh is rate-limited** | iOS decides when to wake the app (typically every 15–30 min). You cannot control the exact interval. |
| **No persistent notification** | Unlike Android, iOS does not show a notification bar entry. The blue location arrow (↑) in the status bar is the only OS indicator. |
| **BGTask identifier** | The `flutter_background_service_ios` plugin hardcodes `dev.flutter.background.refresh`. This identifier **must** be listed in `BGTaskSchedulerPermittedIdentifiers` in `Info.plist` (already configured). |
| **"Always" permission required** | Background tracking does not work with "When In Use" only. The app requests upgrade via the permission flow. |
| **Low-power mode** | iOS may suspend background tasks entirely in Low Power Mode. |

---

## Android background tracking

The app runs as a **foreground service** with a persistent notification showing live coordinates. This is required by the Android OS for long-running location work and keeps the process alive even under memory pressure.

Core library desugaring is enabled (`isCoreLibraryDesugaringEnabled = true`) to support Java 8+ time APIs on older Android versions.

---

## Project structure

See [ARCHITECTURE.md](ARCHITECTURE.md) for a full layer diagram, provider table, and edge-case handling summary.

---

## Test checklist

### Permissions

- [ ] Fresh install → permission rationale screen shown
- [ ] Tap "Always allow" → OS dialog appears → selecting "Always" navigates to Tracker
- [ ] Tap "Don't allow" → denied-once state shown with retry button
- [ ] Deny twice (or via Settings) → permanently denied state shown with "Open Settings" button
- [ ] Grant in Settings → return to app → navigates to Tracker automatically

### Foreground tracking

- [ ] Open Tracker tab → "Live" badge appears within ~10 s
- [ ] Coordinates update as device moves (distanceFilter = 10 m)
- [ ] Accuracy > 30 m → amber accuracy text + ⚠ icon shown
- [ ] GPS turned off → orange "GPS is turned off" card shown
- [ ] GPS re-enabled → card disappears, tracking resumes

### Background tracking

- [ ] Enable background toggle → toggle shows "on" state
- [ ] Minimise app → wait 1–2 min → re-open → new orange-badge entries in log
- [ ] Disable toggle → re-open → no new entries accumulate
- [ ] Android: foreground notification visible in notification tray while running

### iOS-specific

- [ ] `pod install` succeeds with no warnings about `GCC_PREPROCESSOR_DEFINITIONS`
- [ ] No `BGTaskSchedulerErrorDomain Code=3` errors in console
- [ ] Blue location arrow visible in status bar when foreground tracking is active

### Localisation

- [ ] Switch locale to Japanese → all strings update without restart
- [ ] Switch back to English → all strings update

### Edge cases

- [ ] No GPS fix for > 30 s → "Still searching…" card with amber icon appears
- [ ] Log capped at 500 entries — oldest entry deleted when 501st is saved
- [ ] Cold-start with existing log → log entries visible immediately on Tracker tab

---

## Makefile targets

```bash
make          # flutter pub get + pod install
make run      # flutter run
make clean    # flutter clean + pod deintegrate + pod install
make gen      # flutter gen-l10n (regenerate localisation files)
```


- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
