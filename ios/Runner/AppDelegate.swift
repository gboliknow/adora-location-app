import Flutter
import UIKit
import BackgroundTasks
import CoreLocation

/// AppDelegate configures two iOS background-tracking mechanisms:
///
///  1. **BGProcessingTask** (`com.example.adoraLocationApp.refresh`)
///     The OS schedules periodic CPU wakeups (~30 s each). The task ID must
///     match the value in Info.plist `BGTaskSchedulerPermittedIdentifiers`.
///     Wakeup frequency is decided by iOS based on battery, usage patterns,
///     and device conditions — not under app control.
///
///  2. **Significant-location-change monitoring** (CLLocationManager)
///     Wakes the app (including from terminated state) when the device moves
///     ~500 m or switches cell towers. Requires "Always" location permission.
///     This is the most reliable terminated-state tracking available on iOS.
///
/// **Known OS limitations:**
///  - BGProcessingTask may be throttled or skipped entirely by iOS Low Power Mode.
///  - Significant-change accuracy is coarser than GPS — suitable for logging
///    general movement, not fine-grained paths.
///  - Both mechanisms require NSLocationAlwaysAndWhenInUseUsageDescription and
///    the "location" UIBackgroundModes entry in Info.plist.
@main
@objc class AppDelegate: FlutterAppDelegate, CLLocationManagerDelegate {

  private let locationManager = CLLocationManager()
  private let bgTaskId = "com.example.adoraLocationApp.refresh"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest

    // Register the BGProcessingTask — must happen before the end of app launch.
    BGTaskScheduler.shared.register(
      forTaskWithIdentifier: bgTaskId,
      using: nil
    ) { [weak self] task in
      guard let processingTask = task as? BGProcessingTask else { return }
      self?.handleBGProcessingTask(processingTask)
    }

    // If iOS relaunched us due to a significant-location-change event,
    // resume monitoring immediately so we don't miss further updates.
    if launchOptions?[.location] != nil {
      locationManager.startMonitoringSignificantLocationChanges()
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // MARK: - Public control (called by flutter_background_service iOS hooks)

  /// Start significant-change monitoring and queue a BGProcessingTask.
  /// Survives app termination — iOS will relaunch the app on movement.
  @objc func startSignificantLocationChanges() {
    locationManager.startMonitoringSignificantLocationChanges()
    scheduleBGTask()
  }

  /// Stop all background location tracking.
  @objc func stopSignificantLocationChanges() {
    locationManager.stopMonitoringSignificantLocationChanges()
    BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: bgTaskId)
  }

  // MARK: - BGProcessingTask

  private func scheduleBGTask() {
    let request = BGProcessingTaskRequest(identifier: bgTaskId)
    request.requiresNetworkConnectivity = false
    request.requiresExternalPower = false
    // Earliest allowed wakeup — iOS may defer further based on system conditions.
    request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60) // 15 minutes

    do {
      try BGTaskScheduler.shared.submit(request)
    } catch {
      print("[BGTask] Schedule failed: \(error.localizedDescription)")
    }
  }

  private func handleBGProcessingTask(_ task: BGProcessingTask) {
    // Re-schedule immediately so there is always a pending request queued.
    scheduleBGTask()

    // Set an expiration handler in case the 30-s budget runs out.
    task.expirationHandler = {
      task.setTaskCompleted(success: false)
    }

    // The flutter_background_service onBackground handler (onIosBackground)
    // has already been invoked by the plugin at this point.
    task.setTaskCompleted(success: true)
  }

  // MARK: - CLLocationManagerDelegate

  func locationManager(
    _ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]
  ) {
    guard let loc = locations.last else { return }
    // Significant-change events arrive here. geolocator's own delegate
    // also receives them — this log confirms the native layer is alive.
    print(
      "[iOS SigChange] lat=\(loc.coordinate.latitude) "
        + "lng=\(loc.coordinate.longitude) "
        + "acc=\(Int(loc.horizontalAccuracy)) m"
    )
  }

  func locationManager(
    _ manager: CLLocationManager,
    didFailWithError error: Error
  ) {
    print("[iOS Location] Error: \(error.localizedDescription)")
  }

  // MARK: - App lifecycle

  override func applicationDidEnterBackground(_ application: UIApplication) {
    // Queue a BGProcessingTask every time the app backgrounds.
    scheduleBGTask()
    super.applicationDidEnterBackground(application)
  }
}
