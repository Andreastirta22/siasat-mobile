// daily_sales/pages/daily_sales_reports_page.dart

import 'package:flutter/material.dart';

import '../widgets/report_status_badge.dart';

class DailySalesReportsPage extends StatelessWidget {
  const DailySalesReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Sales Reports')),

      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 10,

        separatorBuilder: (_, __) {
          return const SizedBox(height: 14);
        },

        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.shade100,
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Holiday Ice Skating Festival',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const ReportStatusBadge(status: 'submitted'),
                  ],
                ),

                const SizedBox(height: 12),

                const Text('Margo City Main Atrium'),

                const SizedBox(height: 20),

                const Text('Gross Sales', style: TextStyle(color: Colors.grey)),

                const SizedBox(height: 6),

                const Text(
                  'Rp 52.450.000',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
