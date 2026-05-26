import 'package:supabase_flutter/supabase_flutter.dart';

class PricingService {
  static final supabase = Supabase.instance.client;

  static Future<Map<String, dynamic>?> getActivePricing({
    required String eventId,
    required String venueId,
  }) async {
    final response = await supabase
        .from('pricing_configs')
        .select()
        .eq('event_id', eventId)
        .eq('venue_id', venueId)
        .eq('active', true)
        .maybeSingle();

    return response;
  }

  static Future<void> createPricingConfig({
    required String eventId,
    required String venueId,

    required double ticketPrice,
    required double insurancePrice,
    required double coachPrice,
    required double glovePrice,
    required double socksPrice,
  }) async {
    /// deactivate old pricing
    await supabase
        .from('pricing_configs')
        .update({'active': false})
        .eq('event_id', eventId)
        .eq('venue_id', venueId)
        .eq('active', true);

    /// create new pricing
    await supabase.from('pricing_configs').insert({
      'event_id': eventId,
      'venue_id': venueId,

      'ticket_price': ticketPrice,
      'insurance_price': insurancePrice,
      'coach_price': coachPrice,
      'glove_price': glovePrice,
      'socks_price': socksPrice,

      'active': true,
    });
  }
}
