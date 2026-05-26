// models/workforce_assignment_model.dart

class WorkforceAssignmentModel {
  final String id;

  final String manpowerRequirementId;

  final String workforceId;
  final String workforceName;

  final String assignedRole;

  final String assignmentStatus;

  const WorkforceAssignmentModel({
    required this.id,
    required this.manpowerRequirementId,
    required this.workforceId,
    required this.workforceName,
    required this.assignedRole,
    required this.assignmentStatus,
  });

  factory WorkforceAssignmentModel.fromMap(Map<String, dynamic> map) {
    final workforce = map['workforce'] as Map<String, dynamic>?;

    return WorkforceAssignmentModel(
      id: map['id'] ?? '',
      manpowerRequirementId: map['manpower_requirement_id'] ?? '',

      workforceId: map['workforce_id'] ?? '',

      workforceName: workforce?['full_name'] ?? '',

      assignedRole: map['assigned_role'] ?? '',

      assignmentStatus: map['assignment_status'] ?? 'assigned',
    );
  }
}
