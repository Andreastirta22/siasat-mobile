// widgets/venue_manpower_section.dart

import 'package:flutter/material.dart';

class VenueManpowerSection extends StatelessWidget {
  final String venueName;

  final Widget child;

  const VenueManpowerSection({
    super.key,
    required this.venueName,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            venueName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        child,
      ],
    );
  }
}
