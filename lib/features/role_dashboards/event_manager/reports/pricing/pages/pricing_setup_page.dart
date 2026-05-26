// pricing/pages/pricing_setup_page.dart

import 'package:flutter/material.dart';

class PricingSetupPage extends StatefulWidget {
  final String eventId;

  final String venueId;

  final String venueName;

  const PricingSetupPage({
    super.key,
    required this.eventId,
    required this.venueId,
    required this.venueName,
  });

  @override
  State<PricingSetupPage> createState() => _PricingSetupPageState();
}

class _PricingSetupPageState extends State<PricingSetupPage> {
  final TextEditingController weekdayTicketController = TextEditingController();

  final TextEditingController weekendTicketController = TextEditingController();

  final TextEditingController insuranceController = TextEditingController();

  final TextEditingController coachController = TextEditingController();

  final TextEditingController gloveController = TextEditingController();

  final TextEditingController socksController = TextEditingController();

  @override
  void dispose() {
    weekdayTicketController.dispose();

    weekendTicketController.dispose();

    insuranceController.dispose();

    coachController.dispose();

    gloveController.dispose();

    socksController.dispose();

    super.dispose();
  }

  Widget buildInput({
    required String title,
    required TextEditingController controller,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),

        border: Border.all(color: Colors.grey.shade200),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            title,

            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: controller,

            keyboardType: TextInputType.number,

            decoration: InputDecoration(
              hintText: 'Input price',

              prefixText: 'Rp ',

              filled: true,
              fillColor: Colors.grey.shade100,

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),

                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pricing - ${widget.venueName}')),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          /// TODO:
          /// save pricing config to Supabase

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Pricing config saved')));
        },

        label: const Text('Save Pricing'),

        icon: const Icon(Icons.save_outlined),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          buildInput(
            title: 'Weekday Ticket',
            controller: weekdayTicketController,
          ),

          const SizedBox(height: 16),

          buildInput(
            title: 'Weekend Ticket',
            controller: weekendTicketController,
          ),

          const SizedBox(height: 16),

          buildInput(title: 'Insurance', controller: insuranceController),

          const SizedBox(height: 16),

          buildInput(title: 'Coach', controller: coachController),

          const SizedBox(height: 16),

          buildInput(title: 'Glove', controller: gloveController),

          const SizedBox(height: 16),

          buildInput(title: 'Socks', controller: socksController),

          const SizedBox(height: 120),
        ],
      ),
    );
  }
}
