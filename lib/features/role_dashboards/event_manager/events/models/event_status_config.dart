// event_status_config.dart

import 'package:flutter/material.dart';

class EventStatusConfig {
  final Color color;
  final IconData icon;
  final String actionLabel;
  final String route;

  const EventStatusConfig({
    required this.color,
    required this.icon,
    required this.actionLabel,
    required this.route,
  });
}

final Map<String, EventStatusConfig> eventStatusConfigs = {
  'planning': EventStatusConfig(
    color: const Color(0xFFF59E0B),
    icon: Icons.edit_calendar_rounded,
    actionLabel: 'Setup Venue',
    route: '/event-manager/events',
  ),

  'venue_setup': EventStatusConfig(
    color: const Color(0xFFF97316),
    icon: Icons.location_city_rounded,
    actionLabel: 'Setup Venue',
    route: '/event-manager/events',
  ),

  'headcrew_assigned': EventStatusConfig(
    color: const Color(0xFF6366F1),
    icon: Icons.badge_rounded,
    actionLabel: 'Setup Manpower',
    route: '/event-manager/events',
  ),

  'manpower_planning': EventStatusConfig(
    color: const Color(0xFF3B82F6),
    icon: Icons.people_alt_rounded,
    actionLabel: 'Setup Manpower',
    route: '/event-manager/events',
  ),

  'manpower_filling': EventStatusConfig(
    color: const Color(0xFF06B6D4),
    icon: Icons.groups_2_rounded,
    actionLabel: 'Review Manpower',
    route: '/headcrew/workforce-review',
  ),

  'ready_for_activation': EventStatusConfig(
    color: const Color(0xFF14B8A6),
    icon: Icons.rocket_launch_rounded,
    actionLabel: 'Activate Event',
    route: '/event-manager/events',
  ),

  'active': EventStatusConfig(
    color: const Color(0xFF22C55E),
    icon: Icons.flash_on_rounded,
    actionLabel: 'View Operations',
    route: '/event-manager/events',
  ),

  'completed': EventStatusConfig(
    color: const Color(0xFF94A3B8),
    icon: Icons.check_circle_rounded,
    actionLabel: 'View Report',
    route: '/event-manager/reports',
  ),

  'cancelled': EventStatusConfig(
    color: const Color(0xFFEF4444),
    icon: Icons.cancel_rounded,
    actionLabel: 'View Detail',
    route: '/event-manager/events',
  ),
};
