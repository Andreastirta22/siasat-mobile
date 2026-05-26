import 'package:flutter/material.dart';

import '../constants/event_ui_constants.dart';

class GradientActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Gradient gradient;
  final IconData icon;
  final String label;

  const GradientActionButton({
    super.key,
    required this.onPressed,
    required this.gradient,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(EventUiConstants.buttonRadius),
        ),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                EventUiConstants.buttonRadius,
              ),
            ),
          ),
          onPressed: onPressed,
          icon: Icon(icon, size: 18),
          label: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
        ),
      ),
    );
  }
}
