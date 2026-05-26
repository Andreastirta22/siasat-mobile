import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../events/widgets/event_creation_progression_bar.dart';

class AssignHeadcrewPage extends StatefulWidget {
  final Map<String, dynamic> eventDraft;

  const AssignHeadcrewPage({super.key, required this.eventDraft});

  @override
  State<AssignHeadcrewPage> createState() => _AssignHeadcrewPageState();
}

class _AssignHeadcrewPageState extends State<AssignHeadcrewPage> {
  bool isLoading = true;
  bool isAssigning = false;

  List<Map<String, dynamic>> headcrews = [];

  String? selectedHeadcrewId;

  @override
  void initState() {
    super.initState();

    loadHeadcrews();
  }

  Future<void> loadHeadcrews() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('role', 'headcrew')
          .eq('employment_status', 'active');

      setState(() {
        headcrews = List<Map<String, dynamic>>.from(response);

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> assignHeadcrew() async {
    if (selectedHeadcrewId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select headcrew')));

      return;
    }

    try {
      setState(() {
        isAssigning = true;
      });

      final currentUser = Supabase.instance.client.auth.currentUser;

      /// =========================
      /// CREATE EVENT
      /// =========================
      final createdEvent = await Supabase.instance.client
          .from('events')
          .insert({
            'name': widget.eventDraft['name'],

            'event_type': widget.eventDraft['event_type'],

            'start_date': widget.eventDraft['start_date'],

            'end_date': widget.eventDraft['end_date'],

            'status': 'headcrew_assigned',

            'progress_percentage': 0,

            /// GOVERNANCE
            'headcrew_id': selectedHeadcrewId,

            'event_manager_id': currentUser?.id,

            'created_by': currentUser?.id,

            'assigned_headcrew_at': DateTime.now().toIso8601String(),

            'assigned_headcrew_by': currentUser?.id,
          })
          .select()
          .single();

      final eventId = createdEvent['id'];

      /// =========================
      /// CREATE VENUE
      /// =========================
      await Supabase.instance.client.from('venues').insert({
        'event_id': eventId,

        'name': widget.eventDraft['venue_name'],

        'mall_name': widget.eventDraft['mall_name'],

        'address': widget.eventDraft['address'],

        'latitude': widget.eventDraft['latitude'],

        'longitude': widget.eventDraft['longitude'],

        'attendance_radius': widget.eventDraft['attendance_radius'],
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event created successfully')),
      );

      /// FLOW COMPLETED
      context.go('/event-manager');
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          isAssigning = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark
        ? const Color(0xFF050B1F)
        : Colors.grey.shade100;

    final cardColor = isDark ? const Color(0xFF18233A) : Colors.white;

    final textColor = isDark ? Colors.white : Colors.black87;

    final subtitleColor = isDark ? Colors.grey.shade400 : Colors.grey.shade700;

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,

        title: Text(
          'Assign Headcrew',

          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
      ),

      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : headcrews.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'No active headcrew available.\n\nComplete onboarding or activate headcrew account first.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: subtitleColor,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        /// PROGRESSION BAR
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),

                          child: Column(
                            children: [
                              const EventCreationProgressionBar(
                                currentStep: EventCreationStep.assignHeadcrew,
                              ),

                              const SizedBox(height: 8),

                              Text(
                                'Assign operational headcrew for this event.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: subtitleColor,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// HEADCREW LIST
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: loadHeadcrews,

                            child: ListView.builder(
                              padding: const EdgeInsets.all(24),

                              itemCount: headcrews.length,

                              itemBuilder: (context, index) {
                                final headcrew = headcrews[index];

                                final profileId = headcrew['id'].toString();

                                final fullName =
                                    headcrew['full_name'] ?? 'Unnamed Headcrew';

                                final employeeId =
                                    headcrew['employee_id'] ??
                                    'Employee ID not generated';

                                final phoneNumber =
                                    headcrew['phone'] ??
                                    'Phone number unavailable';

                                final isSelected =
                                    selectedHeadcrewId == profileId;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedHeadcrewId = profileId;
                                    });
                                  },

                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),

                                    margin: const EdgeInsets.only(bottom: 16),

                                    padding: const EdgeInsets.all(20),

                                    decoration: BoxDecoration(
                                      color: cardColor,

                                      borderRadius: BorderRadius.circular(24),

                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.blueAccent
                                            : Colors.transparent,

                                        width: 2,
                                      ),

                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.04),

                                          blurRadius: 10,

                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),

                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,

                                      children: [
                                        CircleAvatar(
                                          radius: 30,

                                          backgroundColor: Colors.blueAccent,

                                          child: Text(
                                            fullName
                                                .toString()
                                                .substring(0, 1)
                                                .toUpperCase(),

                                            style: const TextStyle(
                                              color: Colors.white,

                                              fontWeight: FontWeight.bold,

                                              fontSize: 22,
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 18),

                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,

                                            children: [
                                              Text(
                                                fullName,

                                                style: TextStyle(
                                                  color: textColor,

                                                  fontSize: 17,

                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),

                                              const SizedBox(height: 8),

                                              Text(
                                                employeeId,

                                                style: TextStyle(
                                                  color: subtitleColor,

                                                  fontSize: 14,
                                                ),
                                              ),

                                              const SizedBox(height: 4),

                                              Text(
                                                phoneNumber,

                                                style: TextStyle(
                                                  color: subtitleColor,

                                                  fontSize: 14,
                                                ),
                                              ),

                                              const SizedBox(height: 10),

                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,

                                                      vertical: 6,
                                                    ),

                                                decoration: BoxDecoration(
                                                  color: Colors.green
                                                      .withOpacity(0.15),

                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),

                                                child: const Text(
                                                  'ACTIVE',

                                                  style: TextStyle(
                                                    color: Colors.green,

                                                    fontWeight: FontWeight.bold,

                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        if (isSelected)
                                          const Padding(
                                            padding: EdgeInsets.only(top: 6),

                                            child: Icon(
                                              Icons.check_circle_rounded,

                                              color: Colors.blueAccent,

                                              size: 30,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// BUTTON
                  Padding(
                    padding: const EdgeInsets.all(24),

                    child: SizedBox(
                      width: double.infinity,
                      height: 58,

                      child: ElevatedButton(
                        onPressed: isAssigning || selectedHeadcrewId == null
                            ? null
                            : assignHeadcrew,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,

                          disabledBackgroundColor: Colors.grey.shade400,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),

                        child: isAssigning
                            ? const SizedBox(
                                width: 24,
                                height: 24,

                                child: CircularProgressIndicator(
                                  color: Colors.white,

                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                'Assign Headcrew',

                                style: TextStyle(
                                  fontSize: 16,

                                  fontWeight: FontWeight.bold,

                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
