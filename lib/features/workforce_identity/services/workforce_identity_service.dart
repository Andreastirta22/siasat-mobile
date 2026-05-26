import '../models/identity_check_result.dart';

import '../../../services/supabase/supabase_service.dart';

class WorkforceIdentityService {
  Future<IdentityCheckResult> verifyNationalId(String nik) async {
    await Future.delayed(const Duration(seconds: 1));

    print('INPUT NIK: $nik');

    final response = await SupabaseService.client
        .from('profiles')
        .select()
        .eq('national_id', nik)
        .maybeSingle();

    print('DATABASE RESPONSE: $response');

    /// EMPLOYEE EXISTS
    if (response != null) {
      final employmentStatus = response['employment_status'];

      /// BLACKLISTED
      if (employmentStatus == 'blacklisted') {
        return IdentityCheckResult(
          nationalId: nik,
          isEligible: false,
          isBlacklisted: true,
          employeeExists: false,
          authExists: false,
        );
      }

      /// EXISTING ACTIVE EMPLOYEE
      if (employmentStatus == 'active') {
        return IdentityCheckResult(
          nationalId: nik,
          isEligible: false,
          isBlacklisted: false,
          employeeExists: true,
          authExists: true,
          employeeId: response['employee_id'],
          fullName: response['full_name'],
          role: response['role'],
          employmentStatus: employmentStatus,
        );
      }

      /// REHIRE FLOW
      if (employmentStatus == 'resigned') {
        return IdentityCheckResult(
          nationalId: nik,
          isEligible: false,
          isBlacklisted: false,
          employeeExists: true,
          authExists: true,
          employeeId: response['employee_id'],
          fullName: response['full_name'],
          role: response['role'],
          employmentStatus: employmentStatus,
        );
      }
    }

    /// NEW EMPLOYEE
    return IdentityCheckResult(
      nationalId: nik,
      isEligible: true,
      isBlacklisted: false,
      employeeExists: false,
      authExists: false,
    );
  }
}
