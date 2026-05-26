// evidences/widgets/upload_progress_indicator.dart

import 'package:flutter/material.dart';

class UploadProgressIndicator extends StatelessWidget {
  final double progress;

  const UploadProgressIndicator({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: progress,
          minHeight: 10,
          borderRadius: BorderRadius.circular(100),
        ),

        const SizedBox(height: 12),

        Text(
          '${(progress * 100).toInt()}%',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
