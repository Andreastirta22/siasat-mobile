// services/workforce_assignment_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';

class WorkforceAssignmentService {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getAvailableWorkforce(
    String roleRequired,
  ) async {
    final response = await supabase
        .from('profiles')
        .select()
        .eq('role', roleRequired)
        .eq('employment_status', 'active');

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> assignWorkforce({
    required String manpowerRequirementId,
    required String workforceId,
    required String workforceName,
    required String assignedRole,
  }) async {
    await supabase.from('workforce_assignments').insert({
      'manpower_requirement_id': manpowerRequirementId,
      'workforce_id': workforceId,
      'workforce_name': workforceName,
      'assigned_role': assignedRole,
      'assignment_status': 'assigned',
    });

    await supabase.rpc(
      'increment_assigned_count',
      params: {'requirement_id': manpowerRequirementId},
    );
  }
}
