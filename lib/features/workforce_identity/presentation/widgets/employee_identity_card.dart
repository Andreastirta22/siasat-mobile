import 'package:flutter/material.dart';

class EmployeeIdentityCard extends StatelessWidget {
  final String fullName;
  final String employeeId;
  final String role;
  final String employmentStatus;

  const EmployeeIdentityCard({
    super.key,
    required this.fullName,
    required this.employeeId,
    required this.role,
    required this.employmentStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              fullName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text('Employee ID: $employeeId'),
            Text('Role: $role'),
            Text('Status: $employmentStatus'),
          ],
        ),
      ),
    );
  }
}
