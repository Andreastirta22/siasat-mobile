class HeadcrewEventModel {
  final String id;
  final String name;
  final String eventType;
  final String startDate;
  final String endDate;
  final String status;
  final int progressPercentage;

  final String? venueName;
  final String? venueAddress;

  final int? crewNeeded;
  final int? coachNeeded;
  final int? ringGuardNeeded;
  final int? medicNeeded;
  final int? cashierNeeded;

  HeadcrewEventModel({
    required this.id,
    required this.name,
    required this.eventType,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.progressPercentage,
    this.venueName,
    this.venueAddress,
    this.crewNeeded,
    this.coachNeeded,
    this.ringGuardNeeded,
    this.medicNeeded,
    this.cashierNeeded,
  });

  factory HeadcrewEventModel.fromMap(Map<String, dynamic> map) {
    final venue = map['venues'] is List && (map['venues'] as List).isNotEmpty
        ? map['venues'][0]
        : null;

    final manpower =
        map['event_manpower'] is List &&
            (map['event_manpower'] as List).isNotEmpty
        ? map['event_manpower'][0]
        : null;

    return HeadcrewEventModel(
      id: map['id'] ?? '',

      name: map['name'] ?? '',

      eventType: map['event_type'] ?? '',

      startDate: map['start_date'] ?? '',

      endDate: map['end_date'] ?? '',

      status: map['status'] ?? '',

      progressPercentage: map['progress_percentage'] ?? 0,

      venueName: venue?['name'],

      venueAddress: venue?['address'],

      crewNeeded: manpower?['crew_needed'],

      coachNeeded: manpower?['coach_needed'],

      ringGuardNeeded: manpower?['ring_guard_needed'],

      medicNeeded: manpower?['medic_needed'],

      cashierNeeded: manpower?['cashier_needed'],
    );
  }
}
