import 'package:flutter/material.dart';

import 'manpower_stat_card.dart';

class ManpowerStatGrid extends StatelessWidget {
  final int totalCrew;
  final int totalHeadcrew;
  final int totalCoach;
  final int totalActiveWorkforce;

  const ManpowerStatGrid({
    super.key,
    required this.totalCrew,
    required this.totalHeadcrew,
    required this.totalCoach,
    required this.totalActiveWorkforce,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardColor = isDark ? Colors.white : const Color(0xFF111827);

    final textColor = isDark ? Colors.black : Colors.white;

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.15,

      children: [
        /// TOTAL CREW
        ManpowerStatCard(
          title: 'Total Crew',
          value: totalCrew.toString(),
          icon: Icons.groups_rounded,
          color: Colors.green,
          cardColor: cardColor,
          textColor: textColor,
        ),

        /// HEADCREW
        ManpowerStatCard(
          title: 'Headcrew',
          value: totalHeadcrew.toString(),
          icon: Icons.admin_panel_settings_rounded,
          color: Colors.orange,
          cardColor: cardColor,
          textColor: textColor,
        ),

        /// COACH
        ManpowerStatCard(
          title: 'Coach',
          value: totalCoach.toString(),
          icon: Icons.school_rounded,
          color: Colors.blue,
          cardColor: cardColor,
          textColor: textColor,
        ),

        /// ACTIVE WORKFORCE
        ManpowerStatCard(
          title: 'Active Workforce',
          value: totalActiveWorkforce.toString(),
          icon: Icons.badge_rounded,
          color: Colors.red,
          cardColor: cardColor,
          textColor: textColor,
        ),
      ],
    );
  }
}
