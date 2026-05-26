import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../services/supabase/supabase_service.dart';

class HeadcrewWorkforceRegisterPage extends StatefulWidget {
  final String nationalId;
  final String role;

  const HeadcrewWorkforceRegisterPage({
    super.key,
    required this.nationalId,
    required this.role,
  });

  @override
  State<HeadcrewWorkforceRegisterPage> createState() =>
      _HeadcrewWorkforceRegisterPageState();
}

class _HeadcrewWorkforceRegisterPageState
    extends State<HeadcrewWorkforceRegisterPage>
    with TickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;

  late final String verifiedNationalId;
  late final String lockedRole;

  late AnimationController fadeController;
  late AnimationController slideController;

  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();

    verifiedNationalId = widget.nationalId;

    lockedRole = widget.role.trim().toLowerCase().replaceAll(' ', '_');

    fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    fadeAnimation = CurvedAnimation(
      parent: fadeController,
      curve: Curves.easeOut,
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: slideController, curve: Curves.easeOut));

    fadeController.forward();
    slideController.forward();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    fadeController.dispose();
    slideController.dispose();

    super.dispose();
  }

  Future<void> registerWorkforce() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await SupabaseService.client.functions.invoke(
        'create-employee-account',
        body: {
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
          'role': lockedRole,
          'national_id': verifiedNationalId,
        },
      );

      if (response.data == null) {
        throw Exception('Failed to create workforce account');
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Workforce berhasil didaftarkan')),
      );

      context.pop(true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal register workforce: $e')));
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  String get roleLabel {
    switch (lockedRole) {
      case 'crew':
        return 'Crew';

      case 'coach':
        return 'Coach';

      case 'medic':
        return 'Medic';

      case 'cashier':
        return 'Cashier';

      case 'ring_guard':
        return 'Ring Guard';

      default:
        return lockedRole;
    }
  }

  IconData get roleIcon {
    switch (lockedRole) {
      case 'crew':
        return Icons.groups_rounded;

      case 'coach':
        return Icons.sports_rounded;

      case 'medic':
        return Icons.medical_services_rounded;

      case 'cashier':
        return Icons.point_of_sale_rounded;

      case 'ring_guard':
        return Icons.shield_rounded;

      default:
        return Icons.badge_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark
        ? const Color(0xFF0F1117)
        : const Color(0xFFF5F7FA);

    final cardColor = isDark ? const Color(0xFF1A1D27) : Colors.white;

    final primaryColor = const Color(0xFF4F6EF7);

    final successColor = const Color(0xFF00C896);

    final subtleTextColor = isDark ? Colors.white54 : const Color(0xFF7B8495);

    return Scaffold(
      backgroundColor: backgroundColor,

      body: FadeTransition(
        opacity: fadeAnimation,

        child: SlideTransition(
          position: slideAnimation,

          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                elevation: 0,
                expandedHeight: 120,
                backgroundColor: backgroundColor,

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
                    'Register Workforce',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),

                  child: Form(
                    key: formKey,

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          'Create workforce account for operational manpower assignment.',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: subtleTextColor,
                          ),
                        ),

                        const SizedBox(height: 28),

                        _VerifiedIdCard(
                          nationalId: verifiedNationalId,
                          cardColor: cardColor,
                          successColor: successColor,
                          isDark: isDark,
                        ),

                        const SizedBox(height: 28),

                        _SectionLabel(label: 'Account Details', isDark: isDark),

                        const SizedBox(height: 14),

                        _StyledTextField(
                          controller: emailController,
                          label: 'Email Address',
                          hint: 'you@company.com',
                          icon: Icons.alternate_email_rounded,
                          keyboardType: TextInputType.emailAddress,
                          cardColor: cardColor,
                          accentColor: primaryColor,
                          isDark: isDark,

                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Email wajib diisi';
                            }

                            if (!value.contains('@')) {
                              return 'Format email tidak valid';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        _StyledTextField(
                          controller: passwordController,
                          label: 'Password',
                          hint: '••••••••',
                          icon: Icons.lock_outline_rounded,
                          obscureText: obscurePassword,
                          cardColor: cardColor,
                          accentColor: primaryColor,
                          isDark: isDark,

                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },

                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                          ),

                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Password wajib diisi';
                            }

                            if (value.length < 6) {
                              return 'Password minimal 6 karakter';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 28),

                        _SectionLabel(label: 'Assigned Role', isDark: isDark),

                        const SizedBox(height: 14),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),

                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.08),

                            borderRadius: BorderRadius.circular(20),

                            border: Border.all(
                              color: primaryColor.withOpacity(0.2),
                            ),
                          ),

                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,

                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.15),

                                  borderRadius: BorderRadius.circular(14),
                                ),

                                child: Icon(roleIcon, color: primaryColor),
                              ),

                              const SizedBox(width: 16),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      roleLabel,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      'Role locked from manpower assignment',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: subtleTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Icon(Icons.lock_rounded, color: primaryColor),
                            ],
                          ),
                        ),

                        const SizedBox(height: 36),

                        _SubmitButton(
                          isLoading: isLoading,
                          onPressed: registerWorkforce,
                          accentColor: primaryColor,
                        ),

                        const SizedBox(height: 14),

                        SizedBox(
                          width: double.infinity,
                          height: 54,

                          child: TextButton(
                            onPressed: () => context.pop(),

                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: subtleTextColor,
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
    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(14),

      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,

        child: Icon(icon, color: isDark ? Colors.white : Colors.black),
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
      label,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: isDark ? Colors.white : Colors.black,
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
      width: double.infinity,
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
      ),

      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: successColor.withOpacity(0.15),

            child: Icon(Icons.verified_rounded, color: successColor),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  'Verified National ID',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white54 : Colors.black54,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  nationalId,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
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

  final Widget? suffixIcon;

  final bool obscureText;

  final TextInputType? keyboardType;

  final String? Function(String?)? validator;

  final Color cardColor;
  final Color accentColor;

  final bool isDark;

  const _StyledTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.cardColor,
    required this.accentColor,
    required this.isDark,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,

      style: TextStyle(color: isDark ? Colors.white : Colors.black),

      decoration: InputDecoration(
        labelText: label,
        hintText: hint,

        prefixIcon: Icon(icon, color: accentColor),

        suffixIcon: suffixIcon,

        filled: true,
        fillColor: cardColor,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),

          borderSide: BorderSide(color: accentColor, width: 1.5),
        ),
      ),
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

      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,

        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: accentColor,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),

        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,

                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : const Text(
                'Register Workforce',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
