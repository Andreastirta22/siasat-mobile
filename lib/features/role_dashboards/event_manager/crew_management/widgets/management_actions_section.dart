import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'management_action_card.dart';

class ManagementActionsSection extends StatelessWidget {
  const ManagementActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final titleColor = isDark ? Colors.white : Colors.black;

    final cardColor = isDark ? Colors.white : const Color(0xFF111827);

    final primaryTextColor = isDark ? Colors.black : Colors.white;

    final secondaryTextColor = isDark ? Colors.black54 : Colors.white70;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          'Management Actions',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: titleColor,
          ),
        ),

        const SizedBox(height: 18),

        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),

          /// FIX OVERFLOW
          childAspectRatio: 0.92,

          children: [
            /// CREATE EMPLOYEE
            ManagementActionCard(
              icon: Icons.person_add_alt_1_rounded,
              title: 'Create Employee',
              subtitle: 'Create manpower account',
              cardColor: cardColor,
              titleColor: primaryTextColor,
              subtitleColor: secondaryTextColor,
              onTap: () {
                context.push('/event-manager/create-employee');
              },
            ),

            /// ASSIGN MANPOWER
            ManagementActionCard(
              icon: Icons.groups_2_rounded,
              title: 'Assign Manpower',
              subtitle: 'Setup event manpower',
              cardColor: cardColor,
              titleColor: primaryTextColor,
              subtitleColor: secondaryTextColor,
              onTap: () {
                context.push('/event-manager/events');
              },
            ),

            /// PENDING ACCOUNTS
            ManagementActionCard(
              icon: Icons.pending_actions_rounded,
              title: 'Pending Accounts',
              subtitle: 'Review onboarding status',
              cardColor: cardColor,
              titleColor: primaryTextColor,
              subtitleColor: secondaryTextColor,
              onTap: () {
                context.push('/event-manager/workforce/pending');
              },
            ),

            /// BLACKLIST
            ManagementActionCard(
              icon: Icons.block_rounded,
              title: 'Blacklist',
              subtitle: 'Restricted workforce',
              cardColor: cardColor,
              titleColor: primaryTextColor,
              subtitleColor: secondaryTextColor,
              onTap: () {
                context.push('/event-manager/blacklist');
              },
            ),
          ],
        ),
      ],
    );
  }
}
