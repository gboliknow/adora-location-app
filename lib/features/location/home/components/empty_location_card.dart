import 'package:flutter/material.dart';

class EmptyLocationCard extends StatelessWidget {
  const EmptyLocationCard({super.key, required this.l10n});

  final dynamic l10n;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.grey[400])),
            const SizedBox(width: 10),
            Text(l10n.noLocationYet, style: TextStyle(color: Colors.grey[500], fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
