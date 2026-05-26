class PricingConfigModel {
  final String id;

  final double ticketPrice;
  final double insurancePrice;
  final double coachPrice;
  final double glovePrice;
  final double socksPrice;

  const PricingConfigModel({
    required this.id,

    required this.ticketPrice,
    required this.insurancePrice,
    required this.coachPrice,
    required this.glovePrice,
    required this.socksPrice,
  });

  factory PricingConfigModel.fromMap(Map<String, dynamic> map) {
    return PricingConfigModel(
      id: map['id'],

      ticketPrice: (map['ticket_price'] ?? 0).toDouble(),

      insurancePrice: (map['insurance_price'] ?? 0).toDouble(),

      coachPrice: (map['coach_price'] ?? 0).toDouble(),

      glovePrice: (map['glove_price'] ?? 0).toDouble(),

      socksPrice: (map['socks_price'] ?? 0).toDouble(),
    );
  }
}
