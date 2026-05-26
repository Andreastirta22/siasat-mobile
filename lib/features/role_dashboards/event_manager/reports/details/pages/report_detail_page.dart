// details/pages/report_detail_page.dart

import 'package:flutter/material.dart';

import '../widgets/report_detail_header.dart';
import '../widgets/report_sales_grid.dart';
import '../widgets/report_notes_card.dart';

class ReportDetailPage extends StatelessWidget {
  const ReportDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),

          children: [
            const ReportDetailHeader(),

            const SizedBox(height: 24),

            const ReportSalesGrid(),

            const SizedBox(height: 24),

            const ReportNotesCard(),
          ],
        ),
      ),
    );
  }
}
