import 'package:flutter/material.dart';

import '../constants/event_ui_constants.dart';

class EventMetaRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const EventMetaRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const SizedBox(width: 2),
          Icon(icon, size: 15, color: EventUiConstants.textDarkMuted),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: EventUiConstants.textMuted,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
