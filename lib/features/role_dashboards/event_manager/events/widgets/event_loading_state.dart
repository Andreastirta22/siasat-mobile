import 'package:flutter/material.dart';

class EventLoadingState extends StatelessWidget {
  const EventLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
