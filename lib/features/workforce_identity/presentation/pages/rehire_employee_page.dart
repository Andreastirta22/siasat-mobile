import 'package:flutter/material.dart';

import '../../models/identity_check_result.dart';

class RehireEmployeePage extends StatelessWidget {
  final IdentityCheckResult result;

  const RehireEmployeePage({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rehire Employee')),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Former Workforce Detected',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 24),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.badge),

              title: const Text('Employee ID'),

              subtitle: Text(result.employeeId ?? '-'),
            ),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.person),

              title: const Text('Full Name'),

              subtitle: Text(result.fullName ?? '-'),
            ),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.work),

              title: const Text('Previous Role'),

              subtitle: Text(result.role ?? '-'),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 54,

              child: ElevatedButton.icon(
                onPressed: () {},

                icon: const Icon(Icons.refresh),

                label: const Text('Reactivate Workforce'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
