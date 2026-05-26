import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../widgets/crew_management_header.dart';
import '../../widgets/management_actions_section.dart';
import '../../widgets/manpower_stat_grid.dart';
import '../../widgets/operational_leaders_section.dart';

class CrewManagementPage extends StatefulWidget {
  const CrewManagementPage({super.key});

  @override
  State<CrewManagementPage> createState() => _CrewManagementPageState();
}

class _CrewManagementPageState extends State<CrewManagementPage> {
  final supabase = Supabase.instance.client;

  bool isLoading = true;

  /// =========================
  /// MANPOWER STATS
  /// =========================
  int totalCrew = 0;
  int totalHeadcrew = 0;
  int totalCoach = 0;
  int totalActiveWorkforce = 0;

  /// =========================
  /// OPERATIONAL LEADERS
  /// =========================
  List<Map<String, dynamic>> operationalLeaders = [];

  @override
  void initState() {
    super.initState();
    _loadCrewManagementData();
  }

  Future<void> _loadCrewManagementData() async {
    try {
      setState(() => isLoading = true);

      await Future.wait([_loadManpowerStats(), _loadOperationalLeaders()]);
    } catch (e) {
      debugPrint('CrewManagementPage Error: $e');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  /// =========================================================
  /// LOAD MANPOWER STATS
  /// =========================================================
  Future<void> _loadManpowerStats() async {
    final profiles = await supabase
        .from('profiles')
        .select('role, employment_status');

    totalCrew = profiles
        .where((e) => e['role'] == 'crew' && e['employment_status'] == 'active')
        .length;

    totalHeadcrew = profiles
        .where(
          (e) => e['role'] == 'headcrew' && e['employment_status'] == 'active',
        )
        .length;

    totalCoach = profiles
        .where(
          (e) => e['role'] == 'coach' && e['employment_status'] == 'active',
        )
        .length;

    totalActiveWorkforce = profiles
        .where((e) => e['employment_status'] == 'active')
        .length;
  }

  /// =========================================================
  /// LOAD OPERATIONAL LEADERS
  /// ONLY HEADCREW & EVENT MANAGER
  /// =========================================================
  Future<void> _loadOperationalLeaders() async {
    final response = await supabase
        .from('profiles')
        .select('''
        id,
        full_name,
        role,
        phone,
        employee_id,
        employment_status,
        photo_url
      ''')
        .eq('employment_status', 'active')
        .or('role.eq.headcrew,role.eq.event_manager')
        .order('created_at');

    debugPrint(response.toString());

    if (mounted) {
      setState(() {
        operationalLeaders = List<Map<String, dynamic>>.from(response);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark
        ? const Color(0xFF0F172A)
        : const Color(0xFFF5F7FA);

    return Scaffold(
      backgroundColor: backgroundColor,

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadCrewManagementData,

          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),

                  padding: const EdgeInsets.all(20),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      /// HEADER
                      const CrewManagementHeader(),

                      const SizedBox(height: 30),

                      /// WORKFORCE STATISTICS
                      ManpowerStatGrid(
                        totalCrew: totalCrew,
                        totalHeadcrew: totalHeadcrew,
                        totalCoach: totalCoach,
                        totalActiveWorkforce: totalActiveWorkforce,
                      ),

                      const SizedBox(height: 32),

                      /// MANAGEMENT ACTIONS
                      const ManagementActionsSection(),

                      const SizedBox(height: 32),

                      /// OPERATIONAL LEADERS
                      /// DATABASE CONNECTED
                      OperationalLeadersSection(leaders: operationalLeaders),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
