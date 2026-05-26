// daily_sales/widgets/sales_summary_card.dart

import 'package:flutter/material.dart';

class SalesSummaryCard extends StatelessWidget {
  final double grossSales;

  const SalesSummaryCard({super.key, required this.grossSales});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.black,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gross Sales',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),

          const SizedBox(height: 8),

          Text(
            'Rp ${grossSales.toStringAsFixed(0)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
