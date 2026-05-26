import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReportDetailService {
  final supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> fetchReportDetail(String reportId) async {
    try {
      final response = await supabase
          .from('daily_sales_reports')
          .select('''
            *,
            events (
              id,
              name,
              event_type
            ),
            venues (
              id,
              name,
              address
            ),
            profiles!daily_sales_reports_headcrew_id_fkey (
              full_name
            )
          ''')
          .eq('id', reportId)
          .single();

      return response;
    } catch (e) {
      debugPrint('ERROR REPORT DETAIL: $e');
      return null;
    }
  }
}
