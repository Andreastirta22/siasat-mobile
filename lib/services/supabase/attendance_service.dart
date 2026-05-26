import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/attendance_model.dart';

class AttendanceService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// CHECK IN
  Future<void> checkIn({
    required double latitude,
    required double longitude,
    String? selfieUrl,
  }) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User not authenticated');
    }

    await _supabase.from('attendance').insert({
      'user_id': user.id,

      'check_in': DateTime.now().toIso8601String(),

      'latitude': latitude,
      'longitude': longitude,

      'selfie_url': selfieUrl,

      'status': 'present',
    });
  }

  /// CHECK OUT
  Future<void> checkOut(String attendanceId) async {
    await _supabase
        .from('attendance')
        .update({'check_out': DateTime.now().toIso8601String()})
        .eq('id', attendanceId);
  }

  /// GET TODAY ATTENDANCE
  Future<AttendanceModel?> getTodayAttendance() async {
    final user = _supabase.auth.currentUser;

    if (user == null) return null;

    final today = DateTime.now();

    final startOfDay = DateTime(today.year, today.month, today.day);

    final response = await _supabase
        .from('attendance')
        .select()
        .eq('user_id', user.id)
        .gte('created_at', startOfDay.toIso8601String())
        .maybeSingle();

    if (response == null) return null;

    return AttendanceModel.fromMap(response);
  }

  /// GET ATTENDANCE HISTORY
  Future<List<AttendanceModel>> getAttendanceHistory() async {
    final user = _supabase.auth.currentUser;

    if (user == null) return [];

    final response = await _supabase
        .from('attendance')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return (response as List)
        .map((attendance) => AttendanceModel.fromMap(attendance))
        .toList();
  }
}
