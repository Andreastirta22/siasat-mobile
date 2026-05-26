import 'package:flutter/material.dart';

import '../constants/event_ui_constants.dart';

class EventColorHelper {
  static Color getStatusColor(String status) {
    switch (status) {
      case 'manpower_filling':
        return EventUiConstants.manpowerFilling;

      case 'active':
        return EventUiConstants.active;

      case 'completed':
        return EventUiConstants.completed;

      default:
        return Colors.white54;
    }
  }

  static Color getStatusBgColor(String status) {
    switch (status) {
      case 'manpower_filling':
        return EventUiConstants.manpowerFilling.withOpacity(0.12);

      case 'active':
        return EventUiConstants.active.withOpacity(0.12);

      case 'completed':
        return EventUiConstants.completed.withOpacity(0.12);

      default:
        return Colors.white.withOpacity(0.08);
    }
  }
}
