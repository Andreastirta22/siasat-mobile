import 'package:flutter/material.dart';

import '../../../../core/navigation/main_navigation_shell.dart';
import '../../../../core/navigation/navigation_config.dart';

import '../../profile/presentation/pages/profile_page.dart';

class PrincipalDashboardPage extends StatelessWidget {
  const PrincipalDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainNavigationShell(
      items: [
        NavigationItem(
          icon: Icons.dashboard_rounded,
          label: 'Dashboard',
          page: const _PrincipalHomePage(),
        ),
        NavigationItem(
          icon: Icons.payments_rounded,
          label: 'Finance',
          page: const _FinancePage(),
        ),
        NavigationItem(
          icon: Icons.analytics_rounded,
          label: 'Sales',
          page: const _SalesPage(),
        ),
        NavigationItem(
          icon: Icons.person_rounded,
          label: 'Profile',
          page: const ProfilePage(),
        ),
      ],
    );
  }
}

class _PrincipalHomePage extends StatelessWidget {
  const _PrincipalHomePage();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark
        ? const Color(0xFF0F172A)
        : const Color(0xFFF5F7FA);

    final cardColor = isDark ? Colors.white : const Color(0xFF111827);

    final primaryTextColor = isDark ? Colors.black : Colors.white;

    final secondaryTextColor = isDark ? Colors.black54 : Colors.white70;

    final titleColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Principal Dashboard',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Monitor business growth, financial operations, and venue performance.',
                style: TextStyle(
                  fontSize: 15,
                  color: isDark ? Colors.white70 : Colors.grey.shade700,
                ),
              ),

              const SizedBox(height: 28),

              Row(
                children: [
                  Expanded(
                    child: DashboardStatCard(
                      title: 'Today Revenue',
                      value: 'Rp 8.4M',
                      icon: Icons.attach_money_rounded,
                      color: Colors.green,
                      cardColor: cardColor,
                      primaryTextColor: primaryTextColor,
                      secondaryTextColor: secondaryTextColor,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: DashboardStatCard(
                      title: 'Monthly Profit',
                      value: 'Rp 96M',
                      icon: Icons.trending_up_rounded,
                      color: Colors.blue,
                      cardColor: cardColor,
                      primaryTextColor: primaryTextColor,
                      secondaryTextColor: secondaryTextColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: DashboardStatCard(
                      title: 'Active Venues',
                      value: '4',
                      icon: Icons.storefront_rounded,
                      color: Colors.orange,
                      cardColor: cardColor,
                      primaryTextColor: primaryTextColor,
                      secondaryTextColor: secondaryTextColor,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: DashboardStatCard(
                      title: 'Payroll Pending',
                      value: '12',
                      icon: Icons.account_balance_wallet_rounded,
                      color: Colors.purple,
                      cardColor: cardColor,
                      primaryTextColor: primaryTextColor,
                      secondaryTextColor: secondaryTextColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              Text(
                'Executive Actions',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),

              const SizedBox(height: 18),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: [
                  QuickActionCard(
                    icon: Icons.add_business_rounded,
                    title: 'Create Venue',
                    cardColor: cardColor,
                    textColor: primaryTextColor,
                  ),

                  QuickActionCard(
                    icon: Icons.receipt_long_rounded,
                    title: 'Financial Reports',
                    cardColor: cardColor,
                    textColor: primaryTextColor,
                  ),

                  QuickActionCard(
                    icon: Icons.groups_rounded,
                    title: 'Employee Overview',
                    cardColor: cardColor,
                    textColor: primaryTextColor,
                  ),

                  QuickActionCard(
                    icon: Icons.bar_chart_rounded,
                    title: 'Sales Analytics',
                    cardColor: cardColor,
                    textColor: primaryTextColor,
                  ),
                ],
              ),

              const SizedBox(height: 32),

              Text(
                'Business Activity',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),

              const SizedBox(height: 18),

              ActivityTile(
                title: 'Payroll Approved',
                subtitle: 'Finance Office finalized this week payroll',
                icon: Icons.verified_rounded,
                cardColor: cardColor,
                titleColor: primaryTextColor,
                subtitleColor: secondaryTextColor,
              ),

              const SizedBox(height: 14),

              ActivityTile(
                title: 'Venue Performance Increased',
                subtitle: 'MTA01 sales increased by 18%',
                icon: Icons.insights_rounded,
                cardColor: cardColor,
                titleColor: primaryTextColor,
                subtitleColor: secondaryTextColor,
              ),

              const SizedBox(height: 14),

              ActivityTile(
                title: 'New Financial Report',
                subtitle: 'Monthly operational report uploaded',
                icon: Icons.description_rounded,
                cardColor: cardColor,
                titleColor: primaryTextColor,
                subtitleColor: secondaryTextColor,
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _FinancePage extends StatelessWidget {
  const _FinancePage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'FINANCE MANAGEMENT PAGE',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _SalesPage extends StatelessWidget {
  const _SalesPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'SALES ANALYTICS PAGE',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class DashboardStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color cardColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;

  const DashboardStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.cardColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 28),
          ),

          const Spacer(),

          Text(
            value,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: primaryTextColor,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            title,
            style: TextStyle(fontSize: 14, color: secondaryTextColor),
          ),
        ],
      ),
    );
  }
}

class QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color cardColor;
  final Color textColor;

  const QuickActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.cardColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 34, color: textColor),

          const SizedBox(height: 14),

          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class ActivityTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color cardColor;
  final Color titleColor;
  final Color subtitleColor;

  const ActivityTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.cardColor,
    required this.titleColor,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.green),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: subtitleColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
