import 'package:flutter/material.dart';

import '../constants/event_ui_constants.dart';

class EmptyEventsState extends StatelessWidget {
  final VoidCallback onRefresh;

  const EmptyEventsState({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: EventUiConstants.bgCard,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.event_busy_rounded,
                color: EventUiConstants.textDarkMuted,
                size: 36,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Events Found',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'No operational events assigned.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: EventUiConstants.textDarkMuted,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }
}
