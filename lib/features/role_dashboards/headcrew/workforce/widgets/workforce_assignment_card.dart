// widgets/workforce_assignment_card.dart

import 'package:flutter/material.dart';

class WorkforceAssignmentCard extends StatelessWidget {
  final String workforceName;
  final String workforceId;

  const WorkforceAssignmentCard({
    super.key,
    required this.workforceName,
    required this.workforceId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.person),
        title: Text(workforceName),
        subtitle: Text(workforceId),
      ),
    );
  }
}
