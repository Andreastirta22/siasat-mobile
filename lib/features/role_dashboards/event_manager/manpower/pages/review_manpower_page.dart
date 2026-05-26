// lib/features/role_dashboards/event_manager/manpower/pages/review_manpower_page.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReviewManpowerPage extends StatefulWidget {
  final String eventId;

  const ReviewManpowerPage({super.key, required this.eventId});

  @override
  State<ReviewManpowerPage> createState() => _ReviewManpowerPageState();
}

class _ReviewManpowerPageState extends State<ReviewManpowerPage> {
  final supabase = Supabase.instance.client;

  bool isLoading = true;

  Map<String, dynamic>? event;

  List<Map<String, dynamic>> assignments = [];

  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future<void> loadData() async {
    try {
      setState(() => isLoading = true);

      /// EVENT
      final eventData = await supabase
          .from('events')
          .select()
          .eq('id', widget.eventId)
          .single();

      /// ASSIGNMENTS
      final assignmentData = await supabase
          .from('workforce_assignments')
          .select('''
            *,
            profiles (
              full_name,
              role,
              phone,
              employee_id
            )
          ''')
          .eq('event_id', widget.eventId);

      setState(() {
        event = eventData;
        assignments = List<Map<String, dynamic>>.from(assignmentData);

        isLoading = false;
      });
    } catch (e) {
      debugPrint('REVIEW MANPOWER ERROR: $e');

      setState(() => isLoading = false);
    }
  }

  Future<void> activateEvent() async {
    try {
      await supabase
          .from('events')
          .update({'status': 'active'})
          .eq('id', widget.eventId);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event activated successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      debugPrint('ACTIVATE EVENT ERROR: $e');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Widget buildAssignmentCard(Map<String, dynamic> assignment) {
    final profile = assignment['profiles'] ?? {};

    return Container(
      margin: const EdgeInsets.only(bottom: 14),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),

      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFF3B82F6),

            child: Text(
              (profile['full_name'] ?? 'U')
                  .toString()
                  .substring(0, 1)
                  .toUpperCase(),

              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  profile['full_name'] ?? 'Unknown Workforce',

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  profile['employee_id'] ?? '-',

                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),

                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 6),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),

                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),

                    borderRadius: BorderRadius.circular(30),
                  ),

                  child: Text(
                    (assignment['role'] ?? '-').toString().toUpperCase(),

                    style: const TextStyle(
                      color: Color(0xFF38BDF8),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final manpowerCount = assignments.length;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),

        elevation: 0,

        title: const Text(
          'Review Manpower',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                /// HEADER
                Container(
                  width: double.infinity,

                  margin: const EdgeInsets.all(20),

                  padding: const EdgeInsets.all(22),

                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),

                    borderRadius: BorderRadius.circular(24),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        event?['name'] ?? 'Unnamed Event',

                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        'Total Workforce Assigned: $manpowerCount',

                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),

                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 18),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),

                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),

                          borderRadius: BorderRadius.circular(16),
                        ),

                        child: Row(
                          children: const [
                            Icon(
                              Icons.verified_rounded,
                              color: Color(0xFF22C55E),
                            ),

                            SizedBox(width: 10),

                            Expanded(
                              child: Text(
                                'All manpower assignments have been reviewed and validated.',

                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                /// LIST
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),

                    itemCount: assignments.length,

                    itemBuilder: (context, index) {
                      return buildAssignmentCard(assignments[index]);
                    },
                  ),
                ),

                /// BUTTON
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),

                    child: SizedBox(
                      width: double.infinity,
                      height: 58,

                      child: ElevatedButton.icon(
                        onPressed: activateEvent,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF22C55E),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),

                        icon: const Icon(
                          Icons.rocket_launch,
                          color: Colors.white,
                        ),

                        label: const Text(
                          'Activate Event',

                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
