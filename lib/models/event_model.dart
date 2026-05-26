class EventModel {
  final String id;
  final String name;
  final String eventType;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final DateTime createdAt;

  EventModel({
    required this.id,
    required this.name,
    required this.eventType,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.createdAt,
  });

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'],
      name: map['name'],
      eventType: map['event_type'],
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),
      status: map['status'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'event_type': eventType,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'status': status,
    };
  }
}
