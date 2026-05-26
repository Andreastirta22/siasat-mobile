class EmployeeIdService {
  /// =========================================================
  /// MANAGEMENT EMPLOYEE ID
  /// =========================================================
  ///
  /// Used for:
  /// - founder
  /// - principal
  /// - finance_office
  /// - event_manager
  /// - headcrew
  ///
  /// Example:
  /// AFCO-EM-0001
  ///
  static String generateManagementEmployeeId({
    required String companyCode,
    required String role,
    required int sequence,
  }) {
    final roleCode = _getManagementRoleCode(role);

    final formattedSequence = sequence.toString().padLeft(4, '0');

    return '$companyCode-$roleCode-$formattedSequence';
  }

  /// =========================================================
  /// FREELANCE WORKFORCE ID
  /// =========================================================
  ///
  /// Used for:
  /// - crew
  /// - coach
  /// - medic
  /// - cashier
  /// - ring_guard
  ///
  /// Example:
  /// AF-CR-4821-0001
  ///
  static String generateFreelanceWorkforceId({
    required String role,
    required String nationalId,
    required int sequence,
  }) {
    final roleCode = _getFreelanceRoleCode(role);

    /// LAST 4 DIGIT NIK
    final nikLast4 = nationalId.substring(nationalId.length - 4);

    final formattedSequence = sequence.toString().padLeft(4, '0');

    return 'AF-$roleCode-$nikLast4-$formattedSequence';
  }

  /// =========================================================
  /// MANAGEMENT ROLE CODE
  /// =========================================================

  static String _getManagementRoleCode(String role) {
    switch (role) {
      case 'founder':
        return 'FOU';

      case 'principal':
        return 'PRI';

      case 'finance_office':
        return 'FIN';

      case 'event_manager':
        return 'EM';

      case 'headcrew':
        return 'HC';

      default:
        return 'UNK';
    }
  }

  /// =========================================================
  /// FREELANCE ROLE CODE
  /// =========================================================

  static String _getFreelanceRoleCode(String role) {
    switch (role) {
      case 'crew':
        return 'CR';

      case 'coach':
        return 'CO';

      case 'medic':
        return 'MD';

      case 'cashier':
        return 'CS';

      case 'ring_guard':
        return 'RG';

      default:
        return 'UNK';
    }
  }
}
