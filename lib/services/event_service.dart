import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/event_model.dart';
import 'supabase/supabase_service.dart';

class EventService {
  final SupabaseClient _client = SupabaseService.client;

  Future<void> createEvent(EventModel event) async {
    await _client.from('events').insert(event.toMap());
  }

  Future<List<EventModel>> getEvents() async {
    final response = await _client
        .from('events')
        .select()
        .order('created_at', ascending: false);

    return response
        .map<EventModel>((event) => EventModel.fromMap(event))
        .toList();
  }
}
