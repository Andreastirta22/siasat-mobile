import 'package:flutter/material.dart';

import '../../../../../core/navigation/main_navigation_shell.dart';
import '../../../../../core/navigation/navigation_config.dart';

import '../../../../profile/presentation/pages/profile_page.dart';

import '../../events/pages/headcrew_events_page.dart';
import '../../manpower/pages/manpower_management_page.dart';
import '../../reports/pages/headcrew_reports_page.dart';

import 'headcrew_home_page.dart';

class HeadcrewDashboardPage extends StatelessWidget {
  const HeadcrewDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainNavigationShell(
      items: [
        NavigationItem(
          icon: Icons.dashboard_rounded,
          label: 'Dashboard',
          page: const HeadcrewHomePage(),
        ),

        NavigationItem(
          icon: Icons.groups_rounded,
          label: 'Manpower',
          page: const ManpowerManagementPage(),
        ),

        NavigationItem(
          icon: Icons.assignment_rounded,
          label: 'Events',
          page: const HeadcrewEventsPage(),
        ),
        NavigationItem(
          icon: Icons.assessment_rounded,
          label: 'Reports',
          page: const HeadcrewReportsPage(),
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
