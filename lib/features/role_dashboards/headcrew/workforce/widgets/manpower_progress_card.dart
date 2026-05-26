// widgets/manpower_progress_card.dart

import 'package:flutter/material.dart';

class ManpowerProgressCard extends StatelessWidget {
  final int totalRequired;
  final int totalAssigned;

  const ManpowerProgressCard({
    super.key,
    required this.totalRequired,
    required this.totalAssigned,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalRequired == 0 ? 0.0 : totalAssigned / totalRequired;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '$totalAssigned / $totalRequired Filled',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: progress),
          ],
        ),
      ),
    );
  }
}
