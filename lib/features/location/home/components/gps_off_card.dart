import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

/// Shown in [HomeView] when the device's location service is turned off.
///
/// Displays a clear explanation and an "Enable GPS" button that opens the
/// system location-settings screen so the user can re-enable it without
/// leaving the flow manually.
class GpsOffCard extends StatelessWidget {
  const GpsOffCard({super.key, required this.l10n});

  final dynamic l10n;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.orange.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.orange.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_off_rounded, color: Colors.orange.shade700, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.gpsOffTitle,
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.orange.shade900),
                      ),
                      const SizedBox(height: 2),
                      Text(l10n.gpsOffBody, style: TextStyle(fontSize: 13, color: Colors.orange.shade800)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: Geolocator.openLocationSettings,
                icon: const Icon(Icons.settings_outlined, size: 16),
                label: Text(l10n.enableGps),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.orange.shade800,
                  side: BorderSide(color: Colors.orange.shade400),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
