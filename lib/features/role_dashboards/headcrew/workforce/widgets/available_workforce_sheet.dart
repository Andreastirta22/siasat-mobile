// widgets/available_workforce_sheet.dart

import 'package:flutter/material.dart';

class AvailableWorkforceSheet extends StatelessWidget {
  final List<Map<String, dynamic>> workforce;

  final Function(Map<String, dynamic>) onSelected;

  const AvailableWorkforceSheet({
    super.key,
    required this.workforce,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: workforce.length,
        itemBuilder: (context, index) {
          final worker = workforce[index];

          return Card(
            child: ListTile(
              title: Text(worker['full_name'] ?? '-'),
              subtitle: Text(worker['workforce_id'] ?? '-'),
              trailing: ElevatedButton(
                onPressed: () {
                  onSelected(worker);
                },
                child: const Text('Assign'),
              ),
            ),
          );
        },
      ),
    );
  }
}
