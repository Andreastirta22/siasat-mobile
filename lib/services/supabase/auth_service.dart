import 'package:supabase_flutter/supabase_flutter.dart';

import '../employee_id_service.dart';

import 'supabase_service.dart';

class AuthService {
  final SupabaseClient _client = SupabaseService.client;

  /// =========================================================
  /// CURRENT USER
  /// =========================================================

  User? get currentUser => _client.auth.currentUser;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  /// =========================================================
  /// MANAGEMENT AUTH SIGN UP ONLY
  /// =========================================================
  ///
  /// IMPORTANT:
  /// This auth flow is ONLY for:
  ///
  /// - founder
  /// - principal
  /// - finance_office
  /// - event_manager
  /// - headcrew
  ///
  /// Freelance workforce MUST NOT use auth.signUp().
  ///
  /// Workforce provisioning must use:
  /// - Edge Function
  /// - admin.createUser()
  /// - Workforce identity governance
  ///
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String role,
  }) async {
    /// =========================================================
    /// MANAGEMENT ROLE VALIDATION
    /// =========================================================

    const allowedRoles = [
      'founder',
      'principal',
      'finance_office',
      'event_manager',
      'headcrew',
    ];

    final bool isAllowedRole = allowedRoles.contains(role);

    if (!isAllowedRole) {
      throw Exception(
        'Freelance workforce creation must use workforce provisioning system.',
      );
    }

    /// =========================================================
    /// CREATE AUTH
    /// =========================================================

    final AuthResponse response = await _client.auth.signUp(
      email: email.trim(),
      password: password.trim(),
    );

    final user = response.user;

    /// =========================================================
    /// CREATE PROFILE
    /// =========================================================

    if (user != null) {
      /// TEMP STATIC SEQUENCE
      /// TODO:
      /// Replace with DB sequence service later
      const sequence = 1;

      final employeeId = EmployeeIdService.generateManagementEmployeeId(
        companyCode: 'AFCO',
        role: role,
        sequence: sequence,
      );

      await _client.from('profiles').insert({
        'id': user.id,
        'email': email.trim(),

        /// PROFILE
        'full_name': '',
        'photo_url': null,
        'phone': null,
        'birth_date': null,
        'address': null,

        /// ROLE
        'role': role,

        /// EMPLOYMENT
        'employee_id': employeeId,
        'employment_status': 'active',
        'is_active': true,

        /// SECURITY
        'password_changed_at': null,
        'last_login_at': DateTime.now().toIso8601String(),
        'must_change_password': false,

        /// TIMESTAMP
        'joined_at': DateTime.now().toIso8601String(),
      });
    }

    return response;
  }

  /// =========================================================
  /// SIGN IN
  /// =========================================================

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email.trim(),
      password: password.trim(),
    );

    final user = response.user;

    /// UPDATE LAST LOGIN
    if (user != null) {
      await _client
          .from('profiles')
          .update({'last_login_at': DateTime.now().toIso8601String()})
          .eq('id', user.id);
    }

    return response;
  }

  /// =========================================================
  /// GET CURRENT PROFILE
  /// =========================================================

  Future<Map<String, dynamic>> getCurrentProfile() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final response = await _client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (response == null) {
      throw Exception('Profile not found');
    }

    return Map<String, dynamic>.from(response);
  }

  /// =========================================================
  /// UPDATE PROFILE
  /// =========================================================

  Future<void> updateProfile({required Map<String, dynamic> data}) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    await _client.from('profiles').update(data).eq('id', user.id);
  }

  /// =========================================================
  /// CHANGE PASSWORD
  /// =========================================================

  Future<String?> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _client.auth.currentUser;

      if (user == null || user.email == null) {
        return 'User session not found';
      }

      /// SAME PASSWORD CHECK
      if (currentPassword == newPassword) {
        return 'New password must be different from current password';
      }

      /// GET PASSWORD CHANGE TIMESTAMP
      final profile = await _client
          .from('profiles')
          .select('password_changed_at')
          .eq('id', user.id)
          .single();

      final passwordChangedAt = profile['password_changed_at'];

      /// 48 HOURS COOLDOWN
      if (passwordChangedAt != null) {
        final changedAt = DateTime.parse(passwordChangedAt);

        final nextAllowed = changedAt.add(const Duration(hours: 48));

        final remaining = nextAllowed.difference(DateTime.now());

        if (!remaining.isNegative) {
          final hours = remaining.inHours;

          final minutes = remaining.inMinutes % 60;

          return 'You can change your password again in '
              '$hours hours $minutes minutes';
        }
      }

      /// UPDATE PASSWORD
      await _client.auth.updateUser(UserAttributes(password: newPassword));

      /// UPDATE SECURITY METADATA
      await _client
          .from('profiles')
          .update({
            'password_changed_at': DateTime.now().toUtc().toIso8601String(),
            'must_change_password': false,
          })
          .eq('id', user.id);

      return null;
    } on AuthException catch (e) {
      if (e.message.contains('Invalid login credentials')) {
        return 'Current password is incorrect';
      }

      return e.message;
    } catch (e) {
      return 'Failed to change password';
    }
  }

  /// =========================================================
  /// SIGN OUT
  /// =========================================================

  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
