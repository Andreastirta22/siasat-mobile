// pages/workforce_review_page.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WorkforceReviewPage extends StatefulWidget {
  final String eventId;
  final String role;

  const WorkforceReviewPage({
    super.key,
    required this.eventId,
    required this.role,
  });

  @override
  State<WorkforceReviewPage> createState() => _WorkforceReviewPageState();
}

class _WorkforceReviewPageState extends State<WorkforceReviewPage>
    with TickerProviderStateMixin {
  final supabase = Supabase.instance.client;

  bool isLoading = true;
  List<Map<String, dynamic>> assignments = [];

  late AnimationController _listAnimController;

  @override
  void initState() {
    super.initState();
    _listAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    loadAssignments();
  }

  @override
  void dispose() {
    _listAnimController.dispose();
    super.dispose();
  }

  Future<void> loadAssignments() async {
    try {
      setState(() => isLoading = true);

      final response = await supabase
          .from('workforce_assignments')
          .select('''
            id,
            role,
            assignment_status,
            assigned_at,
            profiles!workforce_assignments_workforce_id_fkey (
              id,
              full_name,
              employee_id,
              role,
              phone,
              photo_url
            )
          ''')
          .eq('event_id', widget.eventId)
          .eq('role', widget.role.trim().toLowerCase().replaceAll(' ', '_'))
          .order('assigned_at', ascending: false);

      setState(() {
        assignments = List<Map<String, dynamic>>.from(response);
      });

      _listAnimController.forward(from: 0);
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) _showErrorSnackbar(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: const Color(0xFFEF4444),
        content: Row(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Gagal memuat data assignments.',
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _StatusConfig _getStatusConfig(String status) {
    switch (status) {
      case 'checked_in':
        return _StatusConfig(
          color: const Color(0xFF16A34A),
          bgColor: const Color(0xFFDCFCE7),
          icon: Icons.check_circle_rounded,
          label: 'Checked In',
        );
      case 'late':
        return _StatusConfig(
          color: const Color(0xFFD97706),
          bgColor: const Color(0xFFFEF3C7),
          icon: Icons.access_time_rounded,
          label: 'Terlambat',
        );
      case 'absent':
        return _StatusConfig(
          color: const Color(0xFFDC2626),
          bgColor: const Color(0xFFFEE2E2),
          icon: Icons.cancel_rounded,
          label: 'Absen',
        );
      default:
        return _StatusConfig(
          color: const Color(0xFF2563EB),
          bgColor: const Color(0xFFDDEAFE),
          icon: Icons.assignment_turned_in_rounded,
          label: 'Ditugaskan',
        );
    }
  }

  Map<String, int> get _statusSummary {
    final summary = <String, int>{
      'assigned': 0,
      'checked_in': 0,
      'late': 0,
      'absent': 0,
    };
    for (final a in assignments) {
      final s = a['assignment_status'] ?? 'assigned';
      summary[s] = (summary[s] ?? 0) + 1;
    }
    return summary;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final roleLabel = widget.role
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildSliverAppBar(
            context,
            colorScheme,
            roleLabel,
            innerBoxIsScrolled,
          ),
        ],
        body: _buildBody(colorScheme, roleLabel),
      ),
    );
  }

  Widget _buildSliverAppBar(
    BuildContext context,
    ColorScheme colorScheme,
    String roleLabel,
    bool innerBoxIsScrolled,
  ) {
    return SliverAppBar(
      expandedHeight: isLoading ? 100 : 200,
      pinned: true,
      floating: false,
      elevation: innerBoxIsScrolled ? 2 : 0,
      shadowColor: Colors.black12,
      backgroundColor: colorScheme.primary,
      leading: IconButton(
        onPressed: () => Navigator.of(context).maybePop(),
        icon: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 16,
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: loadAssignments,
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(
                    Icons.refresh_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
          ),
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        title: AnimatedOpacity(
          opacity: innerBoxIsScrolled ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Text(
            '$roleLabel Assignments',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        centerTitle: true,
        background: _buildHeaderBackground(colorScheme, roleLabel),
      ),
    );
  }

  Widget _buildHeaderBackground(ColorScheme colorScheme, String roleLabel) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            HSLColor.fromColor(colorScheme.primary)
                .withHue(
                  (HSLColor.fromColor(colorScheme.primary).hue + 20) % 360,
                )
                .toColor(),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'REVIEW PENUGASAN',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  roleLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                  ),
                ),
                if (!isLoading && assignments.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${assignments.length} personil ditugaskan',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(ColorScheme colorScheme, String roleLabel) {
    if (isLoading) return _buildShimmer();
    if (assignments.isEmpty) return _buildEmptyState(colorScheme, roleLabel);

    return RefreshIndicator(
      onRefresh: loadAssignments,
      color: colorScheme.primary,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        itemCount: assignments.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _buildSummaryRow(colorScheme),
            );
          }

          final i = index - 1;
          final assignment = assignments[i];
          final profile = assignment['profiles'] as Map<String, dynamic>? ?? {};
          final status = assignment['assignment_status'] ?? 'assigned';
          final statusConfig = _getStatusConfig(status);

          return _buildAnimatedCard(
            i,
            assignment,
            profile,
            status,
            statusConfig,
            colorScheme,
          );
        },
      ),
    );
  }

  Widget _buildSummaryRow(ColorScheme colorScheme) {
    final summary = _statusSummary;
    final items = [
      _SummaryItem(
        'Total',
        assignments.length,
        colorScheme.primary,
        Icons.people_rounded,
      ),
      _SummaryItem(
        'Hadir',
        summary['checked_in'] ?? 0,
        const Color(0xFF16A34A),
        Icons.check_circle_rounded,
      ),
      _SummaryItem(
        'Terlambat',
        summary['late'] ?? 0,
        const Color(0xFFD97706),
        Icons.access_time_rounded,
      ),
      _SummaryItem(
        'Absen',
        summary['absent'] ?? 0,
        const Color(0xFFDC2626),
        Icons.cancel_rounded,
      ),
    ];

    return Row(
      children: items
          .map(
            (item) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: item.color.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(item.icon, color: item.color, size: 20),
                      const SizedBox(height: 6),
                      Text(
                        '${item.count}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: item.color,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildAnimatedCard(
    int index,
    Map<String, dynamic> assignment,
    Map<String, dynamic> profile,
    String status,
    _StatusConfig statusConfig,
    ColorScheme colorScheme,
  ) {
    final assignedAt = assignment['assigned_at'] != null
        ? DateTime.tryParse(assignment['assigned_at'].toString())
        : null;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 350 + (index * 70)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Transform.translate(
        offset: Offset(0, 24 * (1 - value)),
        child: Opacity(opacity: value, child: child),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                /// AVATAR
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: colorScheme.primary.withOpacity(0.1),
                      backgroundImage: profile['photo_url'] != null
                          ? NetworkImage(profile['photo_url'])
                          : null,
                      child: profile['photo_url'] == null
                          ? Text(
                              _getInitials(profile['full_name']),
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: statusConfig.color,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 14),

                /// INFO
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile['full_name'] ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A2E),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(
                            Icons.badge_outlined,
                            size: 12,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            profile['employee_id'] ?? '-',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.phone_outlined,
                            size: 12,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            profile['phone'] ?? '-',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                      if (assignedAt != null) ...[
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 12,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatDate(assignedAt),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                /// STATUS BADGE
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusConfig.bgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        statusConfig.icon,
                        color: statusConfig.color,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        statusConfig.label,
                        style: TextStyle(
                          color: statusConfig.color,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      itemCount: 6,
      itemBuilder: (_, index) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _ShimmerBox(height: index == 0 ? 80 : 90, borderRadius: 16),
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme, String roleLabel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_search_rounded,
                size: 42,
                color: colorScheme.primary.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Belum Ada Penugasan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Belum ada personil yang ditugaskan\nsebagai $roleLabel.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            OutlinedButton.icon(
              onPressed: loadAssignments,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Muat Ulang'),
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.primary,
                side: BorderSide(color: colorScheme.primary),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  String _formatDate(DateTime date) {
    final months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }
}

// ─── Helper classes ───────────────────────────────────────────────────────────

class _StatusConfig {
  final Color color;
  final Color bgColor;
  final IconData icon;
  final String label;

  const _StatusConfig({
    required this.color,
    required this.bgColor,
    required this.icon,
    required this.label,
  });
}

class _SummaryItem {
  final String label;
  final int count;
  final Color color;
  final IconData icon;

  const _SummaryItem(this.label, this.count, this.color, this.icon);
}

class _ShimmerBox extends StatefulWidget {
  final double height;
  final double borderRadius;

  const _ShimmerBox({required this.height, this.borderRadius = 12});

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.4,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => Container(
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: Colors.grey.shade300.withOpacity(_animation.value),
        ),
      ),
    );
  }
}
