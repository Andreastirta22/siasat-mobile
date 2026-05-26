import 'package:flutter/material.dart';

class ShiftsPage extends StatelessWidget {
  const ShiftsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0F1115),
      body: Center(
        child: Text("Shifts Page", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
