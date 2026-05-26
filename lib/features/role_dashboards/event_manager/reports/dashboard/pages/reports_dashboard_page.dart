// dashboard/pages/reports_dashboard_page.dart

import 'package:flutter/material.dart';

import '../widgets/reports_header.dart';
import '../widgets/reports_tabbar.dart';
import '../widgets/report_stat_card.dart';
import '../widgets/sales_report_card.dart';

import '../widgets/reports_quick_actions.dart';

class ReportsDashboardPage extends StatelessWidget {
  const ReportsDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const ReportsHeader(),

            const SizedBox(height: 24),

            const ReportsTabbar(),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: ReportStatCard(
                    title: 'Gross Sales',
                    value: 'Rp 520JT',
                    icon: Icons.payments_outlined,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ReportStatCard(
                    title: 'Reports',
                    value: '32',
                    icon: Icons.receipt_long_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            const ReportsQuickActions(),

            const SizedBox(height: 24),

            const SalesReportCard(),
            const SizedBox(height: 16),

            const SalesReportCard(),
            const SizedBox(height: 16),

            const SalesReportCard(),
          ],
        ),
      ),
    );
  }
}
