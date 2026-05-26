class IdentityCheckResult {
  final String nationalId;

  final bool isEligible;

  final bool isBlacklisted;

  final bool employeeExists;

  final bool authExists;

  final String? employeeId;

  final String? fullName;

  final String? role;

  final String? employmentStatus;

  const IdentityCheckResult({
    required this.nationalId,
    required this.isEligible,
    required this.isBlacklisted,
    required this.employeeExists,
    required this.authExists,
    this.employeeId,
    this.fullName,
    this.role,
    this.employmentStatus,
  });
}
