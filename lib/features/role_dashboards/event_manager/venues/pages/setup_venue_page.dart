import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../events/widgets/event_creation_progression_bar.dart';

class SetupVenuePage extends StatefulWidget {
  final Map<String, dynamic> eventDraft;

  const SetupVenuePage({super.key, required this.eventDraft});

  @override
  State<SetupVenuePage> createState() => _SetupVenuePageState();
}

class _SetupVenuePageState extends State<SetupVenuePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController venueNameController = TextEditingController();

  final TextEditingController mallNameController = TextEditingController();

  final TextEditingController addressController = TextEditingController();

  final TextEditingController attendanceRadiusController =
      TextEditingController(text: '100');

  bool isLoading = false;

  /// LOCATION DATA
  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();

    final eventType = widget.eventDraft['event_type'];

    venueNameController.text = formatVenueName(eventType);
  }

  /// AUTO FORMAT VENUE NAME
  String formatVenueName(String eventType) {
    switch (eventType) {
      case 'operational_event':
        return 'Operational Event ${DateTime.now().year}';

      case 'playground':
        return 'Playground ${DateTime.now().year}';

      case 'ice_skating':
        return 'Ice Skating ${DateTime.now().year}';

      default:
        return '${DateTime.now().year}';
    }
  }

  /// TEMPORARY LOCATION PICKER
  Future<void> pickLocation() async {
    final result = await context.push('/pick-venue-location');

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        latitude = result['latitude'];
        longitude = result['longitude'];
      });

      addressController.text = result['address'] ?? '';

      mallNameController.text = result['name'] ?? '';
    }
  }

  Future<void> continueToAssignHeadcrew() async {
    if (!_formKey.currentState!.validate()) return;

    if (latitude == null || longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select venue location')),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      /// MERGE EVENT + VENUE DRAFT
      final updatedDraft = {
        ...widget.eventDraft,

        'venue_name': venueNameController.text.trim(),

        'mall_name': mallNameController.text.trim(),

        'address': addressController.text.trim(),

        'latitude': latitude,

        'longitude': longitude,

        'attendance_radius': int.parse(attendanceRadiusController.text.trim()),
      };

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Venue setup completed')));

      /// CONTINUE TO ASSIGN HEADCREW
      context.push('/event-manager/assign-headcrew', extra: updatedDraft);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    venueNameController.dispose();
    mallNameController.dispose();
    addressController.dispose();
    attendanceRadiusController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark
        ? const Color(0xFF050B1F)
        : Colors.grey.shade100;

    final cardColor = isDark ? const Color(0xFF18233A) : Colors.white;

    final textColor = isDark ? Colors.white : Colors.black87;

    final subtitleColor = isDark ? Colors.grey.shade400 : Colors.grey.shade700;

    InputDecoration inputDecoration(String hint) {
      return InputDecoration(
        hintText: hint,

        hintStyle: TextStyle(color: subtitleColor),

        filled: true,
        fillColor: cardColor,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,

        title: Text(
          'Setup Venue',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
      ),

      body: SafeArea(
        child: Form(
          key: _formKey,

          child: ListView(
            padding: const EdgeInsets.all(24),

            children: [
              /// PROGRESSION BAR
              const EventCreationProgressionBar(
                currentStep: EventCreationStep.setupVenue,
              ),

              const SizedBox(height: 8),

              Text(
                'Setup operational venue for this event.',
                style: TextStyle(color: subtitleColor, fontSize: 15),
              ),

              const SizedBox(height: 32),

              /// VENUE NAME
              Text(
                'Venue Name',
                style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: venueNameController,
                style: TextStyle(color: textColor),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Venue name is required';
                  }

                  return null;
                },

                decoration: inputDecoration('Example: Ice Skating 2026'),
              ),

              const SizedBox(height: 24),

              /// MALL NAME
              Text(
                'Mall Name',
                style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: mallNameController,
                style: TextStyle(color: textColor),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mall name is required';
                  }

                  return null;
                },

                decoration: inputDecoration('Example: Pondok Indah Mall 2'),
              ),

              const SizedBox(height: 24),

              /// ADDRESS
              Text(
                'Address',
                style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: addressController,
                style: TextStyle(color: textColor),
                maxLines: 3,

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Address is required';
                  }

                  return null;
                },

                decoration: inputDecoration('Enter venue address'),
              ),

              const SizedBox(height: 24),

              /// LOCATION PICKER
              Text(
                'Venue Location',
                style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 10),

              GestureDetector(
                onTap: pickLocation,

                child: Container(
                  padding: const EdgeInsets.all(18),

                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(18),
                  ),

                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        color: latitude != null
                            ? Colors.green
                            : Colors.blueAccent,
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Text(
                          latitude == null
                              ? 'Tap to select location'
                              : 'Location selected successfully',

                          style: TextStyle(
                            color: latitude == null ? subtitleColor : textColor,

                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// ATTENDANCE RADIUS
              Text(
                'Attendance Radius (meters)',
                style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: attendanceRadiusController,
                style: TextStyle(color: textColor),
                keyboardType: TextInputType.number,

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Attendance radius is required';
                  }

                  return null;
                },

                decoration: inputDecoration('Example: 100'),
              ),

              const SizedBox(height: 40),

              /// CONTINUE BUTTON
              SizedBox(
                height: 58,

                child: ElevatedButton(
                  onPressed: isLoading ? null : continueToAssignHeadcrew,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),

                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,

                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
