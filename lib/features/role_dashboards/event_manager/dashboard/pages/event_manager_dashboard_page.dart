/// =============================
/// FLUTTER PACKAGE IMPORTS
/// =============================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// =============================
/// CORE NAVIGATION
/// =============================
/// Main bottom navigation shell
/// + navigation item configuration

import '../../../../../../core/navigation/main_navigation_shell.dart';
import '../../../../../../core/navigation/navigation_config.dart';

/// =============================
/// PROFILE MODULE
/// =============================
/// Event Manager profile page

import '../../../../profile/presentation/pages/profile_page.dart';

/// =============================
/// DASHBOARD WIDGETS
/// =============================
/// Dashboard lifecycle status card

import 'package:siasat_mobile/features/role_dashboards/event_manager/dashboard/widgets/event_status_card.dart';

/// =============================
/// SHARED DASHBOARD WIDGETS
/// =============================
/// Reusable quick actions
/// + operational activity tiles

import '../../../widgets/quick_action_card.dart';
import '../../../widgets/activity_tile.dart';

/// =============================
/// CREW MANAGEMENT MODULE
/// =============================
/// Workforce & manpower management

import '../../crew_management/presentation/pages/crew_management_page.dart';

/// =============================
/// EVENTS MODULE
/// =============================
/// Operational event management page

import '../../events/pages/events_page.dart';

/// =============================
/// REPORTS MODULE
/// =============================
/// Operational analytics
/// attendance
/// payroll
/// performance reporting

import '../../../event_manager/reports/dashboard/pages/reports_dashboard_page.dart';

class EventManagerDashboardPage extends StatelessWidget {
  const EventManagerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainNavigationShell(
      items: [
        NavigationItem(
          icon: Icons.dashboard_rounded,
          label: 'Dashboard',
          page: const _EventManagerHomePage(),
        ),

        NavigationItem(
          icon: Icons.people_alt_rounded,
          label: 'Crew',
          page: const CrewManagementPage(),
        ),

        NavigationItem(
          icon: Icons.event_note_rounded,
          label: 'Events',
          page: const _EventManagementPage(),
        ),

        NavigationItem(
          icon: Icons.analytics_rounded,
          label: 'Reports',
          page: const ReportsDashboardPage(),
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

class _EventManagerHomePage extends StatefulWidget {
  const _EventManagerHomePage();

  @override
  State<_EventManagerHomePage> createState() => _EventManagerHomePageState();
}

class _EventManagerHomePageState extends State<_EventManagerHomePage> {
  bool isLoading = true;

  int planningEvents = 0;
  int venueSetupEvents = 0;
  int headcrewAssignedEvents = 0;
  int manpowerPlanningEvents = 0;
  int manpowerFillingEvents = 0;
  int readyActivationEvents = 0;
  int activeEvents = 0;
  int completedEvents = 0;
  int cancelledEvents = 0;

  @override
  void initState() {
    super.initState();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    try {
      final planningResponse = await Supabase.instance.client
          .from('events')
          .select('id')
          .eq('status', 'planning');

      final venueSetupResponse = await Supabase.instance.client
          .from('events')
          .select('id')
          .eq('status', 'venue_setup');

      final headcrewAssignedResponse = await Supabase.instance.client
          .from('events')
          .select('id')
          .eq('status', 'headcrew_assigned');

      final manpowerPlanningResponse = await Supabase.instance.client
          .from('events')
          .select('id')
          .eq('status', 'manpower_planning');

      final manpowerFillingResponse = await Supabase.instance.client
          .from('events')
          .select('id')
          .eq('status', 'manpower_filling');

      final readyActivationResponse = await Supabase.instance.client
          .from('events')
          .select('id')
          .eq('status', 'ready_for_activation');

      final activeResponse = await Supabase.instance.client
          .from('events')
          .select('id')
          .eq('status', 'active');

      final completedResponse = await Supabase.instance.client
          .from('events')
          .select('id')
          .eq('status', 'completed');

      final cancelledResponse = await Supabase.instance.client
          .from('events')
          .select('id')
          .eq('status', 'cancelled');

      if (!mounted) return;

      setState(() {
        planningEvents = planningResponse.length;

        venueSetupEvents = venueSetupResponse.length;

        headcrewAssignedEvents = headcrewAssignedResponse.length;

        manpowerPlanningEvents = manpowerPlanningResponse.length;

        manpowerFillingEvents = manpowerFillingResponse.length;

        readyActivationEvents = readyActivationResponse.length;

        activeEvents = activeResponse.length;

        completedEvents = completedResponse.length;

        cancelledEvents = cancelledResponse.length;

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed loading dashboard data: $e')),
      );
    }
  }

  Future<void> activateReadyEvents() async {
    try {
      final readyEvents = await Supabase.instance.client
          .from('events')
          .select()
          .eq('status', 'ready_for_activation');

      for (final event in readyEvents) {
        final hasVenue = event['venue_name'] != null;
        final hasHeadcrew = event['headcrew_id'] != null;

        if (hasVenue && hasHeadcrew) {
          await Supabase.instance.client
              .from('events')
              .update({'status': 'active'})
              .eq('id', event['id']);
        }
      }

      await loadDashboardData();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ready events successfully activated.')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to activate events: $e')));
    }
  }

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
        child: RefreshIndicator(
          onRefresh: loadDashboardData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Event Manager Dashboard',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Manage operational lifecycle, venue setup, manpower coordination, and event activation.',
                  style: TextStyle(
                    fontSize: 15,
                    color: isDark ? Colors.white70 : Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 30),

                Text(
                  'Operational Lifecycle',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),

                const SizedBox(height: 18),

                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 2.0,
                  children: [
                    EventStatusCard(
                      title: 'Planning',
                      value: planningEvents.toString(),
                      icon: Icons.edit_calendar_rounded,
                      color: Colors.orange,
                      cardColor: cardColor,
                      textColor: primaryTextColor,
                    ),

                    EventStatusCard(
                      title: 'Venue Setup',
                      value: venueSetupEvents.toString(),
                      icon: Icons.location_on_rounded,
                      color: Colors.blue,
                      cardColor: cardColor,
                      textColor: primaryTextColor,
                    ),

                    EventStatusCard(
                      title: 'Headcrew Assigned',
                      value: headcrewAssignedEvents.toString(),
                      icon: Icons.badge_rounded,
                      color: Colors.indigo,
                      cardColor: cardColor,
                      textColor: primaryTextColor,
                    ),

                    EventStatusCard(
                      title: 'Manpower Planning',
                      value: manpowerPlanningEvents.toString(),
                      icon: Icons.assignment_rounded,
                      color: Colors.deepPurple,
                      cardColor: cardColor,
                      textColor: primaryTextColor,
                    ),

                    EventStatusCard(
                      title: 'Manpower Filling',
                      value: manpowerFillingEvents.toString(),
                      icon: Icons.groups_2_rounded,
                      color: Colors.teal,
                      cardColor: cardColor,
                      textColor: primaryTextColor,
                    ),

                    EventStatusCard(
                      title: 'Ready Activation',
                      value: readyActivationEvents.toString(),
                      icon: Icons.verified_rounded,
                      color: Colors.cyan,
                      cardColor: cardColor,
                      textColor: primaryTextColor,
                    ),

                    EventStatusCard(
                      title: 'Active Events',
                      value: activeEvents.toString(),
                      icon: Icons.event_available_rounded,
                      color: Colors.green,
                      cardColor: cardColor,
                      textColor: primaryTextColor,
                    ),

                    EventStatusCard(
                      title: 'Completed',
                      value: completedEvents.toString(),
                      icon: Icons.task_alt_rounded,
                      color: Colors.grey,
                      cardColor: cardColor,
                      textColor: primaryTextColor,
                    ),

                    EventStatusCard(
                      title: 'Cancelled',
                      value: cancelledEvents.toString(),
                      icon: Icons.cancel_rounded,
                      color: Colors.red,
                      cardColor: cardColor,
                      textColor: primaryTextColor,
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                Text(
                  'Operational Workflow',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),

                const SizedBox(height: 18),

                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.25,
                  children: [
                    QuickActionCard(
                      icon: Icons.add_box_rounded,
                      title: 'Create Event',
                      cardColor: cardColor,
                      textColor: primaryTextColor,
                      onTap: () {
                        context.push('/event-manager/create-event');
                      },
                    ),

                    QuickActionCard(
                      icon: Icons.location_on_rounded,
                      title: 'Setup Venue',
                      cardColor: cardColor,
                      textColor: primaryTextColor,
                      onTap: () {
                        context.push('/event-manager/events');
                      },
                    ),

                    QuickActionCard(
                      icon: Icons.badge_rounded,
                      title: 'Assign Headcrew',
                      cardColor: cardColor,
                      textColor: primaryTextColor,
                      onTap: () {
                        context.push('/event-manager/events');
                      },
                    ),

                    QuickActionCard(
                      icon: Icons.groups_2_rounded,
                      title: 'Review Manpower',
                      cardColor: cardColor,
                      textColor: primaryTextColor,
                      onTap: () {
                        context.push('/event-manager/events');
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.rocket_launch_rounded,
                            color: isDark ? Colors.black : Colors.white,
                            size: 28,
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Text(
                              'Ready For Activation',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: primaryTextColor,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      Text(
                        '$readyActivationEvents operational event ready for activation.',
                        style: TextStyle(
                          fontSize: 15,
                          color: secondaryTextColor,
                        ),
                      ),

                      const SizedBox(height: 22),

                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: readyActivationEvents == 0
                              ? null
                              : activateReadyEvents,
                          icon: const Icon(Icons.check_circle),
                          label: const Text(
                            'Activate Events',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                Text(
                  'Recent Operations',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),

                const SizedBox(height: 18),

                ActivityTile(
                  title: 'Venue Setup Completed',
                  subtitle: 'Operational venue configuration finalized',
                  icon: Icons.location_on_rounded,
                  cardColor: cardColor,
                  titleColor: primaryTextColor,
                  subtitleColor: secondaryTextColor,
                ),

                const SizedBox(height: 14),

                ActivityTile(
                  title: 'Headcrew Assignment Completed',
                  subtitle: 'Operational PIC assigned successfully',
                  icon: Icons.badge_rounded,
                  cardColor: cardColor,
                  titleColor: primaryTextColor,
                  subtitleColor: secondaryTextColor,
                ),

                const SizedBox(height: 14),

                ActivityTile(
                  title: 'Manpower Fulfillment In Progress',
                  subtitle: 'Headcrew currently filling manpower composition',
                  icon: Icons.groups_rounded,
                  cardColor: cardColor,
                  titleColor: primaryTextColor,
                  subtitleColor: secondaryTextColor,
                ),

                const SizedBox(height: 14),

                ActivityTile(
                  title: 'Event Ready For Activation',
                  subtitle: 'All operational requirements completed',
                  icon: Icons.verified_rounded,
                  cardColor: cardColor,
                  titleColor: primaryTextColor,
                  subtitleColor: secondaryTextColor,
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EventManagementPage extends StatelessWidget {
  const _EventManagementPage();

  @override
  Widget build(BuildContext context) {
    return const EventsPage();
  }
}
