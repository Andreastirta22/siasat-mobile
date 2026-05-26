// widgets/workforce_slot_card.dart

import 'package:flutter/material.dart';

class WorkforceSlotCard extends StatelessWidget {
  final int slotNumber;
  final bool isFilled;

  const WorkforceSlotCard({
    super.key,
    required this.slotNumber,
    required this.isFilled,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(isFilled ? Icons.check_circle : Icons.circle_outlined),
        title: Text('Slot $slotNumber'),
        subtitle: Text(isFilled ? 'Filled' : 'Empty'),
      ),
    );
  }
}
