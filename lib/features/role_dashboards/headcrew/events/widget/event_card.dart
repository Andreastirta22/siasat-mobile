import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/headcrew_event_model.dart';

import 'event_meta_row.dart';
import 'event_status_badge.dart';
import 'gradient_action_button.dart';
import 'manpower_chip.dart';

class EventCard extends StatelessWidget {
  final HeadcrewEventModel event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),

      decoration: BoxDecoration(
        color: colorScheme.surface,

        borderRadius: BorderRadius.circular(24),

        border: Border.all(
          color: colorScheme.outline.withOpacity(isDark ? 0.18 : 0.10),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.18 : 0.04),

            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// ─────────────────────────────
            /// HEADER
            /// ─────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        event.name,

                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        event.eventType.replaceAll('_', ' ').toUpperCase(),

                        style: TextStyle(
                          color: colorScheme.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                EventStatusBadge(status: event.status),
              ],
            ),

            const SizedBox(height: 18),

            /// ─────────────────────────────
            /// META
            /// ─────────────────────────────
            EventMetaRow(
              icon: Icons.location_on_rounded,
              text: event.venueName ?? '-',
            ),

            EventMetaRow(
              icon: Icons.calendar_month_rounded,
              text: '${event.startDate} → ${event.endDate}',
            ),

            const SizedBox(height: 18),

            Divider(color: colorScheme.outline.withOpacity(0.10), thickness: 1),

            const SizedBox(height: 16),

            /// ─────────────────────────────
            /// MANPOWER
            /// ─────────────────────────────
            Text(
              'MANPOWER REQUIRED',

              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.55),
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,

              children: [
                if (event.crewNeeded != null)
                  ManpowerChip(label: 'Crew', value: event.crewNeeded),

                if (event.coachNeeded != null)
                  ManpowerChip(label: 'Coach', value: event.coachNeeded),

                if (event.ringGuardNeeded != null)
                  ManpowerChip(
                    label: 'Ring Guard',
                    value: event.ringGuardNeeded,
                  ),

                if (event.medicNeeded != null)
                  ManpowerChip(label: 'Medic', value: event.medicNeeded),

                if (event.cashierNeeded != null)
                  ManpowerChip(label: 'Cashier', value: event.cashierNeeded),
              ],
            ),

            const SizedBox(height: 22),

            /// ─────────────────────────────
            /// ACTION BUTTON
            /// ─────────────────────────────
            _buildActionButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    switch (event.status) {
      case 'manpower_filling':
        return GradientActionButton(
          onPressed: () {
            context.push(
              '/headcrew/manpower-filling',
              extra: {
                'eventId': event.id,
                'eventName': event.name,
                'venueName': event.venueName ?? '-',
              },
            );
          },

          gradient: const LinearGradient(
            colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
          ),

          icon: Icons.group_add_rounded,

          label: 'Manage Workforce',
        );

      case 'active':
        return GradientActionButton(
          onPressed: () {
            context.push('/attendance-control', extra: event.id);
          },

          gradient: const LinearGradient(
            colors: [Color(0xFF16A34A), Color(0xFF22C55E)],
          ),

          icon: Icons.fact_check_rounded,

          label: 'Attendance Control',
        );

      case 'completed':
        return GradientActionButton(
          onPressed: () {
            context.push('/operational-report', extra: event.id);
          },

          gradient: const LinearGradient(
            colors: [Color(0xFF334155), Color(0xFF475569)],
          ),

          icon: Icons.analytics_rounded,

          label: 'Operational Report',
        );

      default:
        return const SizedBox();
    }
  }
}
