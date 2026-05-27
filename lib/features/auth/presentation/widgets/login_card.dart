import 'package:flutter/material.dart';

class LoginCard extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool isLoading;
  final VoidCallback onTogglePassword;
  final VoidCallback onSignIn;

  const LoginCard({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.isLoading,
    required this.onTogglePassword,
    required this.onSignIn,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: const Color(0xFF252525)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 40,
              offset: const Offset(0, 16),
            ),
            BoxShadow(
              color: const Color(0xFFF5A623).withOpacity(0.04),
              blurRadius: 60,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5A623).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'SIGN IN',
                    style: TextStyle(
                      color: Color(0xFFF5A623),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              'Masuk ke\nworkspace kamu.',
              style: TextStyle(
                color: Color(0xFFF5F5F5),
                fontSize: 28,
                fontWeight: FontWeight.w800,
                height: 1.2,
                letterSpacing: -0.8,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Gunakan akun SIASAT yang telah terdaftar.',
              style: TextStyle(
                color: Color(0xFF5A5A5A),
                fontSize: 13,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 32),

            // ── Divider ──
            Container(height: 1, color: const Color(0xFF1E1E1E)),

            const SizedBox(height: 28),

            // ── Email ──
            _buildLabel('Email Address'),
            const SizedBox(height: 10),
            _buildTextField(
              controller: emailController,
              hint: 'you@siasat.app',
              prefixIcon: Icons.alternate_email_rounded,
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 20),

            // ── Password ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLabel('Password'),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'Lupa password?',
                    style: TextStyle(
                      color: Color(0xFFF5A623),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildTextField(
              controller: passwordController,
              hint: '••••••••',
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: obscurePassword,
              suffix: GestureDetector(
                onTap: onTogglePassword,
                child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(
                    obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: const Color(0xFF5A5A5A),
                    size: 20,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ── Sign In Button ──
            SizedBox(
              width: double.infinity,
              height: 58,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: isLoading
                      ? null
                      : const LinearGradient(
                          colors: [Color(0xFFF5A623), Color(0xFFE8911A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  color: isLoading ? const Color(0xFF2A2A2A) : null,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: isLoading
                      ? null
                      : [
                          BoxShadow(
                            color: const Color(0xFFF5A623).withOpacity(0.30),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                ),
                child: ElevatedButton(
                  onPressed: isLoading ? null : onSignIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: const Color(0xFF0E0E0E),
                    elevation: 0,
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
                            color: Color(0xFFF5A623),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Masuk Sekarang',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.3,
                                color: Color(0xFF0E0E0E),
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 18,
                              color: Color(0xFF0E0E0E),
                            ),
                          ],
                        ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            // ── Divider ──
            Container(height: 1, color: const Color(0xFF1E1E1E)),

            const SizedBox(height: 20),

            // ── Footer ──
            Row(
              children: [
                const Icon(
                  Icons.mail_outline_rounded,
                  color: Color(0xFF4A4A4A),
                  size: 16,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Ingin bergabung? ',
                  style: TextStyle(color: Color(0xFF5A5A5A), fontSize: 13),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'Hubungi kami',
                    style: TextStyle(
                      color: Color(0xFFF5A623),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        color: Color(0xFF5A5A5A),
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: Color(0xFFF0F0F0),
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF3A3A3A), fontSize: 14),
        prefixIcon: Icon(prefixIcon, color: const Color(0xFF4A4A4A), size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFF0E0E0E),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF222222)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF222222)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFF5A623), width: 1.5),
        ),
      ),
    );
  }
}
