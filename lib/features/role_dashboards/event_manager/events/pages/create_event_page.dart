import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../events/widgets/event_creation_progression_bar.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController eventNameController = TextEditingController();

  DateTimeRange? selectedDateRange;

  bool isLoading = false;

  String selectedEventType = 'operational_event';

  /// AUTO GOVERNANCE STATUS
  final String selectedStatus = 'planning';

  final List<String> eventTypes = [
    'operational_event',
    'playground',
    'ice_skating',
  ];

  /// EVENT TYPE FORMATTER
  String formatEventType(String type) {
    switch (type) {
      case 'operational_event':
        return 'Operational Event';

      case 'playground':
        return 'Playground';

      case 'ice_skating':
        return 'Ice Skating';

      default:
        return type;
    }
  }

  Future<void> pickDateRange() async {
    final pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
      initialDateRange: selectedDateRange,

      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDark
                ? const ColorScheme.dark(primary: Colors.blueAccent)
                : const ColorScheme.light(primary: Colors.blueAccent),
          ),

          child: child!,
        );
      },
    );

    if (pickedRange != null) {
      setState(() {
        selectedDateRange = pickedRange;
      });
    }
  }

  Future<void> createEvent() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedDateRange == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select event duration')),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      /// TEMPORARY EVENT DRAFT
      final eventDraft = {
        'name': eventNameController.text.trim(),

        'event_type': selectedEventType,

        'start_date': selectedDateRange!.start.toIso8601String(),

        'end_date': selectedDateRange!.end.toIso8601String(),

        'status': selectedStatus,

        'progress_percentage': 0,
      };

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Event information saved')));

      /// CONTINUE TO VENUE SETUP
      context.push('/event-manager/setup-venue', extra: eventDraft);
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
    eventNameController.dispose();

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

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,

        title: Text(
          'Create Event',
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
                currentStep: EventCreationStep.createEvent,
              ),

              const SizedBox(height: 8),

              Text(
                'Create new operational event.',
                style: TextStyle(color: subtitleColor, fontSize: 15),
              ),

              const SizedBox(height: 32),

              /// EVENT NAME
              Text(
                'Event Name',
                style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: eventNameController,
                style: TextStyle(color: textColor),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Event name is required';
                  }

                  return null;
                },

                decoration: InputDecoration(
                  hintText: 'Enter event name',

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
                ),
              ),

              const SizedBox(height: 24),

              /// EVENT TYPE
              Text(
                'Event Type',
                style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),

                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(18),
                ),

                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedEventType,
                    isExpanded: true,

                    dropdownColor: cardColor,

                    style: TextStyle(color: textColor),

                    items: eventTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(formatEventType(type)),
                      );
                    }).toList(),

                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedEventType = value;
                        });
                      }
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// EVENT DATE RANGE
              Text(
                'Event Duration',
                style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 10),

              GestureDetector(
                onTap: pickDateRange,

                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 18,
                  ),

                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(18),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Expanded(
                        child: Text(
                          selectedDateRange == null
                              ? 'Select event duration'
                              : '${selectedDateRange!.start.day}/${selectedDateRange!.start.month}/${selectedDateRange!.start.year} - '
                                    '${selectedDateRange!.end.day}/${selectedDateRange!.end.month}/${selectedDateRange!.end.year}',

                          style: TextStyle(
                            color: selectedDateRange == null
                                ? subtitleColor
                                : textColor,
                          ),
                        ),
                      ),

                      Icon(
                        Icons.date_range_rounded,
                        size: 20,
                        color: subtitleColor,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// STATUS
              Text(
                'Status',
                style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 18,
                ),

                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(18),
                ),

                child: Text(
                  'Planning',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              /// CREATE BUTTON
              SizedBox(
                height: 58,

                child: ElevatedButton(
                  onPressed: isLoading ? null : createEvent,

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
                          'Create Event',
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
