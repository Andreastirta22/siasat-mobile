import 'package:flutter/material.dart';

class CrewManagementHeader extends StatelessWidget {
  const CrewManagementHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final titleColor = isDark ? Colors.white : Colors.black;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          'Crew Management',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: titleColor,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'Manage workforce, operational manpower, and employee provisioning.',
          style: TextStyle(
            fontSize: 15,
            color: isDark ? Colors.white70 : Colors.grey.shade700,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
