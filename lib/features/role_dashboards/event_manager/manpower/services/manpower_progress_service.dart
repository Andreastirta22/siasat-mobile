// features/role_dashboards/event_manager/manpower/services/manpower_progress_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';

class ManpowerProgressItem {
  final String role;
  final int requiredCount;
  final int assignedCount;

  const ManpowerProgressItem({
    required this.role,
    required this.requiredCount,
    required this.assignedCount,
  });

  double get progress {
    if (requiredCount == 0) return 0;
    return assignedCount / requiredCount;
  }

  bool get isFulfilled => assignedCount >= requiredCount;
}

class ManpowerProgressService {
  static final _supabase = Supabase.instance.client;

  static Future<List<ManpowerProgressItem>> getEventManpowerProgress(
    String eventId,
  ) async {
    final manpowerResponse = await _supabase
        .from('event_manpower')
        .select()
        .eq('event_id', eventId);

    final assignmentsResponse = await _supabase
        .from('workforce_assignments')
        .select()
        .eq('event_id', eventId);

    final assignments = List<Map<String, dynamic>>.from(assignmentsResponse);

    final List<ManpowerProgressItem> progressItems = [];

    for (final manpower in manpowerResponse) {
      final role = manpower['role'];

      final requiredCount = manpower['required_count'] ?? 0;

      final assignedCount = assignments.where((assignment) {
        return assignment['role'] == role;
      }).length;

      progressItems.add(
        ManpowerProgressItem(
          role: role,
          requiredCount: requiredCount,
          assignedCount: assignedCount,
        ),
      );
    }

    return progressItems;
  }

  static Future<void> autoUpdateEventStatus(String eventId) async {
    final progress = await getEventManpowerProgress(eventId);

    if (progress.isEmpty) return;

    final isReady = progress.every((item) => item.isFulfilled);

    if (!isReady) return;

    await _supabase
        .from('events')
        .update({'status': 'ready_for_activation'})
        .eq('id', eventId)
        .eq('status', 'manpower_filling');
  }
}
