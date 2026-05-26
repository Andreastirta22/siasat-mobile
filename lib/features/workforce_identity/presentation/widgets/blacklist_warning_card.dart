import 'package:flutter/material.dart';

class BlacklistWarningCard extends StatelessWidget {
  const BlacklistWarningCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),

      decoration: const BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          const Icon(Icons.block, color: Colors.red, size: 64),

          const SizedBox(height: 20),

          const Text(
            'Blacklisted Workforce',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          const Text(
            'This workforce identity has been blocked from operational onboarding.',
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
