import '../../models/user_model.dart';

import 'supabase_service.dart';

class ProfileService {
  /// GET CURRENT LOGGED-IN USER PROFILE
  Future<UserModel?> getCurrentProfile() async {
    try {
      final user = SupabaseService.client.auth.currentUser;

      if (user == null) return null;

      final response = await SupabaseService.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      return UserModel.fromMap(response);
    } catch (e) {
      print('Get Current Profile Error: $e');
      return null;
    }
  }

  /// UPDATE PROFILE
  Future<void> updateProfile(UserModel user) async {
    try {
      await SupabaseService.client
          .from('profiles')
          .update({
            'full_name': user.fullName,

            'photo_url': user.photoUrl,

            'phone': user.phone,

            'national_id': user.nationalId,

            'ktp_photo_url': user.ktpPhotoUrl,

            'employee_id': user.employeeId,

            'address': user.address,

            'birth_date': user.birthDate?.toIso8601String(),

            'joined_at': user.joinedAt?.toIso8601String(),

            'is_active': user.isActive,

            /// EMPLOYMENT STATUS
            'employment_status': user.employmentStatus,

            /// BANK INFORMATION
            'bank_name': user.bankName,

            'bank_account_number': user.bankAccountNumber,

            'bank_account_holder': user.bankAccountHolder,
          })
          .eq('id', user.id);
    } catch (e) {
      print('Update Profile Error: $e');
    }
  }

  /// CHECK PROFILE EXISTS
  Future<bool> profileExists(String userId) async {
    try {
      final response = await SupabaseService.client
          .from('profiles')
          .select('id')
          .eq('id', userId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      print('Check Profile Exists Error: $e');
      return false;
    }
  }

  /// CREATE PROFILE
  Future<void> createProfile({
    required String id,
    required String email,
    required String fullName,
    String role = 'crew',
  }) async {
    try {
      await SupabaseService.client.from('profiles').insert({
        'id': id,
        'email': email,
        'full_name': fullName,
        'role': role,
      });
    } catch (e) {
      print('Create Profile Error: $e');
    }
  }
}
