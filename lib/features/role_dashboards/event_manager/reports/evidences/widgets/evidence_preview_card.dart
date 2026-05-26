// evidences/widgets/evidence_preview_card.dart

import 'package:flutter/material.dart';

class EvidencePreviewCard extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onRemove;

  const EvidencePreviewCard({
    super.key,
    required this.imageUrl,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24),

          child: Image.network(
            imageUrl,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),

        Positioned(
          top: 12,
          right: 12,

          child: GestureDetector(
            onTap: onRemove,

            child: Container(
              padding: const EdgeInsets.all(8),

              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),

              child: const Icon(Icons.close, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
