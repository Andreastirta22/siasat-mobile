import 'package:flutter/material.dart';

import '../../../../workforce_identity/controllers/workforce_identity_controller.dart';
import '../../../../workforce_identity/models/identity_check_result.dart';
import '../../../../workforce_identity/presentation/pages/existing_employee_page.dart';
import '../../../../workforce_identity/presentation/pages/register_new_employee_page.dart';
import '../../../../workforce_identity/presentation/pages/rehire_employee_page.dart';
import '../../../../workforce_identity/presentation/widgets/blacklist_warning_card.dart';
import '../../../../workforce_identity/presentation/widgets/verification_loading_step.dart';

class CreateEmployeePage extends StatefulWidget {
  const CreateEmployeePage({super.key});

  @override
  State<CreateEmployeePage> createState() => _CreateEmployeePageState();
}

class _CreateEmployeePageState extends State<CreateEmployeePage> {
  final nikController = TextEditingController();

  final WorkforceIdentityController controller = WorkforceIdentityController();

  bool isLoading = false;

  final List<String> loadingSteps = [
    'Checking blacklist records...',
    'Checking workforce identity...',
    'Checking employment history...',
    'Checking authentication account...',
    'Preparing workforce flow...',
  ];

  int currentStep = 0;

  @override
  void dispose() {
    nikController.dispose();
    super.dispose();
  }

  Future<void> checkNationalId() async {
    final nik = nikController.text.trim();

    if (nik.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('National ID (NIK) is required')),
      );

      return;
    }

    setState(() {
      isLoading = true;
      currentStep = 0;
    });

    try {
      for (int i = 0; i < loadingSteps.length; i++) {
        await Future.delayed(const Duration(milliseconds: 500));

        if (!mounted) return;

        setState(() {
          currentStep = i;
        });
      }

      final IdentityCheckResult result = await controller.verifyIdentity(nik);

      if (!mounted) return;

      /// BLACKLIST
      if (result.isBlacklisted) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) {
            return const BlacklistWarningCard();
          },
        );

        return;
      }

      /// EXISTING EMPLOYEE
      if (result.employeeExists) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ExistingEmployeePage(result: result),
          ),
        );

        return;
      }

      /// REHIRE FLOW
      if (result.authExists && result.employmentStatus == 'resigned') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RehireEmployeePage(result: result)),
        );

        return;
      }

      /// NEW EMPLOYEE
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RegisterNewEmployeePage(nationalId: nik),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Identity verification failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget buildVerificationSection() {
    return Column(
      children: [
        for (int i = 0; i < loadingSteps.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: VerificationLoadingStep(
              title: loadingSteps[i],
              isActive: currentStep == i,
              isCompleted: currentStep > i,
            ),
          ),
      ],
    );
  }

  Widget buildInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'National Workforce Verification',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),

        Text(
          'Verify workforce identity before employee onboarding and operational activation.',
          style: TextStyle(color: Colors.grey.shade600, height: 1.5),
        ),

        const SizedBox(height: 32),

        TextField(
          controller: nikController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'National ID (NIK)',
            hintText: 'Enter workforce national identity number',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            prefixIcon: const Icon(Icons.badge_outlined),
          ),
        ),

        const SizedBox(height: 24),

        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton.icon(
            onPressed: isLoading ? null : checkNationalId,
            icon: const Icon(Icons.verified_user_outlined),
            label: const Text('Verify Workforce Identity'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Employee')),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),

            child: isLoading ? buildVerificationSection() : buildInputSection(),
          ),
        ),
      ),
    );
  }
}
