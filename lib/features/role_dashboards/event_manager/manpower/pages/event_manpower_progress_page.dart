// features/role_dashboards/event_manager/manpower/pages/event_manpower_progress_page.dart

import 'package:flutter/material.dart';

import '../services/manpower_progress_service.dart';

import '../widgets/manpower_progress_card.dart';

class EventManpowerProgressPage extends StatefulWidget {
  final String eventId;
  final String eventName;

  const EventManpowerProgressPage({
    super.key,
    required this.eventId,
    required this.eventName,
  });

  @override
  State<EventManpowerProgressPage> createState() =>
      _EventManpowerProgressPageState();
}

class _EventManpowerProgressPageState extends State<EventManpowerProgressPage> {
  bool isLoading = true;

  List<ManpowerProgressItem> progressItems = [];

  @override
  void initState() {
    super.initState();

    loadProgress();
  }

  Future<void> loadProgress() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await ManpowerProgressService.getEventManpowerProgress(
        widget.eventId,
      );

      if (!mounted) return;

      setState(() {
        progressItems = response;
      });

      await ManpowerProgressService.autoUpdateEventStatus(widget.eventId);
    } catch (e) {
      debugPrint(e.toString());
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalRequired = progressItems.fold<int>(
      0,
      (sum, item) => sum + item.requiredCount,
    );

    final totalAssigned = progressItems.fold<int>(
      0,
      (sum, item) => sum + item.assignedCount,
    );

    final overallProgress = totalRequired == 0
        ? 0.0
        : totalAssigned / totalRequired;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      appBar: AppBar(elevation: 0, title: const Text('Manpower Progress')),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadProgress,

              child: ListView(
                padding: const EdgeInsets.all(20),

                children: [
                  Container(
                    padding: const EdgeInsets.all(24),

                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),

                      borderRadius: BorderRadius.circular(28),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          widget.eventName,

                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          'Operational manpower fulfillment progress',

                          style: TextStyle(color: Colors.white70),
                        ),

                        const SizedBox(height: 24),

                        Text(
                          '$totalAssigned / $totalRequired Workforce',

                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 18),

                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),

                          child: LinearProgressIndicator(
                            value: overallProgress,

                            minHeight: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  ...progressItems.map(
                    (item) => ManpowerProgressCard(
                      role: item.role,

                      assignedCount: item.assignedCount,

                      requiredCount: item.requiredCount,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
