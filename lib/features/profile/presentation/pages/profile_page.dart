import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/theme_provider.dart';
import '../../../../core/utils/role_formatter.dart';

import '../../../../models/user_model.dart';

import '../../../../services/supabase/auth_service.dart';
import '../../../../services/supabase/profile_service.dart';

import '../widgets/menu_tile.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_tile.dart';
import '../widgets/section_title.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();

  final ProfileService _profileService = ProfileService();

  UserModel? user;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadProfile();
  }

  Future<void> loadProfile() async {
    final profile = await _profileService.getCurrentProfile();

    setState(() {
      user = profile;
      isLoading = false;
    });
  }

  Future<void> logout() async {
    await _authService.signOut();

    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    /// BACKGROUND
    final backgroundColor = isDark
        ? const Color(0xFF0F1115)
        : const Color(0xFFF5F7FB);

    /// CARD
    final cardColor = isDark ? const Color(0xFF171A23) : Colors.white;

    /// TEXT
    final primaryTextColor = isDark ? Colors.white : Colors.black;

    /// SUBTITLE
    final secondaryTextColor = isDark ? Colors.white70 : Colors.black54;

    /// LOADING
    if (isLoading) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    /// PROFILE NOT FOUND
    if (user == null) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: Text(
            'Profile not found',
            style: TextStyle(color: primaryTextColor),
          ),
        ),
      );
    }

    final role = user!.role;

    /// EXECUTIVE
    final bool isExecutive = role == 'founder' || role == 'principal';

    /// MANAGEMENT
    final bool isManagement = role == 'event_manager' || role == 'headcrew';

    /// PAYROLL ROLE
    final bool isPayrollRole = role == 'crew' || role == 'coach';

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,

        title: Text(
          'Profile',
          style: TextStyle(
            color: primaryTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// HEADER
            ProfileHeader(
              name: user!.fullName.isEmpty ? 'CrewSync User' : user!.fullName,

              role: RoleFormatter.format(role),

              organization: isExecutive
                  ? 'CrewSync Executive Management'
                  : 'CrewSync Internal Management',
            ),

            const SizedBox(height: 30),

            /// =========================================
            /// EXECUTIVE PROFILE
            /// =========================================
            if (isExecutive) ...[
              const SectionTitle(title: 'Executive Information'),

              const SizedBox(height: 16),

              ProfileTile(
                icon: Icons.person_outline,
                title: 'Full Name',
                subtitle: user!.fullName.isEmpty ? '-' : user!.fullName,
              ),

              ProfileTile(
                icon: Icons.email_outlined,
                title: 'Email',
                subtitle: user!.email,
              ),

              const SizedBox(height: 30),

              const SectionTitle(title: 'Governance Access'),

              const SizedBox(height: 16),

              ProfileTile(
                icon: Icons.badge_outlined,
                title: 'Employee ID',
                subtitle: user!.employeeId ?? '-',
              ),

              ProfileTile(
                icon: Icons.business_center_outlined,
                title: 'Position',
                subtitle: RoleFormatter.format(role),
              ),
            ],

            /// =========================================
            /// MANAGEMENT PROFILE
            /// =========================================
            if (isManagement) ...[
              const SectionTitle(title: 'Management Information'),

              const SizedBox(height: 16),

              ProfileTile(
                icon: Icons.person_outline,
                title: 'Full Name',
                subtitle: user!.fullName,
              ),

              ProfileTile(
                icon: Icons.email_outlined,
                title: 'Email',
                subtitle: user!.email,
              ),

              ProfileTile(
                icon: Icons.phone_outlined,
                title: 'Phone Number',
                subtitle: user!.phone ?? '-',
              ),

              ProfileTile(
                icon: Icons.badge_outlined,
                title: 'National ID',
                subtitle: user!.nationalId ?? '-',
              ),

              const SizedBox(height: 30),

              const SectionTitle(title: 'Operational Access'),

              const SizedBox(height: 16),

              ProfileTile(
                icon: Icons.badge_outlined,
                title: 'Employee ID',
                subtitle: user!.employeeId ?? '-',
              ),

              ProfileTile(
                icon: Icons.business_center_outlined,
                title: 'Position',
                subtitle: RoleFormatter.format(role),
              ),
            ],

            /// =========================================
            /// PAYROLL PROFILE
            /// =========================================
            if (isPayrollRole) ...[
              const SectionTitle(title: 'Personal Information'),

              const SizedBox(height: 16),

              ProfileTile(
                icon: Icons.person_outline,
                title: 'Full Name',
                subtitle: user!.fullName,
              ),

              ProfileTile(
                icon: Icons.email_outlined,
                title: 'Email',
                subtitle: user!.email,
              ),

              ProfileTile(
                icon: Icons.phone_outlined,
                title: 'Phone Number',
                subtitle: user!.phone ?? '-',
              ),

              ProfileTile(
                icon: Icons.badge_outlined,
                title: 'National ID',
                subtitle: user!.nationalId ?? '-',
              ),

              const SizedBox(height: 30),

              const SectionTitle(title: 'Bank Information'),

              const SizedBox(height: 16),

              Container(
                margin: const EdgeInsets.only(bottom: 16),

                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: cardColor,

                  borderRadius: BorderRadius.circular(24),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.25 : 0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,

                      padding: const EdgeInsets.all(10),

                      decoration: BoxDecoration(
                        color: isDark ? Colors.white : const Color(0xFFF5F7FB),

                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: Image.asset(
                        'assets/logos/bca_logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(width: 18),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            'Bank Name',

                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 14,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            user!.bankName ?? '-',

                            style: TextStyle(
                              color: primaryTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              ProfileTile(
                icon: Icons.credit_card_outlined,
                title: 'Account Number',
                subtitle: user!.bankAccountNumber ?? '-',
              ),

              ProfileTile(
                icon: Icons.person_outline,
                title: 'Account Holder',
                subtitle: user!.bankAccountHolder ?? '-',
              ),

              const SizedBox(height: 30),

              const SectionTitle(title: 'Work Information'),

              const SizedBox(height: 16),

              ProfileTile(
                icon: Icons.badge_outlined,
                title: 'Employee ID',
                subtitle: user!.employeeId ?? '-',
              ),

              ProfileTile(
                icon: Icons.business_center_outlined,
                title: 'Position',
                subtitle: RoleFormatter.format(role),
              ),
            ],

            const SizedBox(height: 30),

            /// SETTINGS
            const SectionTitle(title: 'Settings'),

            const SizedBox(height: 16),

            /// NON EXECUTIVE ONLY
            if (!isExecutive)
              MenuTile(
                icon: const Icon(Icons.edit_outlined),

                title: 'Edit Profile',

                onTap: () {
                  context.push('/complete-profile');
                },
              ),

            /// CHANGE PASSWORD
            MenuTile(
              icon: const Icon(Icons.lock_outline),

              title: 'Change Password',

              onTap: () async {
                final profile = await _authService.getCurrentProfile();

                final passwordChangedAt = profile['password_changed_at'];

                if (passwordChangedAt != null) {
                  final changedAt = DateTime.parse(passwordChangedAt);

                  final nextAllowed = changedAt.add(const Duration(hours: 48));

                  final remaining = nextAllowed.toUtc().difference(
                    DateTime.now().toUtc(),
                  );

                  if (!remaining.isNegative) {
                    final hours = remaining.inHours;

                    final minutes = remaining.inMinutes % 60;

                    final seconds = remaining.inSeconds % 60;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'You can change your password again in '
                          '$hours h $minutes m $seconds s',
                        ),

                        backgroundColor: Colors.orange,
                      ),
                    );

                    return;
                  }
                }

                if (!mounted) return;

                context.push('/change-password');
              },
            ),

            /// NOTIFICATIONS
            MenuTile(
              icon: const Icon(Icons.notifications_none_rounded),
              title: 'Notifications',
              onTap: () {},
            ),

            MenuTile(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),

                transitionBuilder: (child, animation) {
                  return RotationTransition(
                    turns: animation,
                    child: ScaleTransition(scale: animation, child: child),
                  );
                },

                child: Icon(
                  isDark ? Icons.dark_mode : Icons.light_mode,
                  key: ValueKey(isDark),
                ),
              ),

              title: 'Dark Mode',

              showArrow: false,

              onTap: () {
                context.read<ThemeProvider>().toggleTheme();
              },
            ),

            const SizedBox(height: 30),

            /// SUPPORT
            const SectionTitle(title: 'Support'),

            const SizedBox(height: 16),

            MenuTile(
              icon: const Icon(Icons.help_outline),
              title: 'Help Center',
              onTap: () {},
            ),

            MenuTile(
              icon: const Icon(Icons.flag_outlined),
              title: 'Report Issue',
              onTap: () {},
            ),

            MenuTile(
              icon: const Icon(Icons.info_outline),
              title: 'About App',
              onTap: () {},
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 58,

              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),

                onPressed: logout,

                icon: const Icon(Icons.logout),

                label: const Text(
                  'Logout',

                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
