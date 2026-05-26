// models/manpower_requirement_model.dart

class ManpowerRequirementModel {
  final String role;

  final int needed;
  final int assigned;

  const ManpowerRequirementModel({
    required this.role,
    required this.needed,
    required this.assigned,
  });

  /// REMAINING MANPOWER
  int get remaining => needed - assigned;

  /// PROGRESS PERCENTAGE
  double get progressPercentage {
    if (needed == 0) return 0;

    return assigned / needed;
  }

  /// FACTORY FROM MAP
  factory ManpowerRequirementModel.fromMap(Map<String, dynamic> map) {
    return ManpowerRequirementModel(
      role: map['role'] ?? '',
      needed: map['needed'] ?? 0,
      assigned: map['assigned'] ?? 0,
    );
  }

  /// TO MAP
  Map<String, dynamic> toMap() {
    return {'role': role, 'needed': needed, 'assigned': assigned};
  }

  /// COPY WITH
  ManpowerRequirementModel copyWith({
    String? role,
    int? needed,
    int? assigned,
  }) {
    return ManpowerRequirementModel(
      role: role ?? this.role,
      needed: needed ?? this.needed,
      assigned: assigned ?? this.assigned,
    );
  }

  @override
  String toString() {
    return '''
ManpowerRequirementModel(
  role: $role,
  needed: $needed,
  assigned: $assigned,
)
''';
  }
}
