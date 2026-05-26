import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatCurrency(dynamic value) {
  final number = (value ?? 0).toDouble();

  return NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  ).format(number);
}

Color getStatusColor(String status) {
  switch (status) {
    case 'approved':
      return Colors.green;

    case 'reviewed':
      return Colors.blue;

    case 'submitted':
      return Colors.orange;

    case 'rejected':
      return Colors.red;

    case 'draft':
      return Colors.grey;

    default:
      return Colors.grey;
  }
}

String formatReportDate(dynamic value) {
  if (value == null) return '-';

  try {
    final date = DateTime.parse(value.toString());

    return DateFormat('dd MMM yyyy').format(date);
  } catch (e) {
    return value.toString();
  }
}
