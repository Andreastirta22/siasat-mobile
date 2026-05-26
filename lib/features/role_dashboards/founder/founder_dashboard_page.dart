import 'package:flutter/material.dart';

import '../../../../core/navigation/main_navigation_shell.dart';
import '../../../../core/navigation/navigation_config.dart';

import '../../profile/presentation/pages/profile_page.dart';

class FounderDashboardPage extends StatelessWidget {
  const FounderDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainNavigationShell(
      items: [
        NavigationItem(
          icon: Icons.dashboard_rounded,
          label: 'Dashboard',
          page: const _FounderHomePage(),
        ),
        NavigationItem(
          icon: Icons.groups_rounded,
          label: 'Teams',
          page: const _TeamsPage(),
        ),
        NavigationItem(
          icon: Icons.analytics_rounded,
          label: 'Analytics',
          page: const _AnalyticsPage(),
        ),
        NavigationItem(
          icon: Icons.person_rounded,
          label: 'Profile',
          page: const ProfilePage(),
        ),
      ],
    );
  }
}

class _FounderHomePage extends StatelessWidget {
  const _FounderHomePage();

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
                'Founder Dashboard',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Monitor system operations and manage organization growth.',
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
                      title: 'Total Events',
                      value: '128',
                      icon: Icons.event_available_rounded,
                      color: Colors.blue,
                      cardColor: cardColor,
                      primaryTextColor: primaryTextColor,
                      secondaryTextColor: secondaryTextColor,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: DashboardStatCard(
                      title: 'Active Crew',
                      value: '356',
                      icon: Icons.groups_2_rounded,
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
                      title: 'Event Managers',
                      value: '14',
                      icon: Icons.admin_panel_settings_rounded,
                      color: Colors.orange,
                      cardColor: cardColor,
                      primaryTextColor: primaryTextColor,
                      secondaryTextColor: secondaryTextColor,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: DashboardStatCard(
                      title: 'Pending Approvals',
                      value: '6',
                      icon: Icons.pending_actions_rounded,
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
                'Executive Actions',
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
                    icon: Icons.add_business_rounded,
                    title: 'Create Event',
                    cardColor: cardColor,
                    textColor: primaryTextColor,
                  ),

                  QuickActionCard(
                    icon: Icons.manage_accounts_rounded,
                    title: 'Manage Roles',
                    cardColor: cardColor,
                    textColor: primaryTextColor,
                  ),

                  QuickActionCard(
                    icon: Icons.fact_check_rounded,
                    title: 'Approvals',
                    cardColor: cardColor,
                    textColor: primaryTextColor,
                  ),

                  QuickActionCard(
                    icon: Icons.bar_chart_rounded,
                    title: 'Reports',
                    cardColor: cardColor,
                    textColor: primaryTextColor,
                  ),
                ],
              ),

              const SizedBox(height: 32),

              Text(
                'System Activities',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),

              const SizedBox(height: 18),

              ActivityTile(
                title: 'New Event Created',
                subtitle: 'Music Festival 2026',
                icon: Icons.event_note_rounded,
                cardColor: cardColor,
                titleColor: primaryTextColor,
                subtitleColor: secondaryTextColor,
              ),

              const SizedBox(height: 14),

              ActivityTile(
                title: 'Role Change Request',
                subtitle: 'Crew → Headcrew',
                icon: Icons.swap_horiz_rounded,
                cardColor: cardColor,
                titleColor: primaryTextColor,
                subtitleColor: secondaryTextColor,
              ),

              const SizedBox(height: 14),

              ActivityTile(
                title: 'System Update',
                subtitle: 'Dashboard analytics updated',
                icon: Icons.system_update_alt_rounded,
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

class _TeamsPage extends StatelessWidget {
  const _TeamsPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'TEAM MANAGEMENT',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _AnalyticsPage extends StatelessWidget {
  const _AnalyticsPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'ANALYTICS PAGE',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class DashboardStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color cardColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;

  const DashboardStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.cardColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 28),
          ),

          const Spacer(),

          Text(
            value,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: primaryTextColor,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            title,
            style: TextStyle(fontSize: 14, color: secondaryTextColor),
          ),
        ],
      ),
    );
  }
}

class QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color cardColor;
  final Color textColor;

  const QuickActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.cardColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 34, color: textColor),

          const SizedBox(height: 14),

          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class ActivityTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color cardColor;
  final Color titleColor;
  final Color subtitleColor;

  const ActivityTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.cardColor,
    required this.titleColor,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.blue),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: subtitleColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
