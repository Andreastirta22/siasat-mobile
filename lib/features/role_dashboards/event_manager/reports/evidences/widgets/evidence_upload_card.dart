// evidences/widgets/evidence_upload_card.dart

import 'package:flutter/material.dart';

class EvidenceUploadCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const EvidenceUploadCard({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade300),
        ),

        child: Column(
          children: [
            Icon(Icons.upload_rounded, size: 42, color: Colors.grey.shade700),

            const SizedBox(height: 14),

            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
