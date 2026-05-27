import 'package:flutter/material.dart';

class FeatureHighlightSection extends StatelessWidget {
  const FeatureHighlightSection({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      {
        'icon': Icons.groups_rounded,
        'title': 'Workforce Coordination',
        'desc': 'Atur dan distribusikan tim lapangan secara efisien.',
      },
      {
        'icon': Icons.verified_user_rounded,
        'title': 'Attendance Validation',
        'desc': 'Validasi kehadiran crew secara akurat & real time.',
      },
      {
        'icon': Icons.bar_chart_rounded,
        'title': 'Reporting & Analytics',
        'desc': 'Laporan lengkap dengan insight yang mudah dibaca.',
      },
      {
        'icon': Icons.event_available_rounded,
        'title': 'Event Operations',
        'desc': 'Kelola seluruh alur operasional event dari satu platform.',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Label ──
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5A623).withOpacity(0.10),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: const Color(0xFFF5A623).withOpacity(0.20),
                    ),
                  ),
                  child: const Text(
                    'PLATFORM CAPABILITIES',
                    style: TextStyle(
                      color: Color(0xFFF5A623),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.8,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      color: Color(0xFFF5F5F5),
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                      letterSpacing: -0.8,
                    ),
                    children: [
                      TextSpan(text: 'Dirancang untuk\n'),
                      TextSpan(
                        text: 'manajemen operasional ',
                        style: TextStyle(color: Color(0xFFF5A623)),
                      ),
                      TextSpan(text: 'modern.'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: features.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.95,
            ),
            itemBuilder: (context, index) {
              final feature = features[index];
              final bool isHighlighted = index == 0;

              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isHighlighted
                      ? const Color(0xFFF5A623).withOpacity(0.08)
                      : const Color(0xFF141414),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isHighlighted
                        ? const Color(0xFFF5A623).withOpacity(0.30)
                        : const Color(0xFF222222),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon container
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isHighlighted
                            ? const Color(0xFFF5A623).withOpacity(0.20)
                            : const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isHighlighted
                              ? const Color(0xFFF5A623).withOpacity(0.35)
                              : const Color(0xFF2A2A2A),
                        ),
                      ),
                      child: Icon(
                        feature['icon'] as IconData,
                        color: const Color(0xFFF5A623),
                        size: 22,
                      ),
                    ),

                    const Spacer(),

                    Text(
                      feature['title'] as String,
                      style: const TextStyle(
                        color: Color(0xFFF5F5F5),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                        letterSpacing: -0.2,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      feature['desc'] as String,
                      style: const TextStyle(
                        color: Color(0xFF5A5A5A),
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
