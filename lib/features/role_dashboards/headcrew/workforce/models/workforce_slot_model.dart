// models/workforce_slot_model.dart

class WorkforceSlotModel {
  final String id;

  final String manpowerRequirementId;

  final int slotNumber;

  final bool isFilled;

  final String? workforceId;
  final String? workforceName;

  const WorkforceSlotModel({
    required this.id,
    required this.manpowerRequirementId,
    required this.slotNumber,
    required this.isFilled,
    this.workforceId,
    this.workforceName,
  });

  factory WorkforceSlotModel.fromMap(Map<String, dynamic> map) {
    return WorkforceSlotModel(
      id: map['id'],
      manpowerRequirementId: map['manpower_requirement_id'],
      slotNumber: map['slot_number'],
      isFilled: map['is_filled'] ?? false,
      workforceId: map['workforce_id'],
      workforceName: map['workforce_name'],
    );
  }
}
