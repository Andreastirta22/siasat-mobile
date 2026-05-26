import '../models/identity_check_result.dart';
import '../services/workforce_identity_service.dart';

class WorkforceIdentityController {
  final WorkforceIdentityService _service = WorkforceIdentityService();

  Future<IdentityCheckResult> verifyIdentity(String nik) async {
    return await _service.verifyNationalId(nik);
  }
}
