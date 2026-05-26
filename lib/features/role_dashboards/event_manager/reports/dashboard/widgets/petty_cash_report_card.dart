import 'package:flutter/material.dart';

import '../utils/report_formatter.dart';
import 'financial_item.dart';

class PettyCashReportCard extends StatelessWidget {
  final Map<String, dynamic> report;

  const PettyCashReportCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final eventName = report['events']?['name'] ?? 'Unknown Event';

    final venueName = report['venues']?['name'] ?? 'Unknown Venue';

    final headcrewName = report['profiles']?['full_name'] ?? 'Unknown Headcrew';

    final status = report['status'] ?? 'draft';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  eventName,
                  style: const TextStyle(
                    fontSize: 18,
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
                  color: getStatusColor(status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    color: getStatusColor(status),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(venueName, style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 18),
          FinancialItem(
            title: 'Total Expense',
            value: formatCurrency(report['total_expense']),
          ),
          const SizedBox(height: 18),
          Divider(color: Colors.grey.shade200),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.person, size: 18, color: Colors.grey),
              const SizedBox(width: 6),
              Text(headcrewName),
              const Spacer(),
              Text(
                report['report_date'] ?? '',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
