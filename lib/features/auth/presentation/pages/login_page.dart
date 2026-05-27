import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../services/supabase/auth_service.dart';
import '../widgets/hero_section.dart';
import '../widgets/feature_highlight_section.dart';
import '../widgets/event_showcase_section.dart';
import '../widgets/testimonial_section.dart';
import '../widgets/login_card.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool _obscurePassword = true;

  late AnimationController _animController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeIn = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    );
    _slideUp = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animController,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
          ),
        );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    try {
      setState(() => isLoading = true);

      await _authService.signIn(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final profile = await _authService.getCurrentProfile();

      if (!mounted) return;

      final String role = (profile['role'] ?? '').toString().trim();
      final bool isCoreRole = role == 'founder' || role == 'principal';

      if (!isCoreRole && profile['employee_id'] == null) {
        context.go('/complete-profile');
        return;
      }

      switch (profile['role']) {
        case 'principal':
          context.go('/principal');
          break;
        case 'founder':
          context.go('/founder');
          break;
        case 'event_manager':
          context.go('/event-manager');
          break;
        case 'headcrew':
          context.go('/headcrew');
          break;
        case 'coach':
          context.go('/coach');
          break;
        default:
          context.go('/crew');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Color(0xFFF5A623),
                size: 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  e.toString(),
                  style: const TextStyle(
                    color: Color(0xFFF0F0F0),
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF1A1A1A),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: Color(0xFF2A2A2A), width: 1),
          ),
          elevation: 0,
        ),
      );
    }

    if (mounted) setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          // ── Background: subtle dot grid ──
          Positioned.fill(child: CustomPaint(painter: _GridPainter())),

          // ── Ambient glow: top-left amber ──
          Positioned(
            top: -140,
            left: -100,
            child: Container(
              width: 380,
              height: 380,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFF5A623).withOpacity(0.14),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Ambient glow: bottom-right purple ──
          Positioned(
            bottom: -160,
            right: -120,
            child: Container(
              width: 340,
              height: 340,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF7C4DFF).withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Main scrollable content ──
          SafeArea(
            child: FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: _slideUp,
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          // Hero
                          HeroSection(),

                          const SizedBox(height: 44),

                          // Login Card
                          LoginCard(
                            emailController: emailController,
                            passwordController: passwordController,
                            obscurePassword: _obscurePassword,
                            isLoading: isLoading,
                            onTogglePassword: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            onSignIn: signIn,
                          ),

                          const SizedBox(height: 56),

                          // Section divider
                          _buildSectionDivider(),

                          const SizedBox(height: 48),

                          // Features
                          FeatureHighlightSection(),

                          const SizedBox(height: 56),

                          // Section divider
                          _buildSectionDivider(),

                          const SizedBox(height: 48),

                          // Events
                          EventShowcaseSection(),

                          const SizedBox(height: 56),

                          // Section divider
                          _buildSectionDivider(),

                          const SizedBox(height: 48),

                          // Testimonials
                          TestimonialSection(),

                          const SizedBox(height: 48),

                          // Footer
                          _buildFooter(),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        children: [
          Expanded(child: Container(height: 1, color: const Color(0xFF1A1A1A))),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: const Color(0xFFF5A623).withOpacity(0.4),
              shape: BoxShape.circle,
            ),
          ),
          Expanded(child: Container(height: 1, color: const Color(0xFF1A1A1A))),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          Container(height: 1, color: const Color(0xFF1A1A1A)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5A623),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.grid_view_rounded,
                      color: Color(0xFF0A0A0A),
                      size: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'SIASAT',
                    style: TextStyle(
                      color: Color(0xFF6A6A6A),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              const Text(
                '© 2025 SIASAT',
                style: TextStyle(color: Color(0xFF3A3A3A), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Subtle dot-grid background painter ──
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2A2A2A).withOpacity(0.35)
      ..strokeWidth = 1;

    const spacing = 32.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.0, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
