// daily_sales/widgets/sales_quantity_card.dart

import 'package:flutter/material.dart';

class SalesQuantityCard extends StatelessWidget {
  final String title;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const SalesQuantityCard({
    super.key,
    required this.title,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.remove_circle_outline),
            ),

            Text(
              quantity.toString(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            IconButton(
              onPressed: onAdd,
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ),
    );
  }
}
