// dashboard/widgets/reports_tabbar.dart

import 'package:flutter/material.dart';

class ReportsTabbar extends StatelessWidget {
  const ReportsTabbar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,

      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildTab(label: 'All Reports', selected: true),

          _buildTab(label: 'Draft'),

          _buildTab(label: 'Submitted'),

          _buildTab(label: 'Approved'),
        ],
      ),
    );
  }

  Widget _buildTab({required String label, bool selected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 12),

      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

      decoration: BoxDecoration(
        color: selected ? Colors.black : Colors.grey.shade200,

        borderRadius: BorderRadius.circular(100),
      ),

      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
