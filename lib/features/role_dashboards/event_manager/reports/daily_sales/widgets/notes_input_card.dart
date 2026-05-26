// daily_sales/widgets/notes_input_card.dart

import 'package:flutter/material.dart';

class NotesInputCard extends StatelessWidget {
  final TextEditingController controller;

  const NotesInputCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: TextField(
          controller: controller,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Operational notes...',
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
