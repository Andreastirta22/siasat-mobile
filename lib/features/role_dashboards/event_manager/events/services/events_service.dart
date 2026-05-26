import 'package:supabase_flutter/supabase_flutter.dart';

class EventsService {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> loadEvents(String selectedFilter) async {
    List<String> statuses = [];

    switch (selectedFilter) {
      case 'operational':
        statuses = ['venue_setup', 'manpower_planning', 'manpower_filling'];
        break;

      case 'ready':
        statuses = ['ready_for_activation'];
        break;

      case 'active':
        statuses = ['active'];
        break;

      case 'history':
        statuses = ['completed', 'cancelled'];
        break;
    }

    final response = await supabase
        .from('events')
        .select('''
          *,
          venues!venues_event_id_fkey (
            id,
            name,
            address
          ),
          headcrew:profiles!events_headcrew_id_fkey(
            id,
            full_name,
            employee_id
          )
        ''')
        .inFilter('status', statuses)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> activateEvent(String eventId) async {
    await supabase
        .from('events')
        .update({'status': 'active'})
        .eq('id', eventId);
  }
}
