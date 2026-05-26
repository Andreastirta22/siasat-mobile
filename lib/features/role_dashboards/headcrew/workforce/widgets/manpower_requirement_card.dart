// widgets/manpower_requirement_card.dart

import 'package:flutter/material.dart';

import '../models/manpower_requirement_model.dart';

class ManpowerRequirementCard extends StatelessWidget {
  final ManpowerRequirementModel requirement;

  final VoidCallback onAssign;

  final VoidCallback onViewAssignments;

  const ManpowerRequirementCard({
    super.key,
    required this.requirement,
    required this.onAssign,
    required this.onViewAssignments,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),

      onTap: onViewAssignments,

      child: Card(
        elevation: 0,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              /// ROLE TITLE
              Text(
                requirement.role,

                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              /// MANPOWER STATUS
              Text('Filled ${requirement.assigned}/${requirement.needed}'),

              const SizedBox(height: 12),

              /// PROGRESS BAR
              LinearProgressIndicator(value: requirement.progressPercentage),

              const SizedBox(height: 16),

              /// ASSIGN BUTTON
              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: onAssign,

                  child: Text('Assign ${requirement.role}'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
