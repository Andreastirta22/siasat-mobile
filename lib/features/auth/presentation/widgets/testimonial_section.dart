import 'package:flutter/material.dart';

class TestimonialSection extends StatelessWidget {
  const TestimonialSection({super.key});

  @override
  Widget build(BuildContext context) {
    final testimonials = [
      {
        'quote':
            'SIASAT membantu koordinasi manpower event menjadi jauh lebih cepat dan terstruktur.',
        'name': 'Rizky A.',
        'role': 'Event Manager',
        'initial': 'R',
        'color': const Color(0xFFF5A623),
      },
      {
        'quote':
            'Attendance validation dan reporting flow jadi lebih efisien saat event berlangsung.',
        'name': 'Dina S.',
        'role': 'Headcrew',
        'initial': 'D',
        'color': const Color(0xFF7C4DFF),
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
                    'TESTIMONIALS',
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
                      TextSpan(text: 'Dipercaya oleh\n'),
                      TextSpan(
                        text: 'tim operasional ',
                        style: TextStyle(color: Color(0xFFF5A623)),
                      ),
                      TextSpan(text: '& field crew.'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          Column(
            children: testimonials.map((t) {
              final Color accent = t['color'] as Color;

              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF141414),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFF222222)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Quote icon ──
                    Icon(
                      Icons.format_quote_rounded,
                      color: accent.withOpacity(0.6),
                      size: 26,
                    ),

                    const SizedBox(height: 16),

                    Text(
                      '"${t['quote']}"',
                      style: const TextStyle(
                        color: Color(0xFFD0D0D0),
                        fontSize: 15,
                        height: 1.75,
                        letterSpacing: 0.1,
                        fontStyle: FontStyle.italic,
                      ),
                    ),

                    const SizedBox(height: 22),

                    // ── Divider ──
                    Container(height: 1, color: const Color(0xFF1E1E1E)),

                    const SizedBox(height: 18),

                    // ── Author ──
                    Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: accent.withOpacity(0.12),
                            shape: BoxShape.circle,
                            border: Border.all(color: accent.withOpacity(0.25)),
                          ),
                          child: Center(
                            child: Text(
                              t['initial'] as String,
                              style: TextStyle(
                                color: accent,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t['name'] as String,
                              style: const TextStyle(
                                color: Color(0xFFF0F0F0),
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              t['role'] as String,
                              style: const TextStyle(
                                color: Color(0xFF5A5A5A),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: List.generate(
                            5,
                            (i) => const Icon(
                              Icons.star_rounded,
                              color: Color(0xFFF5A623),
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
