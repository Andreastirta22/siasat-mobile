// pages/manpower_filling_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/manpower_requirement_model.dart';
import '../services/manpower_filling_service.dart';
import '../widgets/manpower_progress_card.dart';
import '../widgets/manpower_requirement_card.dart';

class ManpowerFillingPage extends StatefulWidget {
  final String eventId;
  final String eventName;
  final String venueName;

  const ManpowerFillingPage({
    super.key,
    required this.eventId,
    required this.eventName,
    required this.venueName,
  });
  @override
  State<ManpowerFillingPage> createState() => _ManpowerFillingPageState();
}

class _ManpowerFillingPageState extends State<ManpowerFillingPage>
    with TickerProviderStateMixin {
  final ManpowerFillingService _service = ManpowerFillingService();
  final ScrollController _scrollController = ScrollController();

  bool isLoading = true;
  bool _isRefreshing = false;
  List<ManpowerRequirementModel> requirements = [];

  late AnimationController _fadeController;
  late AnimationController _headerAnimController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _headerSlideAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _headerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _headerSlideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _headerAnimController,
            curve: Curves.easeOutCubic,
          ),
        );

    loadRequirements();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _headerAnimController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> loadRequirements() async {
    try {
      final result = await _service.getEventManpowerRequirements(
        widget.eventId,
      );

      setState(() {
        requirements = result;
      });

      _headerAnimController.forward();
      _fadeController.forward();
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) _showErrorSnackbar();
    } finally {
      setState(() {
        isLoading = false;
        _isRefreshing = false;
      });
    }
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    _fadeController.reset();
    _headerAnimController.reset();
    await loadRequirements();
  }

  void _showErrorSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: const Color(0xFFEF4444),
        content: const Row(
          children: [
            Icon(Icons.wifi_off_rounded, color: Colors.white, size: 18),
            SizedBox(width: 10),
            Text(
              'Gagal memuat data. Tarik untuk refresh.',
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalRequired = _service.getTotalRequired(requirements);
    final totalAssigned = _service.getTotalAssigned(requirements);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildSliverAppBar(
            context,
            colorScheme,
            totalRequired,
            totalAssigned,
            innerBoxIsScrolled,
          ),
        ],
        body: _buildBody(colorScheme),
      ),
    );
  }

  Widget _buildSliverAppBar(
    BuildContext context,
    ColorScheme colorScheme,
    int totalRequired,
    int totalAssigned,
    bool innerBoxIsScrolled,
  ) {
    return SliverAppBar(
      expandedHeight: isLoading ? 120 : 220,
      floating: false,
      pinned: true,
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
        if (!isLoading)
          IconButton(
            onPressed: _handleRefresh,
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: _isRefreshing
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
        background: _buildAppBarBackground(
          colorScheme,
          totalRequired,
          totalAssigned,
        ),
        title: AnimatedOpacity(
          opacity: innerBoxIsScrolled ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Text(
            'Manpower Filling',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        centerTitle: true,
      ),
    );
  }

  Widget _buildAppBarBackground(
    ColorScheme colorScheme,
    int totalRequired,
    int totalAssigned,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.primary.withBlue(
              (colorScheme.primary.blue + 30).clamp(0, 255),
            ),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: -30,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          // Header content
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: SlideTransition(
              position: _headerSlideAnimation,
              child: FadeTransition(
                opacity: _headerAnimController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Manpower Filling',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.eventName} • ${widget.venueName}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                    if (!isLoading && requirements.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _buildCompactProgress(totalRequired, totalAssigned),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactProgress(int totalRequired, int totalAssigned) {
    final percent = totalRequired == 0 ? 0.0 : totalAssigned / totalRequired;
    final isComplete = totalAssigned >= totalRequired;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$totalAssigned / $totalRequired terpenuhi',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isComplete
                    ? Colors.greenAccent.withOpacity(0.25)
                    : Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isComplete ? '✓ Lengkap' : '${(percent * 100).toInt()}%',
                style: TextStyle(
                  color: isComplete ? Colors.greenAccent : Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: percent),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) => LinearProgressIndicator(
              value: value,
              minHeight: 6,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                isComplete ? Colors.greenAccent : Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(ColorScheme colorScheme) {
    if (isLoading) return _buildShimmerLoading();
    if (requirements.isEmpty) return _buildEmptyState(colorScheme);

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: colorScheme.primary,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
          itemCount: requirements.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ManpowerProgressCard(
                  totalRequired: _service.getTotalRequired(requirements),
                  totalAssigned: _service.getTotalAssigned(requirements),
                ),
              );
            }

            final requirement = requirements[index - 1];
            return _buildAnimatedCard(requirement, index - 1);
          },
        ),
      ),
    );
  }

  Widget _buildAnimatedCard(ManpowerRequirementModel requirement, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 80)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Transform.translate(
        offset: Offset(0, 20 * (1 - value)),
        child: Opacity(opacity: value, child: child),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: ManpowerRequirementCard(
          requirement: requirement,
          onAssign: () async {
            final result = await context.push(
              '/headcrew/workforce-assignment',
              extra: {'eventId': widget.eventId, 'role': requirement.role},
            );
            if (result == true) await loadRequirements();
          },
          onViewAssignments: () {
            context.push(
              '/headcrew/workforce-review',
              extra: {'eventId': widget.eventId, 'role': requirement.role},
            );
          },
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: _ShimmerBox(height: index == 0 ? 100 : 130, borderRadius: 16),
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
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
                Icons.people_outline_rounded,
                size: 44,
                color: colorScheme.primary.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Belum Ada Kebutuhan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Belum ada kebutuhan manpower\nuntuk event ini.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            OutlinedButton.icon(
              onPressed: _handleRefresh,
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
}

/// Simple shimmer placeholder widget
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
