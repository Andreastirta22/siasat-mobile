import 'package:flutter/material.dart';

import '../main_navigation_shell.dart';
import '../navigation_config.dart';

import '../../../features/profile/presentation/pages/profile_page.dart';

import '../../../features/role_dashboards/founder/founder_dashboard_page.dart';

class FounderNavigationPage extends StatelessWidget {
  const FounderNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainNavigationShell(
      items: [
        NavigationItem(
          label: 'Dashboard',
          icon: Icons.dashboard_rounded,
          page: const FounderDashboardPage(),
        ),

        NavigationItem(
          label: 'Analytics',
          icon: Icons.analytics_rounded,
          page: const Scaffold(),
        ),

        NavigationItem(
          label: 'Finance',
          icon: Icons.payments_rounded,
          page: const Scaffold(),
        ),

        NavigationItem(
          label: 'Crew',
          icon: Icons.groups_rounded,
          page: const Scaffold(),
        ),

        NavigationItem(
          label: 'Profile',
          icon: Icons.person_rounded,
          page: const ProfilePage(),
        ),
      ],
    );
  }
}
