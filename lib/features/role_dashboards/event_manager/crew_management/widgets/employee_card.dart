import 'package:flutter/material.dart';

class EmployeeCard extends StatelessWidget {
  final String name;
  final String role;
  final String employeeId;
  final String status;
  final Color statusColor;
  final Color cardColor;
  final Color titleColor;
  final Color subtitleColor;

  const EmployeeCard({
    super.key,
    required this.name,
    required this.role,
    required this.employeeId,
    required this.status,
    required this.statusColor,
    required this.cardColor,
    required this.titleColor,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
      ),

      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.blue.withOpacity(0.15),

            child: const Icon(
              Icons.person_rounded,
              color: Colors.blue,
              size: 30,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  role,
                  style: TextStyle(fontSize: 14, color: subtitleColor),
                ),

                const SizedBox(height: 6),

                Text(
                  employeeId,
                  style: TextStyle(fontSize: 12, color: subtitleColor),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),

            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(100),
            ),

            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
