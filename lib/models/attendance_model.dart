class AttendanceModel {
  final String id;
  final String userId;

  final DateTime? checkIn;
  final DateTime? checkOut;

  final double? latitude;
  final double? longitude;

  final String? selfieUrl;

  final String status;

  final DateTime createdAt;

  AttendanceModel({
    required this.id,
    required this.userId,
    this.checkIn,
    this.checkOut,
    this.latitude,
    this.longitude,
    this.selfieUrl,
    required this.status,
    required this.createdAt,
  });

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      id: map['id'],
      userId: map['user_id'],

      checkIn: map['check_in'] != null ? DateTime.parse(map['check_in']) : null,

      checkOut: map['check_out'] != null
          ? DateTime.parse(map['check_out'])
          : null,

      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),

      selfieUrl: map['selfie_url'],

      status: map['status'] ?? 'present',

      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,

      'check_in': checkIn?.toIso8601String(),
      'check_out': checkOut?.toIso8601String(),

      'latitude': latitude,
      'longitude': longitude,

      'selfie_url': selfieUrl,

      'status': status,

      'created_at': createdAt.toIso8601String(),
    };
  }
}
