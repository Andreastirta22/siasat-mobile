import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'dashboard_container.dart';

class DashboardStatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String title;

  const DashboardStatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return DashboardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 32, color: AppColors.text(context)),

          const Spacer(),

          Text(
            value,
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: AppColors.text(context),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            title,
            style: TextStyle(fontSize: 18, color: AppColors.subtitle(context)),
          ),
        ],
      ),
    );
  }
}
