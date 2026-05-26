import 'package:flutter/material.dart';

class DashboardActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const DashboardActionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18),

        decoration: BoxDecoration(
          color: const Color(0xFF171A20),

          borderRadius: BorderRadius.circular(22),

          border: Border.all(color: Colors.white.withOpacity(0.04)),
        ),

        child: Row(
          children: [
            CircleAvatar(
              radius: 22,

              backgroundColor: Colors.white.withOpacity(0.08),

              child: Icon(icon, color: Colors.white),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Text(
                title,

                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
