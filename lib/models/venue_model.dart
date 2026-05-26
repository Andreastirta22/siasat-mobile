class VenueModel {
  final String id;
  final String eventId;
  final String name;
  final String address;
  final double? latitude;
  final double? longitude;
  final int attendanceRadius;
  final bool isActive;
  final DateTime? createdAt;

  VenueModel({
    required this.id,
    required this.eventId,
    required this.name,
    required this.address,
    this.latitude,
    this.longitude,
    required this.attendanceRadius,
    required this.isActive,
    this.createdAt,
  });

  factory VenueModel.fromMap(Map<String, dynamic> map) {
    return VenueModel(
      id: map['id'],
      eventId: map['event_id'],
      name: map['name'],
      address: map['address'] ?? '',
      latitude: map['latitude'],
      longitude: map['longitude'],
      attendanceRadius: map['attendance_radius'] ?? 100,
      isActive: map['is_active'] ?? true,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'event_id': eventId,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'attendance_radius': attendanceRadius,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
