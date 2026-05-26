import 'package:intl/intl.dart';

class ReportDetailFormatter {
  static String formatCurrency(dynamic value) {
    final amount = (value ?? 0).toDouble();

    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }
}
