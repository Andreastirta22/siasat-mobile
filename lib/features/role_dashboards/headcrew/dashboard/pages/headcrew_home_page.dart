import 'package:flutter/material.dart';

import '../widgets/activity_tile.dart';
import '../widgets/dashboard_stat_card.dart';
import '../widgets/quick_action_card.dart';

class HeadcrewHomePage extends StatelessWidget {
  const HeadcrewHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark
        ? const Color(0xFF0F172A)
        : const Color(0xFFF5F7FA);

    final cardColor = isDark ? Colors.white : const Color(0xFF111827);

    final primaryTextColor = isDark ? Colors.black : Colors.white;

    final secondaryTextColor = isDark ? Colors.black54 : Colors.white70;

    final titleColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Headcrew Dashboard',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Coordinate manpower, monitor operational readiness, and manage field execution.',
                style: TextStyle(
                  fontSize: 15,
                  color: isDark ? Colors.white70 : Colors.grey.shade700,
                ),
              ),

              const SizedBox(height: 28),

              Row(
                children: [
                  Expanded(
                    child: DashboardStatCard(
                      title: 'Active Crew',
                      value: '24',
                      icon: Icons.groups_2_rounded,
                      color: Colors.blue,
                      cardColor: cardColor,
                      primaryTextColor: primaryTextColor,
                      secondaryTextColor: secondaryTextColor,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: DashboardStatCard(
                      title: 'Assigned Tasks',
                      value: '18',
                      icon: Icons.assignment_turned_in_rounded,
                      color: Colors.green,
                      cardColor: cardColor,
                      primaryTextColor: primaryTextColor,
                      secondaryTextColor: secondaryTextColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: DashboardStatCard(
                      title: 'Completed',
                      value: '11',
                      icon: Icons.check_circle_rounded,
                      color: Colors.orange,
                      cardColor: cardColor,
                      primaryTextColor: primaryTextColor,
                      secondaryTextColor: secondaryTextColor,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: DashboardStatCard(
                      title: 'Pending Reports',
                      value: '5',
                      icon: Icons.warning_amber_rounded,
                      color: Colors.purple,
                      cardColor: cardColor,
                      primaryTextColor: primaryTextColor,
                      secondaryTextColor: secondaryTextColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),

              const SizedBox(height: 18),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: [
                  QuickActionCard(
                    icon: Icons.playlist_add_check_rounded,
                    title: 'Assign Tasks',
                    cardColor: cardColor,
                    textColor: primaryTextColor,
                  ),

                  QuickActionCard(
                    icon: Icons.schedule_rounded,
                    title: 'Timeline',
                    cardColor: cardColor,
                    textColor: primaryTextColor,
                  ),

                  QuickActionCard(
                    icon: Icons.report_problem_rounded,
                    title: 'Incidents',
                    cardColor: cardColor,
                    textColor: primaryTextColor,
                  ),

                  QuickActionCard(
                    icon: Icons.campaign_rounded,
                    title: 'Announcements',
                    cardColor: cardColor,
                    textColor: primaryTextColor,
                  ),
                ],
              ),

              const SizedBox(height: 32),

              Text(
                'Operational Activity',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),

              const SizedBox(height: 18),

              ActivityTile(
                title: 'Audio Team Ready',
                subtitle: 'Equipment setup completed',
                icon: Icons.graphic_eq_rounded,
                cardColor: cardColor,
                titleColor: primaryTextColor,
                subtitleColor: secondaryTextColor,
              ),

              const SizedBox(height: 14),

              ActivityTile(
                title: 'Crew Attendance Updated',
                subtitle: '20/24 crew checked in',
                icon: Icons.fact_check_rounded,
                cardColor: cardColor,
                titleColor: primaryTextColor,
                subtitleColor: secondaryTextColor,
              ),

              const SizedBox(height: 14),

              ActivityTile(
                title: 'New Incident Report',
                subtitle: 'Lighting system delay detected',
                icon: Icons.report_gmailerrorred_rounded,
                cardColor: cardColor,
                titleColor: primaryTextColor,
                subtitleColor: secondaryTextColor,
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
