import 'package:flutter/material.dart';

class EmptyLocationCard extends StatelessWidget {
  const EmptyLocationCard({super.key, required this.l10n, this.timedOut = false});

  final dynamic l10n;

  /// [true] when > 30 s have passed with no GPS fix — swaps the spinner for a
  /// "still searching" hint with an amber warning icon.
  final bool timedOut;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: timedOut ? Colors.amber.shade200 : Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: timedOut
              ? [
                  Icon(Icons.gps_not_fixed, color: Colors.amber.shade700, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(l10n.fixTimeoutMessage, style: TextStyle(color: Colors.amber.shade800, fontSize: 14)),
                  ),
                ]
              : [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.grey[400]),
                  ),
                  const SizedBox(width: 10),
                  Text(l10n.noLocationYet, style: TextStyle(color: Colors.grey[500], fontSize: 14)),
                ],
        ),
      ),
    );
  }
}
