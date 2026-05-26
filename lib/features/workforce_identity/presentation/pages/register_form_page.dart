import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../services/supabase/supabase_service.dart';

import '../../services/employee_governance_service.dart';

class RegisterFormPage extends StatefulWidget {
  final String nationalId;

  const RegisterFormPage({super.key, required this.nationalId});

  @override
  State<RegisterFormPage> createState() => _RegisterFormPageState();
}

class _RegisterFormPageState extends State<RegisterFormPage>
    with TickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final governanceService = EmployeeGovernanceService();
  final currentUserRole = 'event_manager';

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String selectedRole = 'crew';

  bool isLoading = false;
  bool obscurePassword = true;

  late final String verifiedNationalId;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  List<Map<String, dynamic>> get availableRoles {
    final allowedRoles = governanceService.getAvailableRoles(currentUserRole);

    final allRoles = [
      {
        'value': 'crew',
        'label': 'Crew',
        'icon': Icons.people_alt_rounded,
        'description': 'Field operational member',
      },
      {
        'value': 'coach',
        'label': 'Coach',
        'icon': Icons.sports_rounded,
        'description': 'Team trainer & mentor',
      },
      {
        'value': 'headcrew',
        'label': 'Head Crew',
        'icon': Icons.manage_accounts_rounded,
        'description': 'Senior crew leader',
      },
    ];

    return allRoles.where((role) {
      return allowedRoles.contains(role['value']);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    verifiedNationalId = widget.nationalId;

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> registerEmployee() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final response = await SupabaseService.client.functions.invoke(
        'create-employee-account',
        body: {
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
          'role': selectedRole,
          'national_id': verifiedNationalId,
        },
      );

      if (response.data == null) {
        throw Exception('Failed to create employee account');
      }

      if (!mounted) return;

      _showSuccessSnackbar('Employee account created successfully');

      context.pop();
    } catch (e) {
      _showErrorSnackbar(e.toString());
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(message),
          ],
        ),
        backgroundColor: const Color(0xFF00C896),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFFE53935),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF0F1117) : const Color(0xFFF5F7FA);
    final cardColor = isDark ? const Color(0xFF1A1D27) : Colors.white;
    final accentColor = const Color(0xFF4F6EF7);
    final successColor = const Color(0xFF00C896);
    final subtleTextColor = isDark
        ? Colors.white.withOpacity(0.45)
        : const Color(0xFF9AA3B2);

    return Scaffold(
      backgroundColor: bgColor,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: CustomScrollView(
            slivers: [
              /// ── APP BAR ──────────────────────────────────────────────
              SliverAppBar(
                backgroundColor: bgColor,
                elevation: 0,
                pinned: true,
                expandedHeight: 130,
                leading: Padding(
                  padding: const EdgeInsets.all(8),
                  child: _CircleIconButton(
                    icon: Icons.arrow_back_rounded,
                    onTap: () => context.pop(),
                    cardColor: cardColor,
                    isDark: isDark,
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  title: Text(
                    'New Employee',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF1A1D27),
                      letterSpacing: -0.5,
                    ),
                  ),
                  background: Container(color: bgColor),
                ),
              ),

              /// ── BODY ─────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create operational credentials\nfor a verified workforce identity.',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: subtleTextColor,
                          ),
                        ),

                        const SizedBox(height: 28),

                        /// ── VERIFIED ID CARD ──────────────────────────
                        _VerifiedIdCard(
                          nationalId: verifiedNationalId,
                          cardColor: cardColor,
                          successColor: successColor,
                          isDark: isDark,
                        ),

                        const SizedBox(height: 28),

                        /// ── SECTION LABEL ─────────────────────────────
                        _SectionLabel(label: 'Account Details', isDark: isDark),
                        const SizedBox(height: 14),

                        /// ── EMAIL ─────────────────────────────────────
                        _StyledTextField(
                          controller: emailController,
                          label: 'Email Address',
                          hint: 'you@company.com',
                          icon: Icons.alternate_email_rounded,
                          keyboardType: TextInputType.emailAddress,
                          cardColor: cardColor,
                          accentColor: accentColor,
                          isDark: isDark,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Email is required';
                            }
                            if (!value.contains('@')) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 14),

                        /// ── PASSWORD ──────────────────────────────────
                        _StyledTextField(
                          controller: passwordController,
                          label: 'Password',
                          hint: '••••••••',
                          icon: Icons.lock_outline_rounded,
                          obscureText: obscurePassword,
                          cardColor: cardColor,
                          accentColor: accentColor,
                          isDark: isDark,
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: subtleTextColor,
                              size: 20,
                            ),
                            onPressed: () => setState(
                              () => obscurePassword = !obscurePassword,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Password is required';
                            }
                            if (value.length < 6) {
                              return 'Minimum 6 characters';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 28),

                        /// ── ROLE SECTION ──────────────────────────────
                        _SectionLabel(label: 'Employee Role', isDark: isDark),
                        const SizedBox(height: 14),

                        _RoleSelector(
                          roles: availableRoles,
                          selectedRole: selectedRole,
                          onChanged: (value) =>
                              setState(() => selectedRole = value),
                          cardColor: cardColor,
                          accentColor: accentColor,
                          isDark: isDark,
                        ),

                        const SizedBox(height: 36),

                        /// ── SUBMIT BUTTON ─────────────────────────────
                        _SubmitButton(
                          isLoading: isLoading,
                          onPressed: registerEmployee,
                          accentColor: accentColor,
                        ),

                        const SizedBox(height: 14),

                        /// ── BACK BUTTON ───────────────────────────────
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: TextButton(
                            onPressed: () => context.pop(),
                            style: TextButton.styleFrom(
                              foregroundColor: subtleTextColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SUB-WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color cardColor;
  final bool isDark;

  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    required this.cardColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 20,
          color: isDark ? Colors.white : const Color(0xFF1A1D27),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final bool isDark;

  const _SectionLabel({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.4,
        color: isDark
            ? Colors.white.withOpacity(0.35)
            : const Color(0xFF9AA3B2),
      ),
    );
  }
}

class _VerifiedIdCard extends StatelessWidget {
  final String nationalId;
  final Color cardColor;
  final Color successColor;
  final bool isDark;

  const _VerifiedIdCard({
    required this.nationalId,
    required this.cardColor,
    required this.successColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: successColor.withOpacity(0.35), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: successColor.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: successColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.verified_user_rounded,
              color: successColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: successColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'VERIFIED',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: successColor,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'National ID',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? Colors.white.withOpacity(0.4)
                        : const Color(0xFF9AA3B2),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  nationalId,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF1A1D27),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final Color cardColor;
  final Color accentColor;
  final bool isDark;
  final String? Function(String?)? validator;

  const _StyledTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.cardColor,
    required this.accentColor,
    required this.isDark,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isDark
        ? Colors.white.withOpacity(0.08)
        : const Color(0xFFE8EBF0);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: isDark ? Colors.white : const Color(0xFF1A1D27),
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(
          color: isDark
              ? Colors.white.withOpacity(0.2)
              : const Color(0xFFBEC5CF),
        ),
        labelStyle: TextStyle(
          color: isDark
              ? Colors.white.withOpacity(0.45)
              : const Color(0xFF9AA3B2),
          fontSize: 14,
        ),
        prefixIcon: Icon(
          icon,
          size: 20,
          color: isDark
              ? Colors.white.withOpacity(0.45)
              : const Color(0xFF9AA3B2),
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: cardColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: borderColor, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: borderColor, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: accentColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE53935), width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE53935), width: 2),
        ),
      ),
    );
  }
}

class _RoleSelector extends StatelessWidget {
  final List<Map<String, dynamic>> roles;
  final String selectedRole;
  final ValueChanged<String> onChanged;
  final Color cardColor;
  final Color accentColor;
  final bool isDark;

  const _RoleSelector({
    required this.roles,
    required this.selectedRole,
    required this.onChanged,
    required this.cardColor,
    required this.accentColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: roles.map((role) {
        final isSelected = selectedRole == role['value'];
        final borderColor = isSelected
            ? accentColor
            : (isDark
                  ? Colors.white.withOpacity(0.08)
                  : const Color(0xFFE8EBF0));
        final bgColor = isSelected ? accentColor.withOpacity(0.07) : cardColor;

        return GestureDetector(
          onTap: () => onChanged(role['value'] as String),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: borderColor,
                width: isSelected ? 2 : 1.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: accentColor.withOpacity(0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? accentColor.withOpacity(0.15)
                        : (isDark
                              ? Colors.white.withOpacity(0.06)
                              : const Color(0xFFF0F2F5)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    role['icon'] as IconData,
                    size: 20,
                    color: isSelected
                        ? accentColor
                        : (isDark
                              ? Colors.white.withOpacity(0.4)
                              : const Color(0xFF9AA3B2)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        role['label'] as String,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? accentColor
                              : (isDark
                                    ? Colors.white
                                    : const Color(0xFF1A1D27)),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        role['description'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? Colors.white.withOpacity(0.4)
                              : const Color(0xFF9AA3B2),
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? accentColor
                          : (isDark
                                ? Colors.white.withOpacity(0.2)
                                : const Color(0xFFD0D5DD)),
                      width: 2,
                    ),
                    color: isSelected ? accentColor : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check_rounded,
                          size: 12,
                          color: Colors.white,
                        )
                      : null,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final Color accentColor;

  const _SubmitButton({
    required this.isLoading,
    required this.onPressed,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: isLoading
              ? null
              : LinearGradient(
                  colors: [
                    accentColor,
                    Color.lerp(accentColor, const Color(0xFF7C3AED), 0.5)!,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          color: isLoading ? accentColor.withOpacity(0.5) : null,
          boxShadow: isLoading
              ? []
              : [
                  BoxShadow(
                    color: accentColor.withOpacity(0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_add_alt_1_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
