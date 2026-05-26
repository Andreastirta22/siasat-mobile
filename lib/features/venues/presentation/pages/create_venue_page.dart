import 'package:flutter/material.dart';

import '../../../../models/event_model.dart';
import '../../../../models/venue_model.dart';
import '../../../../services/event_service.dart';
import '../../../../services/supabase/venue_service.dart';

class CreateVenuePage extends StatefulWidget {
  const CreateVenuePage({super.key});

  @override
  State<CreateVenuePage> createState() => _CreateVenuePageState();
}

class _CreateVenuePageState extends State<CreateVenuePage> {
  final VenueService _venueService = VenueService();
  final EventService _eventService = EventService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  List<EventModel> events = [];

  EventModel? selectedEvent;

  bool isLoading = false;
  bool isLoadingEvents = true;

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  Future<void> loadEvents() async {
    try {
      final data = await _eventService.getEvents();

      setState(() {
        events = data;
        isLoadingEvents = false;
      });
    } catch (e) {
      setState(() {
        isLoadingEvents = false;
      });
    }
  }

  Future<void> createVenue() async {
    if (selectedEvent == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select event')));
      return;
    }

    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Venue name is required')));
      return;
    }

    if (addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Address is required')));
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      final venue = VenueModel(
        id: '',
        eventId: selectedEvent!.id,
        name: nameController.text.trim(),
        address: addressController.text.trim(),
        attendanceRadius: 100,
        isActive: true,
      );

      await _venueService.createVenue(venue);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Venue created successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) {
      return '-';
    }

    return '${date.day}/${date.month}/${date.year}';
  }

  Widget buildEventInfo(EventModel event) {
    return Container(
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  '${formatDate(event.startDate)} - ${formatDate(event.endDate)}',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),

            decoration: BoxDecoration(
              color: event.status == 'active' ? Colors.green : Colors.orange,

              borderRadius: BorderRadius.circular(20),
            ),

            child: Text(
              event.status.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Venue')),

      body: isLoadingEvents
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// EVENT DROPDOWN
                  DropdownButtonFormField<EventModel>(
                    value: selectedEvent,

                    isExpanded: true,

                    decoration: const InputDecoration(
                      labelText: 'Select Event',
                      border: OutlineInputBorder(),
                    ),

                    items: events.map((event) {
                      return DropdownMenuItem<EventModel>(
                        value: event,

                        child: Text(
                          event.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),

                    onChanged: (value) {
                      setState(() {
                        selectedEvent = value;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  /// SELECTED EVENT DETAIL
                  if (selectedEvent != null) buildEventInfo(selectedEvent!),

                  const SizedBox(height: 24),

                  /// VENUE NAME
                  TextField(
                    controller: nameController,

                    decoration: const InputDecoration(
                      labelText: 'Venue Name',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// ADDRESS
                  TextField(
                    controller: addressController,
                    maxLines: 3,

                    decoration: const InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// CREATE BUTTON
                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton(
                      onPressed: isLoading ? null : createVenue,

                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),

                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,

                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Create Venue'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
