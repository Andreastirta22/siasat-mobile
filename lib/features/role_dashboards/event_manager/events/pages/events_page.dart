import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/events_service.dart';
import '../widgets/event_card.dart';
import '../widgets/event_empty_state.dart';
import '../widgets/event_filter_bar.dart';
import '../widgets/event_header.dart';
import '../widgets/event_loading_state.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final service = EventsService();

  bool isLoading = true;

  String selectedFilter = 'operational';

  List<Map<String, dynamic>> events = [];

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  Future<void> loadEvents() async {
    setState(() => isLoading = true);

    final data = await service.loadEvents(selectedFilter);

    setState(() {
      events = data;
      isLoading = false;
    });
  }

  Future<void> handleAction(Map<String, dynamic> event) async {
    final status = event['status'];

    final eventId = event['id'];

    switch (status) {
      case 'venue_setup':
        context.push('/event-manager/setup-venue', extra: eventId);
        break;

      case 'manpower_planning':
        context.push('/event-manager/setup-manpower', extra: eventId);
        break;

      case 'ready_for_activation':
        await service.activateEvent(eventId);
        loadEvents();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/event-manager/create-event');
        },
        label: const Text('Create Event'),
        icon: const Icon(Icons.add),
      ),

      body: SafeArea(
        child: Column(
          children: [
            EventHeader(isDark: isDark, totalEvents: events.length),

            EventFilterBar(
              isDark: isDark,
              selectedFilter: selectedFilter,
              onChanged: (value) {
                setState(() => selectedFilter = value);
                loadEvents();
              },
            ),

            Expanded(
              child: isLoading
                  ? const EventLoadingState()
                  : events.isEmpty
                  ? EventEmptyState(isDark: isDark)
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        return EventCard(
                          event: events[index],
                          isDark: isDark,
                          onAction: handleAction,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
