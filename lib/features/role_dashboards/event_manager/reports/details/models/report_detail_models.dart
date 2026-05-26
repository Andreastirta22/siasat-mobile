// details/models/report_detail_model.dart

class ReportDetailModel {
  final String id;

  final String eventName;
  final String venueName;

  final DateTime reportDate;

  final int ticketQty;
  final int insuranceQty;
  final int coachQty;

  final double ticketSales;
  final double insuranceSales;
  final double coachSales;

  final double grossSales;

  final String notes;

  final String status;

  ReportDetailModel({
    required this.id,
    required this.eventName,
    required this.venueName,
    required this.reportDate,
    required this.ticketQty,
    required this.insuranceQty,
    required this.coachQty,
    required this.ticketSales,
    required this.insuranceSales,
    required this.coachSales,
    required this.grossSales,
    required this.notes,
    required this.status,
  });
}
