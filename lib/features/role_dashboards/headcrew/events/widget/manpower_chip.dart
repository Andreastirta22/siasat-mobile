import 'package:flutter/material.dart';

import '../constants/event_ui_constants.dart';

class ManpowerChip extends StatelessWidget {
  final String label;
  final dynamic value;

  const ManpowerChip({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: EventUiConstants.bgChip,
        borderRadius: BorderRadius.circular(EventUiConstants.chipRadius),
        border: Border.all(color: EventUiConstants.accent.withOpacity(0.15)),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label ',
              style: const TextStyle(
                color: EventUiConstants.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: '$value',
              style: const TextStyle(
                color: EventUiConstants.accent,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
