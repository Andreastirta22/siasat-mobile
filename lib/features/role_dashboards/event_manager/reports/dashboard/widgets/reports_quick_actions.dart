import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReportsQuickActions extends StatelessWidget {
  const ReportsQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            label: 'Create',
            icon: Icons.add_box_outlined,

            onTap: () {
              context.push('/event-manager/create-report');
            },
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _ActionButton(
            label: 'Analytics',
            icon: Icons.bar_chart_outlined,

            onTap: () {
              context.push('/event-manager/reports-analytics');
            },
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _ActionButton(
            label: 'Exports',
            icon: Icons.file_download_outlined,

            onTap: () {},
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;

  final IconData icon;

  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),

      onTap: onTap,

      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 18),

        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
        ),

        child: Column(
          children: [
            Icon(icon, color: Colors.white),

            const SizedBox(height: 8),

            Text(
              label,

              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
