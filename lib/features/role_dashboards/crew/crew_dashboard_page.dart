import '../../profile/presentation/pages/profile_page.dart';

import 'package:flutter/material.dart';

import '../../../../core/navigation/main_navigation_shell.dart';
import '../../../../core/navigation/navigation_config.dart';

class CrewDashboardPage extends StatelessWidget {
  const CrewDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainNavigationShell(
      items: [
        NavigationItem(
          icon: Icons.dashboard_rounded,
          label: 'Dashboard',
          page: const _CrewHomePage(),
        ),
        NavigationItem(
          icon: Icons.assignment_rounded,
          label: 'Tasks',
          page: const _CrewTasksPage(),
        ),
        NavigationItem(
          icon: Icons.event_rounded,
          label: 'Events',
          page: const _CrewEventsPage(),
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

class _CrewHomePage extends StatelessWidget {
  const _CrewHomePage();

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
                'Crew Dashboard',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Track assignments, schedules, and ongoing events.',
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
                      title: 'Assigned Tasks',
                      value: '12',
                      icon: Icons.assignment_turned_in_rounded,
                      color: Colors.blue,
                      cardColor: cardColor,
                      primaryTextColor: primaryTextColor,
                      secondaryTextColor: secondaryTextColor,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: DashboardStatCard(
                      title: 'Upcoming Events',
                      value: '4',
                      icon: Icons.event_available_rounded,
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
                      value: '28',
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
                      title: 'Notifications',
                      value: '7',
                      icon: Icons.notifications_active_rounded,
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
                    icon: Icons.qr_code_scanner_rounded,
                    title: 'Attendance',
                    cardColor: cardColor,
                    textColor: primaryTextColor,
                  ),

                  QuickActionCard(
                    icon: Icons.schedule_rounded,
                    title: 'My Schedule',
                    cardColor: cardColor,
                    textColor: primaryTextColor,
                  ),

                  QuickActionCard(
                    icon: Icons.support_agent_rounded,
                    title: 'Support',
                    cardColor: cardColor,
                    textColor: primaryTextColor,
                  ),

                  QuickActionCard(
                    icon: Icons.message_rounded,
                    title: 'Messages',
                    cardColor: cardColor,
                    textColor: primaryTextColor,
                  ),
                ],
              ),

              const SizedBox(height: 32),

              Text(
                'Today Activity',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),

              const SizedBox(height: 18),

              ActivityTile(
                title: 'Stage Setup Assigned',
                subtitle: 'Main Stage - 08:00 AM',
                icon: Icons.construction_rounded,
                cardColor: cardColor,
                titleColor: primaryTextColor,
                subtitleColor: secondaryTextColor,
              ),

              const SizedBox(height: 14),

              ActivityTile(
                title: 'Briefing Reminder',
                subtitle: 'Crew Meeting - 10:00 AM',
                icon: Icons.groups_rounded,
                cardColor: cardColor,
                titleColor: primaryTextColor,
                subtitleColor: secondaryTextColor,
              ),

              const SizedBox(height: 14),

              ActivityTile(
                title: 'Equipment Check',
                subtitle: 'Audio Division',
                icon: Icons.headphones_rounded,
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

class _CrewTasksPage extends StatelessWidget {
  const _CrewTasksPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'CREW TASKS PAGE',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _CrewEventsPage extends StatelessWidget {
  const _CrewEventsPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'CREW EVENTS PAGE',
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
