import 'package:flutter/material.dart';

class EventEmptyState extends StatelessWidget {
  final bool isDark;

  const EventEmptyState({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No events found',
        style: TextStyle(color: isDark ? Colors.white54 : Colors.black54),
      ),
    );
  }
}
