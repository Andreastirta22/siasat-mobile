import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/headcrew_event_model.dart';
import '../services/headcrew_event_service.dart';

import '../widget/empty_events_state.dart';
import '../widget/event_card.dart';
import '../widget/event_filter_chips.dart';

class HeadcrewEventsPage extends StatefulWidget {
  const HeadcrewEventsPage({super.key});

  @override
  State<HeadcrewEventsPage> createState() => _HeadcrewEventsPageState();
}

class _HeadcrewEventsPageState extends State<HeadcrewEventsPage> {
  final SupabaseClient supabase = Supabase.instance.client;

  bool isLoading = true;

  String selectedStatus = 'all';

  List<HeadcrewEventModel> events = [];

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  Future<void> loadEvents() async {
    try {
      setState(() => isLoading = true);

      final currentUser = supabase.auth.currentUser;

      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final response = await HeadcrewEventService.loadEvents(
        headcrewId: currentUser.id,
        selectedStatus: selectedStatus,
      );

      if (!mounted) return;

      setState(() {
        events = response;
      });
    } catch (e) {
      debugPrint('Load Headcrew Events Error: $e');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      body: SafeArea(
        child: Column(
          children: [
            /// ─────────────────────────────
            /// HEADER
            /// ─────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),

              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,

                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFF6366F1)],
                      ),

                      borderRadius: BorderRadius.circular(14),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.25 : 0.08),

                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),

                    child: const Icon(
                      Icons.calendar_month_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        'Operational Events',

                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        '${events.length} event${events.length != 1 ? 's' : ''} found',

                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.6),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,

                      borderRadius: BorderRadius.circular(12),

                      border: Border.all(
                        color: colorScheme.outline.withOpacity(0.15),
                      ),
                    ),

                    child: IconButton(
                      onPressed: loadEvents,

                      icon: Icon(
                        Icons.refresh_rounded,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// ─────────────────────────────
            /// FILTER
            /// ─────────────────────────────
            EventFilterChips(
              selectedStatus: selectedStatus,

              onSelected: (status) {
                setState(() {
                  selectedStatus = status;
                });

                loadEvents();
              },
            ),

            const SizedBox(height: 16),

            /// ─────────────────────────────
            /// CONTENT
            /// ─────────────────────────────
            Expanded(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: colorScheme.primary,
                      ),
                    )
                  : events.isEmpty
                  ? EmptyEventsState(onRefresh: loadEvents)
                  : RefreshIndicator(
                      onRefresh: loadEvents,

                      color: colorScheme.primary,

                      backgroundColor: colorScheme.surface,

                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 4,
                        ),

                        physics: const AlwaysScrollableScrollPhysics(),

                        itemCount: events.length,

                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),

                            child: EventCard(event: events[index]),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
