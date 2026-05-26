// daily_sales/widgets/report_status_badge.dart

import 'package:flutter/material.dart';

class ReportStatusBadge extends StatelessWidget {
  final String status;

  const ReportStatusBadge({super.key, required this.status});

  Color get badgeColor {
    switch (status) {
      case 'approved':
        return Colors.green;

      case 'reviewed':
        return Colors.orange;

      case 'rejected':
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}
