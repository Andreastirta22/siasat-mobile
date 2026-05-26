import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/theme_provider.dart';

class ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const ProfileTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    /// CARD COLOR
    final cardColor = isDark ? Colors.white : const Color(0xFF171A23);

    /// ICON BOX
    final iconBoxColor = isDark
        ? const Color(0xFFF1F3F6)
        : Colors.white.withOpacity(0.06);

    /// TEXT
    final primaryTextColor = isDark ? Colors.black : Colors.white;

    final secondaryTextColor = isDark ? Colors.black54 : Colors.white70;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: cardColor,

        borderRadius: BorderRadius.circular(22),
      ),

      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,

            decoration: BoxDecoration(
              color: iconBoxColor,

              borderRadius: BorderRadius.circular(18),
            ),

            child: Icon(icon, color: primaryTextColor, size: 28),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: TextStyle(color: secondaryTextColor, fontSize: 14),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,

                  style: TextStyle(
                    color: primaryTextColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
