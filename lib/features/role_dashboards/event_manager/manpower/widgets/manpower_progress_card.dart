// features/role_dashboards/event_manager/manpower/widgets/manpower_progress_card.dart

import 'package:flutter/material.dart';

class ManpowerProgressCard extends StatelessWidget {
  final String role;
  final int assignedCount;
  final int requiredCount;

  const ManpowerProgressCard({
    super.key,
    required this.role,
    required this.assignedCount,
    required this.requiredCount,
  });

  @override
  Widget build(BuildContext context) {
    final progress = requiredCount == 0 ? 0.0 : assignedCount / requiredCount;

    final isFulfilled = assignedCount >= requiredCount;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  role.replaceAll('_', ' ').toUpperCase(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isFulfilled
                      ? const Color(0xFFDCFCE7)
                      : const Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  '$assignedCount / $requiredCount',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isFulfilled
                        ? const Color(0xFF15803D)
                        : const Color(0xFF1D4ED8),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(
                isFulfilled ? const Color(0xFF22C55E) : const Color(0xFF3B82F6),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            isFulfilled
                ? 'Manpower fulfilled'
                : 'Waiting additional assignment',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
