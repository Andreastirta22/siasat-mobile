import 'package:flutter/material.dart';

import 'employee_card.dart';

class OperationalLeadersSection extends StatelessWidget {
  final List<Map<String, dynamic>> leaders;

  const OperationalLeadersSection({super.key, required this.leaders});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final titleColor = isDark ? Colors.white : Colors.black;

    final cardColor = isDark ? Colors.white : const Color(0xFF111827);

    final primaryTextColor = isDark ? Colors.black : Colors.white;

    final secondaryTextColor = isDark ? Colors.black54 : Colors.white70;

    /// =========================================
    /// ROLE FILTERING
    /// =========================================

    final operationalPic = leaders.where(
      (leader) => leader['role'] == 'headcrew' || leader['role'] == 'head crew',
    );

    final supervisingManagers = leaders.where(
      (leader) => leader['role'] == 'event_manager',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          'Operational Leaders',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: titleColor,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'Operational PIC and supervisory leadership structure.',
          style: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.white70 : Colors.grey.shade700,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 24),

        /// =========================================
        /// OPERATIONAL PIC
        /// =========================================
        Text(
          'Operational PIC',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: titleColor,
          ),
        ),

        const SizedBox(height: 12),

        if (operationalPic.isEmpty)
          _buildEmptyState(titleColor, 'No active headcrew assigned.'),

        ...operationalPic.map(
          (leader) => Padding(
            padding: const EdgeInsets.only(bottom: 14),

            child: EmployeeCard(
              name: leader['full_name'] ?? '-',
              role: 'Headcrew',
              employeeId: leader['employee_id'] ?? '-',
              status: (leader['employment_status'] ?? 'UNKNOWN')
                  .toString()
                  .toUpperCase(),
              statusColor: Colors.green,
              cardColor: cardColor,
              titleColor: primaryTextColor,
              subtitleColor: secondaryTextColor,
            ),
          ),
        ),

        const SizedBox(height: 24),

        /// =========================================
        /// SUPERVISING MANAGER
        /// =========================================
        Text(
          'Supervising Manager',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: titleColor,
          ),
        ),

        const SizedBox(height: 12),

        if (supervisingManagers.isEmpty)
          _buildEmptyState(titleColor, 'No active event manager found.'),

        ...supervisingManagers.map(
          (leader) => Padding(
            padding: const EdgeInsets.only(bottom: 14),

            child: EmployeeCard(
              name: leader['full_name'] ?? '-',
              role: 'Event Manager',
              employeeId: leader['employee_id'] ?? '-',
              status: (leader['employment_status'] ?? 'UNKNOWN')
                  .toString()
                  .toUpperCase(),
              statusColor: Colors.green,
              cardColor: cardColor,
              titleColor: primaryTextColor,
              subtitleColor: secondaryTextColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(Color textColor, String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),

      child: Text(message, style: TextStyle(color: textColor.withOpacity(0.7))),
    );
  }
}
