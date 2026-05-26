import 'package:supabase_flutter/supabase_flutter.dart';

class ReportsService {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchDailySalesReports() async {
    final response = await supabase
        .from('daily_sales_reports')
        .select('''
        *,
        events(
          name,
          event_type
        ),
        profiles!daily_sales_reports_headcrew_id_fkey(
          full_name
        )
      ''')
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> fetchPettyCashReports() async {
    final response = await supabase
        .from('petty_cash_reports')
        .select('''
          *,
          events(name),
          venues(name),
          profiles!petty_cash_reports_headcrew_id_fkey(full_name)
        ''')
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }
}
