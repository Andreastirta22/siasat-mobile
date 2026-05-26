import 'package:flutter/material.dart';

class VerificationLoadingStep extends StatelessWidget {
  final String title;

  final bool isActive;

  final bool isCompleted;

  const VerificationLoadingStep({
    super.key,
    required this.title,
    required this.isActive,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon = Icons.radio_button_unchecked;

    Color color = Colors.grey;

    if (isCompleted) {
      icon = Icons.check_circle;
      color = Colors.green;
    } else if (isActive) {
      icon = Icons.sync;
      color = Colors.blue;
    }

    return Row(
      children: [
        Icon(icon, color: color),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
