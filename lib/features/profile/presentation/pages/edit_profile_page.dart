import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../models/user_model.dart';
import '../../../../services/employee_id_service.dart';
import '../../../../services/supabase/profile_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final ProfileService _profileService = ProfileService();

  UserModel? user;

  late TextEditingController fullNameController;
  late TextEditingController nationalIdController;
  late TextEditingController phoneController;
  late TextEditingController bankAccountNumberController;
  late TextEditingController bankAccountHolderController;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadProfile();
  }

  Future<void> loadProfile() async {
    final profile = await _profileService.getCurrentProfile();

    if (profile == null) {
      return;
    }

    fullNameController = TextEditingController(text: profile.fullName);

    nationalIdController = TextEditingController(
      text: profile.nationalId ?? '',
    );

    phoneController = TextEditingController(text: profile.phone ?? '');

    bankAccountNumberController = TextEditingController(
      text: profile.bankAccountNumber ?? '',
    );

    bankAccountHolderController = TextEditingController(
      text: profile.bankAccountHolder ?? '',
    );

    setState(() {
      user = profile;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    fullNameController.dispose();
    nationalIdController.dispose();
    phoneController.dispose();
    bankAccountNumberController.dispose();
    bankAccountHolderController.dispose();

    super.dispose();
  }

  bool validateFields() {
    return fullNameController.text.trim().isNotEmpty &&
        nationalIdController.text.trim().isNotEmpty &&
        phoneController.text.trim().isNotEmpty &&
        bankAccountNumberController.text.trim().isNotEmpty &&
        bankAccountHolderController.text.trim().isNotEmpty;
  }

  Future<void> showSubmitConfirmation() async {
    if (!validateFields()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Please complete all required information.'),
        ),
      );

      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF171A23),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          title: const Text(
            'Confirm Profile Submission',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),

          content: const Text(
            'Please ensure all information entered is correct.\n\n'
            'Profile data can only be completed once and some information may not be editable afterward.',
            style: TextStyle(color: Colors.white70, height: 1.5),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text(
                'Review Again',
                style: TextStyle(color: Colors.grey),
              ),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),

              onPressed: () {
                Navigator.pop(context, true);
              },

              child: const Text('Submit'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      saveProfile();
    }
  }

  Future<void> saveProfile() async {
    setState(() {
      isLoading = true;
    });

    try {
      final role = user!.role;

      /// =========================
      /// ROLE CLASSIFICATION
      /// =========================

      final bool isFreelance =
          role == 'crew' ||
          role == 'coach' ||
          role == 'ring_guard' ||
          role == 'medic' ||
          role == 'cashier';

      /// =========================
      /// TEMP SEQUENCE
      /// =========================

      /// TODO:
      /// Replace with real DB sequence logic later
      const sequence = 1;

      /// =========================
      /// GENERATE EMPLOYEE ID
      /// =========================

      late final String generatedEmployeeId;

      if (isFreelance) {
        generatedEmployeeId = EmployeeIdService.generateFreelanceWorkforceId(
          role: role,
          nationalId: nationalIdController.text.trim(),
          sequence: sequence,
        );
      } else {
        generatedEmployeeId = EmployeeIdService.generateManagementEmployeeId(
          companyCode: 'AFCO',
          role: role,
          sequence: sequence,
        );
      }

      /// =========================
      /// UPDATE PROFILE
      /// =========================

      final updatedUser = user!.copyWith(
        fullName: fullNameController.text.trim(),

        /// IDENTITY
        nationalId: nationalIdController.text.trim(),

        phone: phoneController.text.trim(),

        /// BANK
        bankName: 'Bank Central Asia',

        bankAccountNumber: bankAccountNumberController.text.trim(),

        bankAccountHolder: bankAccountHolderController.text.trim(),

        /// EMPLOYEE ID
        employeeId: generatedEmployeeId,

        /// STATUS
        employmentStatus: 'active',

        joinedAt: DateTime.now(),
      );

      await _profileService.updateProfile(updatedUser);

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile completed\nEmployee ID: $generatedEmployeeId'),
        ),
      );

      /// =========================
      /// ROLE REDIRECT
      /// =========================

      if (role == 'founder') {
        context.go('/founder');
      } else if (role == 'principal') {
        context.go('/principal');
      } else if (role == 'event_manager') {
        context.go('/event-manager');
      } else if (role == 'headcrew') {
        context.go('/headcrew');
      } else if (role == 'coach') {
        context.go('/coach');
      } else {
        context.go('/crew');
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Failed to complete profile\n$e'),
        ),
      );
    }
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 10),

        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,

          style: const TextStyle(color: Colors.white),

          decoration: InputDecoration(
            hintText: hintText,

            hintStyle: const TextStyle(color: Colors.white38),

            filled: true,
            fillColor: const Color(0xFF171A23),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
          ),
        ),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget buildBankField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bank Name',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 10),

        Container(
          width: double.infinity,

          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),

          decoration: BoxDecoration(
            color: const Color(0xFF171A23),
            borderRadius: BorderRadius.circular(18),
          ),

          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,

                padding: const EdgeInsets.all(6),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Image.asset(
                  'assets/logos/bca_logo.png',
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(width: 14),

              const Text(
                'Bank Central Asia',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),

      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || user == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF0F1115),

        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1115),
        elevation: 0,

        title: const Text(
          'Complete Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// PERSONAL INFORMATION
            buildSectionTitle('Personal Information'),

            buildTextField(label: 'Full Name', controller: fullNameController),

            buildTextField(
              label: 'National ID (NIK)',
              controller: nationalIdController,
              keyboardType: TextInputType.number,
            ),

            buildTextField(
              label: 'Phone Number',
              controller: phoneController,
              keyboardType: TextInputType.phone,
            ),

            /// BANK INFORMATION
            buildSectionTitle('Bank Information'),

            buildBankField(),

            buildTextField(
              label: 'Account Number',
              controller: bankAccountNumberController,
              keyboardType: TextInputType.number,
              hintText: 'Please enter the correct account number',
            ),

            buildTextField(
              label: 'Account Holder Name',
              controller: bankAccountHolderController,
              hintText: 'Please enter the correct account holder name',
            ),

            /// KTP PLACEHOLDER
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: const Color(0xFF171A23),
                borderRadius: BorderRadius.circular(18),
              ),

              child: Column(
                children: const [
                  Icon(Icons.badge_outlined, color: Colors.white70, size: 40),

                  SizedBox(height: 12),

                  Text(
                    'KTP Photo Upload\nComing Soon',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 58,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),

                onPressed: isLoading ? null : showSubmitConfirmation,

                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Submit Profile',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
