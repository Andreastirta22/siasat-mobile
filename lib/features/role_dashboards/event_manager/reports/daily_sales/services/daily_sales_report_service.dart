// daily_sales/services/daily_sales_report_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';

class DailySalesReportService {
  static final supabase = Supabase.instance.client;

  static Future<void> createReport({
    required int ticketQty,
    required int insuranceQty,
    required double ticketPrice,
    required double insurancePrice,
    required double grossSales,
  }) async {
    await supabase.from('daily_sales_reports').insert({
      'ticket_qty': ticketQty,
      'insurance_qty': insuranceQty,

      'ticket_price': ticketPrice,
      'insurance_price': insurancePrice,

      'gross_sales': grossSales,

      'created_at': DateTime.now().toIso8601String(),
    });
  }
}
