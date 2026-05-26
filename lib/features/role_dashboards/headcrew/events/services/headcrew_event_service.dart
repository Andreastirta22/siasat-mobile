import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/headcrew_event_model.dart';

class HeadcrewEventService {
  static final SupabaseClient supabase = Supabase.instance.client;

  static Future<List<HeadcrewEventModel>> loadEvents({
    required String headcrewId,
    required String selectedStatus,
  }) async {
    var query = supabase
        .from('events')
        .select('''
          id,
          name,
          event_type,
          start_date,
          end_date,
          status,
          progress_percentage,
          created_at,
          headcrew_id,

          venues!venues_event_id_fkey (
            id,
            name,
            address
          ),

          event_manpower (
            id,
            crew_needed,
            coach_needed,
            ring_guard_needed,
            medic_needed,
            cashier_needed
          )
        ''')
        .eq('headcrew_id', headcrewId)
        .inFilter('status', [
          'manpower_filling',
          'ready_for_activation',
          'active',
          'completed',
        ]);

    if (selectedStatus != 'all') {
      query = query.eq('status', selectedStatus);
    }

    final response = await query.order('created_at', ascending: false);

    return (response as List)
        .map((event) => HeadcrewEventModel.fromMap(event))
        .toList();
  }
}
