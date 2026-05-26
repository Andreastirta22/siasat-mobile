// services/manpower_filling_service.dart

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/manpower_requirement_model.dart';

class ManpowerFillingService {
  final supabase = Supabase.instance.client;

  Future<List<ManpowerRequirementModel>> getEventManpowerRequirements(
    String eventId,
  ) async {
    debugPrint('==============================');
    debugPrint('MANPOWER FILLING DEBUG');
    debugPrint('EVENT ID FROM PAGE: $eventId');

    /// GET EVENT MANPOWER
    final response = await supabase
        .from('event_manpower')
        .select()
        .eq('event_id', eventId)
        .single();

    debugPrint('EVENT MANPOWER RESPONSE:');
    debugPrint(response.toString());

    /// GET ALL ASSIGNMENTS
    final assignments = await supabase
        .from('workforce_assignments')
        .select()
        .eq('event_id', eventId);

    debugPrint('ASSIGNMENTS RESULT:');
    debugPrint(assignments.toString());

    /// HELPER COUNT
    int countAssignments(String role) {
      final count = assignments.where((item) {
        final dbRole = item['role'].toString().trim().toLowerCase();

        final compareRole = role.toLowerCase();

        debugPrint('COMPARE ROLE => DB: $dbRole | TARGET: $compareRole');

        return dbRole == compareRole;
      }).length;

      debugPrint('FINAL COUNT FOR ROLE [$role] => $count');

      return count;
    }

    final List<ManpowerRequirementModel> requirements = [];

    /// CREW
    if ((response['crew_needed'] ?? 0) > 0) {
      requirements.add(
        ManpowerRequirementModel(
          role: 'Crew',
          needed: response['crew_needed'] ?? 0,
          assigned: countAssignments('crew'),
        ),
      );
    }

    /// COACH
    if ((response['coach_needed'] ?? 0) > 0) {
      requirements.add(
        ManpowerRequirementModel(
          role: 'Coach',
          needed: response['coach_needed'] ?? 0,
          assigned: countAssignments('coach'),
        ),
      );
    }

    /// RING GUARD
    if ((response['ring_guard_needed'] ?? 0) > 0) {
      requirements.add(
        ManpowerRequirementModel(
          role: 'Ring Guard',
          needed: response['ring_guard_needed'] ?? 0,
          assigned: countAssignments('ring_guard'),
        ),
      );
    }

    /// CREW TOP UP
    if ((response['crew_top_up_needed'] ?? 0) > 0) {
      requirements.add(
        ManpowerRequirementModel(
          role: 'Crew Top Up',
          needed: response['crew_top_up_needed'] ?? 0,
          assigned: countAssignments('crew_top_up'),
        ),
      );
    }

    /// MEDIC
    if ((response['medic_needed'] ?? 0) > 0) {
      requirements.add(
        ManpowerRequirementModel(
          role: 'Medic',
          needed: response['medic_needed'] ?? 0,
          assigned: countAssignments('medic'),
        ),
      );
    }

    /// CASHIER
    if ((response['cashier_needed'] ?? 0) > 0) {
      requirements.add(
        ManpowerRequirementModel(
          role: 'Cashier',
          needed: response['cashier_needed'] ?? 0,
          assigned: countAssignments('cashier'),
        ),
      );
    }

    debugPrint('FINAL REQUIREMENTS RESULT:');
    debugPrint(requirements.toString());

    debugPrint('==============================');

    return requirements;
  }

  int getTotalRequired(List<ManpowerRequirementModel> requirements) {
    return requirements.fold(0, (sum, item) => sum + item.needed);
  }

  int getTotalAssigned(List<ManpowerRequirementModel> requirements) {
    return requirements.fold(0, (sum, item) => sum + item.assigned);
  }

  double getOverallProgress(List<ManpowerRequirementModel> requirements) {
    final totalRequired = getTotalRequired(requirements);

    final totalAssigned = getTotalAssigned(requirements);

    if (totalRequired == 0) return 0;

    return totalAssigned / totalRequired;
  }
}
