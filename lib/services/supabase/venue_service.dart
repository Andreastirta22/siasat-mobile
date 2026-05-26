import '../../models/venue_model.dart';
import 'supabase_service.dart';

class VenueService {
  final client = SupabaseService.client;

  Future<void> createVenue(VenueModel venue) async {
    await client.from('venues').insert(venue.toMap());
  }

  Future<List<VenueModel>> getVenues() async {
    final response = await client.from('venues').select();

    return response.map<VenueModel>((e) => VenueModel.fromMap(e)).toList();
  }
}
