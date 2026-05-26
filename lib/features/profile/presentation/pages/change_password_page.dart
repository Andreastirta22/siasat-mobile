import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../services/supabase/auth_service.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final AuthService _authService = AuthService();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _currentPasswordController =
      TextEditingController();

  final TextEditingController _newPasswordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool isLoading = false;

  bool obscureCurrentPassword = true;
  bool obscureNewPassword = true;
  bool obscureConfirmPassword = true;

  /// COOLDOWN
  bool canChangePassword = true;

  String cooldownText = '';

  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();

    loadCooldown();
  }

  @override
  void dispose() {
    countdownTimer?.cancel();

    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  /// LOAD COOLDOWN
  Future<void> loadCooldown() async {
    try {
      final profile = await _authService.getCurrentProfile();

      final passwordChangedAt = profile['password_changed_at'];

      if (passwordChangedAt == null) {
        setState(() {
          canChangePassword = true;
        });

        return;
      }

      final changedAt = DateTime.parse(passwordChangedAt).toUtc();

      startCountdown(changedAt);
    } catch (_) {}
  }

  /// START COUNTDOWN
  void startCountdown(DateTime changedAt) {
    countdownTimer?.cancel();

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {

      final nextAllowed = changedAt.add(const Duration(hours: 48));

      final remaining = nextAllowed.difference(DateTime.now().toUtc());

      if (remaining.isNegative) {
        countdownTimer?.cancel();

        if (mounted) {
          setState(() {
            canChangePassword = true;
            cooldownText = '';
          });
        }

        return;
      }

      final hours = remaining.inHours;

      final minutes = remaining.inMinutes % 60;

      final seconds = remaining.inSeconds % 60;

      if (mounted) {
        setState(() {
          canChangePassword = false;

          cooldownText = '$hours h $minutes m $seconds s';
        });
      }
    });
  }

  /// CHANGE PASSWORD
  Future<void> handleChangePassword() async {
    if (!_formKey.currentState!.validate()) return;

    if (!canChangePassword) return;

    setState(() {
      isLoading = true;
    });

    final result = await _authService.changePassword(
      currentPassword: _currentPasswordController.text.trim(),
      newPassword: _newPasswordController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    /// ERROR
    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result), backgroundColor: Colors.redAccent),
      );

      return;
    }

    /// SUCCESS
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password changed successfully'),
        backgroundColor: Colors.green,
      ),
    );

    /// REFRESH COOLDOWN
    await loadCooldown();

    /// CLEAR FIELD
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1115),

        elevation: 0,

        centerTitle: true,

        title: const Text(
          'Change Password',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const SizedBox(height: 10),

              const Text(
                'Update your account password',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                canChangePassword
                    ? 'You can change your password now'
                    : 'Next password change available in $cooldownText',
                style: TextStyle(
                  color: canChangePassword
                      ? Colors.greenAccent
                      : Colors.orangeAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 32),

              /// CURRENT PASSWORD
              buildPasswordField(
                controller: _currentPasswordController,
                label: 'Current Password',
                obscureText: obscureCurrentPassword,
                toggleVisibility: () {
                  setState(() {
                    obscureCurrentPassword = !obscureCurrentPassword;
                  });
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Current password is required';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              /// NEW PASSWORD
              buildPasswordField(
                controller: _newPasswordController,
                label: 'New Password',
                obscureText: obscureNewPassword,
                toggleVisibility: () {
                  setState(() {
                    obscureNewPassword = !obscureNewPassword;
                  });
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'New password is required';
                  }

                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }

                  if (value == _currentPasswordController.text.trim()) {
                    return 'New password must be different';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              /// CONFIRM PASSWORD
              buildPasswordField(
                controller: _confirmPasswordController,
                label: 'Confirm New Password',
                obscureText: obscureConfirmPassword,
                toggleVisibility: () {
                  setState(() {
                    obscureConfirmPassword = !obscureConfirmPassword;
                  });
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please confirm your password';
                  }

                  if (value.trim() != _newPasswordController.text.trim()) {
                    return 'Password does not match';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 40),

              /// BUTTON
              SizedBox(
                width: double.infinity,
                height: 58,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canChangePassword
                        ? Colors.blueAccent
                        : Colors.grey.shade700,

                    disabledBackgroundColor: Colors.grey.shade700,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),

                  onPressed: isLoading || !canChangePassword
                      ? null
                      : handleChangePassword,

                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          canChangePassword
                              ? 'Change Password'
                              : 'Cooldown Active',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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

  Widget buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback toggleVisibility,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,

      obscureText: obscureText,

      validator: validator,

      style: const TextStyle(color: Colors.white),

      decoration: InputDecoration(
        labelText: label,

        labelStyle: const TextStyle(color: Colors.white54),

        filled: true,
        fillColor: const Color(0xFF171A23),

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
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),

        suffixIcon: IconButton(
          onPressed: toggleVisibility,
          icon: Icon(
            obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: Colors.white54,
          ),
        ),
      ),
    );
  }
}
