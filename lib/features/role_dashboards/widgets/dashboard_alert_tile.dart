import 'package:flutter/material.dart';

class DashboardAlertTile extends StatelessWidget {
  final String title;
  final String subtitle;

  const DashboardAlertTile({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: const Color(0xFF171A20),

        borderRadius: BorderRadius.circular(22),

        border: Border.all(color: Colors.orange.withOpacity(0.15)),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.orange),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  subtitle,

                  style: TextStyle(color: Colors.grey.shade400, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
