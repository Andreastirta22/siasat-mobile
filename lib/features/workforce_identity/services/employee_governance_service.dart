class EmployeeGovernanceService {
  /// ROLE CREATION GOVERNANCE
  bool canCreateRole({
    required String creatorRole,
    required String targetRole,
  }) {
    /// EVENT MANAGER
    if (creatorRole == 'event_manager') {
      return ['crew', 'coach', 'headcrew'].contains(targetRole);
    }

    /// HEADCREW
    if (creatorRole == 'headcrew') {
      return targetRole == 'crew';
    }

    return false;
  }

  /// MANPOWER ASSIGNMENT GOVERNANCE
  bool canAssignRole({
    required String assignerRole,
    required String targetRole,
  }) {
    /// EVENT MANAGER
    if (assignerRole == 'event_manager') {
      return ['crew', 'coach', 'headcrew'].contains(targetRole);
    }

    /// HEADCREW
    if (assignerRole == 'headcrew') {
      return targetRole == 'crew';
    }

    return false;
  }

  /// AVAILABLE ROLES FOR UI
  List<String> getAvailableRoles(String currentRole) {
    if (currentRole == 'event_manager') {
      return ['crew', 'coach', 'headcrew'];
    }

    if (currentRole == 'headcrew') {
      return ['crew'];
    }

    return [];
  }
}
