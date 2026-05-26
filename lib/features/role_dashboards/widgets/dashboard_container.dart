import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class DashboardContainer extends StatelessWidget {
  final Widget child;

  const DashboardContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: child,
    );
  }
}
