// event_card.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/event_status_config.dart';
import '../utils/event_formatters.dart';
import 'event_action_button.dart';
import 'event_info_chip.dart';

class EventCard extends StatelessWidget {
  final Map<String, dynamic> event;
  final bool isDark;
  final Function(Map<String, dynamic>) onAction;

  const EventCard({
    super.key,
    required this.event,
    required this.isDark,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final status = event['status'];
    debugPrint('EVENT STATUS = $status');
    final config =
        eventStatusConfigs[status] ??
        EventStatusConfig(
          color: Colors.grey,
          icon: Icons.help_outline_rounded,
          actionLabel: 'View Detail',
          route: '/event-manager',
        );

    final venue = (event['venues'] as List?)?.isNotEmpty == true
        ? event['venues'][0]
        : null;

    final headcrew = event['headcrew'];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF111827), const Color(0xFF1E293B)]
              : [Colors.white, const Color(0xFFF8FAFC)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Container(
              height: 5,

              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [config.color, config.color.withOpacity(0.5)],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(22),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  _buildHeader(config),

                  const SizedBox(height: 22),

                  _buildLifecycle(config),

                  const SizedBox(height: 22),

                  EventInfoChip(
                    icon: Icons.location_on_rounded,

                    text: venue?['address'] ?? 'Venue not configured',

                    color: const Color(0xFF6366F1),

                    isDark: isDark,
                  ),

                  const SizedBox(height: 14),

                  EventInfoChip(
                    icon: Icons.manage_accounts_rounded,

                    text:
                        headcrew?['full_name'] ??
                        'Operational PIC not assigned',

                    color: const Color(0xFF14B8A6),

                    isDark: isDark,
                  ),

                  const SizedBox(height: 22),

                  /// QUICK ACTIONS
                  Row(
                    children: [
                      Expanded(
                        child: _MiniActionButton(
                          label: 'Pricing',

                          icon: Icons.sell_outlined,

                          color: const Color(0xFFF59E0B),

                          onTap: () {
                            if (venue == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Setup venue first'),
                                ),
                              );

                              return;
                            }

                            context.push(
                              '/event-manager/pricing-setup',

                              extra: {
                                'eventId': event['id'],

                                'venueId': venue['id'],

                                'venueName': venue['name'] ?? 'Venue',
                              },
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _MiniActionButton(
                          label: 'Reports',

                          icon: Icons.receipt_long_outlined,

                          color: const Color(0xFF6366F1),

                          onTap: () {},
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  /// PRIMARY ACTION
                  Row(
                    children: [
                      Expanded(
                        child: EventActionButton(
                          label: config.actionLabel,

                          color: config.color,

                          icon: Icons.arrow_forward_rounded,

                          onPressed: () {
                            final status = event['status'];

                            /// REVIEW MANPOWER
                            if (status == 'manpower_filling') {
                              context.push(config.route, extra: event['id']);

                              return;
                            }

                            /// HEADCREW MANPOWER FILLING
                            if (status == 'headcrew_assigned') {
                              context.push(
                                '/headcrew/manpower-filling',

                                extra: {
                                  'eventId': event['id'],
                                  'eventName': event['name'],
                                  'venueName':
                                      venue?['name'] ?? 'Unknown Venue',
                                },
                              );

                              return;
                            }

                            /// DEFAULT
                            context.push(config.route, extra: event);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(EventStatusConfig config) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Container(
          width: 54,
          height: 54,

          decoration: BoxDecoration(
            color: config.color.withOpacity(0.12),

            borderRadius: BorderRadius.circular(18),
          ),

          child: Icon(config.icon, color: config.color, size: 28),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                event['name'] ?? 'Unnamed Event',

                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  height: 1.1,

                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),

              const SizedBox(height: 8),

              Wrap(
                spacing: 8,
                runSpacing: 8,

                children: [
                  _buildBadge(
                    label: formatEventType(event['event_type'] ?? ''),

                    color: const Color(0xFF3B82F6),
                  ),

                  _buildBadge(
                    label: formatStatus(event['status']),

                    color: config.color,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLifecycle(EventStatusConfig config) {
    final currentStatus = event['status'];

    final stages = [
      'venue_setup',
      'manpower_planning',
      'manpower_filling',
      'ready_for_activation',
      'active',
    ];

    return Row(
      children: List.generate(stages.length, (index) {
        final isCompleted = stages.indexOf(currentStatus) >= index;

        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 5,

                  decoration: BoxDecoration(
                    color: isCompleted
                        ? config.color
                        : Colors.grey.withOpacity(0.15),

                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              if (index != stages.length - 1) const SizedBox(width: 6),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBadge({required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),

      decoration: BoxDecoration(
        color: color.withOpacity(0.12),

        borderRadius: BorderRadius.circular(10),
      ),

      child: Text(
        label,

        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class _MiniActionButton extends StatelessWidget {
  final String label;

  final IconData icon;

  final Color color;

  final VoidCallback onTap;

  const _MiniActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),

      onTap: onTap,

      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 14),

        decoration: BoxDecoration(
          color: color.withOpacity(0.1),

          borderRadius: BorderRadius.circular(16),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(icon, size: 18, color: color),

            const SizedBox(width: 8),

            Text(
              label,

              style: TextStyle(color: color, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
