// details/widgets/report_sales_grid.dart

import 'package:flutter/material.dart';

class ReportSalesGrid extends StatelessWidget {
  const ReportSalesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      crossAxisCount: 2,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 1.2,

      children: const [
        _SalesCard(title: 'Ticket Sales', value: 'Rp 45.200.000'),

        _SalesCard(title: 'Insurance', value: 'Rp 2.100.000'),

        _SalesCard(title: 'Coach', value: 'Rp 1.500.000'),

        _SalesCard(title: 'Gross Sales', value: 'Rp 52.450.000'),
      ],
    );
  }
}

class _SalesCard extends StatelessWidget {
  final String title;
  final String value;

  const _SalesCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.grey.shade100,
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),

          const Spacer(),

          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
