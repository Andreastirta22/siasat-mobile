import 'package:flutter/material.dart';

class EventShowcaseSection extends StatelessWidget {
  const EventShowcaseSection({super.key});

  @override
  Widget build(BuildContext context) {
    final events = [
      {
        'title': 'Jakarta Music Festival',
        'subtitle': '250+ Workforce Managed',
        'tag': 'Music',
        'color': const Color(0xFF7C4DFF),
      },
      {
        'title': 'National Skating Championship',
        'subtitle': 'Operational Event Coordination',
        'tag': 'Sports',
        'color': const Color(0xFF00BCD4),
      },
      {
        'title': 'Community Sports Event',
        'subtitle': 'Attendance & Reporting System',
        'tag': 'Community',
        'color': const Color(0xFF4CAF50),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
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
                  'EVENT SHOWCASE',
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
                    TextSpan(text: 'Dibangun untuk\n'),
                    TextSpan(
                      text: 'operasional lapangan ',
                      style: TextStyle(color: Color(0xFFF5A623)),
                    ),
                    TextSpan(text: 'nyata.'),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 28),

        SizedBox(
          height: 240,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: events.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final event = events[index];
              final Color accentColor = event['color'] as Color;

              return Container(
                width: 260,
                decoration: BoxDecoration(
                  color: const Color(0xFF141414),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFF222222)),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Image area ──
                    Container(
                      height: 138,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            accentColor.withOpacity(0.25),
                            const Color(0xFF1A1A1A),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Grid pattern overlay
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _MiniGridPainter(accentColor),
                            ),
                          ),
                          Center(
                            child: Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: accentColor.withOpacity(0.15),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: accentColor.withOpacity(0.3),
                                ),
                              ),
                              child: Icon(
                                Icons.image_rounded,
                                color: accentColor.withOpacity(0.7),
                                size: 24,
                              ),
                            ),
                          ),
                          // Tag
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: accentColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: accentColor.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                event['tag'] as String,
                                style: TextStyle(
                                  color: accentColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Content ──
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              event['title'] as String,
                              style: const TextStyle(
                                color: Color(0xFFF0F0F0),
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: accentColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  event['subtitle'] as String,
                                  style: const TextStyle(
                                    color: Color(0xFF6A6A6A),
                                    fontSize: 12,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MiniGridPainter extends CustomPainter {
  final Color accentColor;
  const _MiniGridPainter(this.accentColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = accentColor.withOpacity(0.06)
      ..strokeWidth = 1;

    const spacing = 24.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
