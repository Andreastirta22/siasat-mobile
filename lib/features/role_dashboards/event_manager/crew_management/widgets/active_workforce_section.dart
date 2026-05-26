import 'package:flutter/material.dart';

import 'employee_card.dart';

class ActiveWorkforceSection extends StatelessWidget {
  const ActiveWorkforceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final titleColor = isDark ? Colors.white : Colors.black;

    final cardColor = isDark ? Colors.white : const Color(0xFF111827);

    final primaryTextColor = isDark ? Colors.black : Colors.white;

    final secondaryTextColor = isDark ? Colors.black54 : Colors.white70;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          'Active Workforce',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: titleColor,
          ),
        ),

        const SizedBox(height: 18),

        EmployeeCard(
          name: 'Michael Jordan',
          role: 'Headcrew',
          employeeId: 'AFCO-MTA01-HC-0001',
          status: 'ACTIVE',
          statusColor: Colors.green,
          cardColor: cardColor,
          titleColor: primaryTextColor,
          subtitleColor: secondaryTextColor,
        ),

        const SizedBox(height: 14),

        EmployeeCard(
          name: 'Kevin Durant',
          role: 'Crew',
          employeeId: 'AFCO-MTA01-CR-0012',
          status: 'PENDING',
          statusColor: Colors.orange,
          cardColor: cardColor,
          titleColor: primaryTextColor,
          subtitleColor: secondaryTextColor,
        ),

        const SizedBox(height: 14),

        EmployeeCard(
          name: 'Stephen Curry',
          role: 'Coach',
          employeeId: 'AFCO-MTA01-CO-0003',
          status: 'ACTIVE',
          statusColor: Colors.green,
          cardColor: cardColor,
          titleColor: primaryTextColor,
          subtitleColor: secondaryTextColor,
        ),
      ],
    );
  }
}
