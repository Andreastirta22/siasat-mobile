// daily_sales/models/daily_sales_report_model.dart

class DailySalesReportModel {
  final String id;

  final String eventId;
  final String venueId;
  final String headcrewId;

  final DateTime reportDate;

  final int ticketQty;
  final int insuranceQty;
  final int skatingAideQty;
  final int coachQty;
  final int gloveQty;
  final int socksQty;

  final double grossSales;

  final String status;

  DailySalesReportModel({
    required this.id,
    required this.eventId,
    required this.venueId,
    required this.headcrewId,
    required this.reportDate,
    required this.ticketQty,
    required this.insuranceQty,
    required this.skatingAideQty,
    required this.coachQty,
    required this.gloveQty,
    required this.socksQty,
    required this.grossSales,
    required this.status,
  });

  factory DailySalesReportModel.fromJson(Map<String, dynamic> json) {
    return DailySalesReportModel(
      id: json['id'],
      eventId: json['event_id'],
      venueId: json['venue_id'],
      headcrewId: json['headcrew_id'],
      reportDate: DateTime.parse(json['report_date']),
      ticketQty: json['ticket_qty'] ?? 0,
      insuranceQty: json['insurance_qty'] ?? 0,
      skatingAideQty: json['skating_aide_qty'] ?? 0,
      coachQty: json['coach_qty'] ?? 0,
      gloveQty: json['glove_qty'] ?? 0,
      socksQty: json['socks_qty'] ?? 0,
      grossSales: (json['gross_sales'] ?? 0).toDouble(),
      status: json['status'] ?? 'draft',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event_id': eventId,
      'venue_id': venueId,
      'headcrew_id': headcrewId,
      'report_date': reportDate.toIso8601String(),
      'ticket_qty': ticketQty,
      'insurance_qty': insuranceQty,
      'skating_aide_qty': skatingAideQty,
      'coach_qty': coachQty,
      'glove_qty': gloveQty,
      'socks_qty': socksQty,
      'gross_sales': grossSales,
      'status': status,
    };
  }
}
