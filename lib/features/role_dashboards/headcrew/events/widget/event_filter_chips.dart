import 'package:flutter/material.dart';

import '../constants/event_ui_constants.dart';

class EventFilterChips extends StatelessWidget {
  final String selectedStatus;
  final Function(String status) onSelected;

  const EventFilterChips({
    super.key,
    required this.selectedStatus,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final statuses = [
      {'key': 'all', 'label': 'All'},
      {'key': 'manpower_filling', 'label': 'Manpower Filling'},
      {'key': 'active', 'label': 'Active'},
      {'key': 'completed', 'label': 'Completed'},
    ];

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: EventUiConstants.screenPadding,
        ),
        itemCount: statuses.length,
        itemBuilder: (context, index) {
          final item = statuses[index];

          final isSelected = selectedStatus == item['key'];

          return GestureDetector(
            onTap: () {
              onSelected(item['key']!);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? EventUiConstants.accent
                    : Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                item['label']!,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : EventUiConstants.textSecondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
