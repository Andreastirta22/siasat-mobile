import 'package:flutter/material.dart';

class HeadcrewReportsPage extends StatelessWidget {
  const HeadcrewReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark
        ? const Color(0xFF0F172A)
        : const Color(0xFFF5F7FA);

    final secondaryTextColor = Colors.grey.shade600;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Operational Reports',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Monitor attendance, operational execution, incidents, and manpower reporting.',
                style: TextStyle(fontSize: 15, color: secondaryTextColor),
              ),

              const SizedBox(height: 28),

              Row(
                children: [
                  Expanded(
                    child: _ReportStatCard(
                      title: 'Daily Reports',
                      value: '18',
                      icon: Icons.description_rounded,
                      color: Colors.blue,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: _ReportStatCard(
                      title: 'Pending Review',
                      value: '4',
                      icon: Icons.pending_actions_rounded,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _ReportStatCard(
                      title: 'Incidents',
                      value: '2',
                      icon: Icons.report_problem_rounded,
                      color: Colors.red,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: _ReportStatCard(
                      title: 'Attendance',
                      value: '92%',
                      icon: Icons.fact_check_rounded,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              const Text(
                'Report Categories',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 18),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: const [
                  _ReportCategoryCard(
                    icon: Icons.groups_2_rounded,
                    title: 'Manpower',
                    color: Colors.blue,
                  ),

                  _ReportCategoryCard(
                    icon: Icons.assignment_turned_in_rounded,
                    title: 'Operational',
                    color: Colors.green,
                  ),

                  _ReportCategoryCard(
                    icon: Icons.warning_amber_rounded,
                    title: 'Incidents',
                    color: Colors.orange,
                  ),

                  _ReportCategoryCard(
                    icon: Icons.payments_rounded,
                    title: 'Expenses',
                    color: Colors.purple,
                  ),
                ],
              ),

              const SizedBox(height: 32),

              const Text(
                'Latest Reports',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 18),

              _LatestReportTile(
                title: 'Daily Attendance Submitted',
                subtitle: 'Today • 24 Crew Attendance Recorded',
                icon: Icons.fact_check_rounded,
                color: Colors.green,
              ),

              const SizedBox(height: 14),

              _LatestReportTile(
                title: 'Operational Delay Incident',
                subtitle: 'Stage Setup • Waiting Equipment Delivery',
                icon: Icons.report_problem_rounded,
                color: Colors.orange,
              ),

              const SizedBox(height: 14),

              _LatestReportTile(
                title: 'Manpower Fulfillment Updated',
                subtitle: '81% Crew Allocation Completed',
                icon: Icons.groups_rounded,
                color: Colors.blue,
              ),

              const SizedBox(height: 14),

              _LatestReportTile(
                title: 'Daily Expense Uploaded',
                subtitle: 'Transport & Logistic Reimbursement',
                icon: Icons.receipt_long_rounded,
                color: Colors.purple,
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReportStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _ReportStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            title,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

class _ReportCategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _ReportCategoryCard({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: color, size: 34),
          ),

          const SizedBox(height: 16),

          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _LatestReportTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _LatestReportTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
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
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
