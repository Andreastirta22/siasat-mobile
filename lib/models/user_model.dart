class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String role;

  final String? photoUrl;
  final String? phone;
  final String? nationalId;

  final String? ktpPhotoUrl;
  final String? employeeId;
  final String? address;

  /// BANK INFORMATION
  final String? bankName;
  final String? bankAccountNumber;
  final String? bankAccountHolder;

  final bool isActive;

  /// EMPLOYMENT STATUS
  final String? employmentStatus;

  final DateTime? birthDate;
  final DateTime? joinedAt;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,

    this.photoUrl,
    this.phone,
    this.nationalId,

    this.ktpPhotoUrl,
    this.employeeId,
    this.address,

    /// BANK INFORMATION
    this.bankName,
    this.bankAccountNumber,
    this.bankAccountHolder,

    required this.isActive,

    /// EMPLOYMENT STATUS
    this.employmentStatus,

    this.birthDate,
    this.joinedAt,
    this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',

      email: map['email'] ?? '',

      fullName: map['full_name'] ?? '',

      role: map['role'] ?? 'crew',

      photoUrl: map['photo_url'],

      phone: map['phone'],

      nationalId: map['national_id'],

      ktpPhotoUrl: map['ktp_photo_url'],

      employeeId: map['employee_id'],

      address: map['address'],

      /// BANK INFORMATION
      bankName: map['bank_name'],

      bankAccountNumber: map['bank_account_number'],

      bankAccountHolder: map['bank_account_holder'],

      isActive: map['is_active'] ?? true,

      /// EMPLOYMENT STATUS
      employmentStatus: map['employment_status'],

      birthDate: map['birth_date'] != null
          ? DateTime.parse(map['birth_date'])
          : null,

      joinedAt: map['joined_at'] != null
          ? DateTime.parse(map['joined_at'])
          : null,

      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,

      'email': email,

      'full_name': fullName,

      'role': role,

      'photo_url': photoUrl,

      'phone': phone,

      'national_id': nationalId,

      'ktp_photo_url': ktpPhotoUrl,

      'employee_id': employeeId,

      'address': address,

      /// BANK INFORMATION
      'bank_name': bankName,

      'bank_account_number': bankAccountNumber,

      'bank_account_holder': bankAccountHolder,

      'is_active': isActive,

      /// EMPLOYMENT STATUS
      'employment_status': employmentStatus,

      'birth_date': birthDate?.toIso8601String(),

      'joined_at': joinedAt?.toIso8601String(),

      'created_at': createdAt?.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? role,
    String? photoUrl,
    String? phone,
    String? nationalId,
    String? ktpPhotoUrl,
    String? employeeId,
    String? address,

    /// BANK INFORMATION
    String? bankName,
    String? bankAccountNumber,
    String? bankAccountHolder,

    bool? isActive,

    /// EMPLOYMENT STATUS
    String? employmentStatus,

    DateTime? birthDate,
    DateTime? joinedAt,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,

      email: email ?? this.email,

      fullName: fullName ?? this.fullName,

      role: role ?? this.role,

      photoUrl: photoUrl ?? this.photoUrl,

      phone: phone ?? this.phone,

      nationalId: nationalId ?? this.nationalId,

      ktpPhotoUrl: ktpPhotoUrl ?? this.ktpPhotoUrl,

      employeeId: employeeId ?? this.employeeId,

      address: address ?? this.address,

      /// BANK INFORMATION
      bankName: bankName ?? this.bankName,

      bankAccountNumber: bankAccountNumber ?? this.bankAccountNumber,

      bankAccountHolder: bankAccountHolder ?? this.bankAccountHolder,

      isActive: isActive ?? this.isActive,

      /// EMPLOYMENT STATUS
      employmentStatus: employmentStatus ?? this.employmentStatus,

      birthDate: birthDate ?? this.birthDate,

      joinedAt: joinedAt ?? this.joinedAt,

      createdAt: createdAt ?? this.createdAt,
    );
  }
}
