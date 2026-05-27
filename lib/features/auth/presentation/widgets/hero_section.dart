import 'package:flutter/material.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 44, 28, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Logo ──
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF5A623), Color(0xFFE8911A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFF5A623).withOpacity(0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.grid_view_rounded,
                  color: Color(0xFF0E0E0E),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'SIASAT',
                style: TextStyle(
                  color: Color(0xFFF5F5F5),
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.0,
                ),
              ),
              const Spacer(),
              // ── Version badge ──
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF2A2A2A)),
                ),
                child: const Text(
                  'v2.0',
                  style: TextStyle(
                    color: Color(0xFF8A8A8A),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 52),

          // ── Status pill ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFF5A623).withOpacity(0.10),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFF5A623).withOpacity(0.25),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5A623),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'OPERATIONAL · COORDINATED · EMPOWERED',
                  style: TextStyle(
                    color: Color(0xFFF5A623),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Main Heading ──
          RichText(
            text: const TextSpan(
              style: TextStyle(
                color: Color(0xFFF5F5F5),
                fontSize: 40,
                fontWeight: FontWeight.w800,
                height: 1.1,
                letterSpacing: -1.2,
              ),
              children: [
                TextSpan(text: 'Operational\nWorkforce & '),
                TextSpan(
                  text: 'Event\nManagement',
                  style: TextStyle(color: Color(0xFFF5A623)),
                ),
                TextSpan(text: ' System'),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // ── Description ──
          const Text(
            'SIASAT adalah platform terintegrasi untuk mengelola operasional event, '
            'koordinasi manpower, dan memantau performa workforce secara real time.',
            style: TextStyle(
              color: Color(0xFF6A6A6A),
              fontSize: 15,
              height: 1.75,
              letterSpacing: 0.1,
            ),
          ),

          const SizedBox(height: 32),

          // ── Stats row ──
          Row(
            children: [
              _buildStat('500+', 'Workforce'),
              _buildDivider(),
              _buildStat('50+', 'Events'),
              _buildDivider(),
              _buildStat('99%', 'Uptime'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFF5F5F5),
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF5A5A5A),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 36, color: const Color(0xFF2A2A2A));
  }
}
