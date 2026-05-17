import 'package:flutter/material.dart';

import 'package:adora_location_app/models/location_point.dart';

class MapPlaceholder extends StatelessWidget {
  const MapPlaceholder({super.key, this.latest});

  final LocationPoint? latest;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blueGrey.shade100, Colors.blueGrey.shade200],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(painter: _GridPainter(), child: const SizedBox.expand()),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on, size: 48, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 4),
                if (latest != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '±${latest!.accuracy.toStringAsFixed(0)} m',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.25)
      ..strokeWidth = 1;
    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => false;
}
