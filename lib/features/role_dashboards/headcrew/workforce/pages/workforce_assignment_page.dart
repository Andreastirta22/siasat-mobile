// pages/workforce_assignment_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WorkforceAssignmentPage extends StatefulWidget {
  final String eventId;
  final String role;

  const WorkforceAssignmentPage({
    super.key,
    required this.eventId,
    required this.role,
  });

  @override
  State<WorkforceAssignmentPage> createState() =>
      _WorkforceAssignmentPageState();
}

class _WorkforceAssignmentPageState extends State<WorkforceAssignmentPage> {
  final supabase = Supabase.instance.client;

  final TextEditingController nikController = TextEditingController();

  bool isLoading = false;

  Map<String, dynamic>? workforceData;

  String? infoMessage;

  /// =========================
  /// CHECK WORKFORCE
  /// =========================
  Future<void> checkWorkforce() async {
    final nik = nikController.text.trim();

    /// EMPTY VALIDATION
    if (nik.isEmpty) {
      setState(() {
        infoMessage = 'National ID (NIK) wajib diisi';

        workforceData = null;
      });

      return;
    }

    /// NUMERIC VALIDATION
    if (!RegExp(r'^[0-9]+$').hasMatch(nik)) {
      setState(() {
        infoMessage = 'NIK hanya boleh berisi angka';

        workforceData = null;
      });

      return;
    }

    /// NIK LENGTH VALIDATION
    if (nik.length != 16) {
      setState(() {
        infoMessage = 'NIK harus terdiri dari 16 digit angka';

        workforceData = null;
      });

      return;
    }

    setState(() {
      isLoading = true;
      infoMessage = null;
      workforceData = null;
    });

    try {
      final response = await supabase
          .from('profiles')
          .select()
          .eq('national_id', nik)
          .maybeSingle();

      /// =========================
      /// WORKFORCE NOT FOUND
      /// =========================
      if (response == null) {
        setState(() {
          infoMessage = 'Workforce belum terdaftar';
        });

        return;
      }

      /// =========================
      /// EMPLOYMENT VALIDATION
      /// =========================
      final employmentStatus = (response['employment_status'] ?? '')
          .toString()
          .trim();

      if (employmentStatus != 'active') {
        setState(() {
          infoMessage = 'Workforce tidak aktif';
        });

        return;
      }

      /// =========================
      /// ROLE VALIDATION
      /// =========================
      final profileRole = (response['role'] ?? '')
          .toString()
          .trim()
          .toLowerCase();

      final expectedRole = widget.role.trim().toLowerCase().replaceAll(
        ' ',
        '_',
      );

      if (profileRole != expectedRole) {
        setState(() {
          infoMessage = 'Orang ini bukan terdaftar sebagai ${widget.role}';
        });

        return;
      }

      /// =========================
      /// BLACKLIST VALIDATION
      /// =========================
      final isBlacklisted = response['is_blacklisted'] == true;

      if (isBlacklisted) {
        setState(() {
          infoMessage = 'Workforce diblacklist';
        });

        return;
      }

      /// =========================
      /// SUCCESS
      /// =========================
      setState(() {
        workforceData = response;
      });
    } catch (e) {
      setState(() {
        infoMessage = 'Terjadi kesalahan saat validasi workforce';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// =========================
  /// ASSIGN WORKFORCE
  /// =========================
  Future<void> assignWorkforce() async {
    if (workforceData == null) return;

    try {
      setState(() {
        isLoading = true;
      });

      /// CHECK EXISTING ASSIGNMENT
      final existingAssignment = await supabase
          .from('workforce_assignments')
          .select()
          .eq('event_id', widget.eventId)
          .eq('workforce_id', workforceData!['id'])
          .maybeSingle();

      if (existingAssignment != null) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Workforce sudah diassign ke event ini'),
          ),
        );

        return;
      }

      /// GET CURRENT HEADCREW PROFILE
      final currentProfile = await supabase
          .from('profiles')
          .select('id')
          .eq('id', supabase.auth.currentUser!.id)
          .single();

      /// INSERT ASSIGNMENT
      await supabase.from('workforce_assignments').insert({
        'event_id': widget.eventId,

        'headcrew_id': currentProfile['id'],

        'workforce_id': workforceData!['id'],

        'role': widget.role.trim().toLowerCase().replaceAll(' ', '_'),

        'assignment_status': 'assigned',
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Workforce berhasil diassign')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal assign workforce: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    nikController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final roleTitle = widget.role;

    return Scaffold(
      appBar: AppBar(title: Text('Assign $roleTitle')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// =========================
            /// TITLE
            /// =========================
            Text(
              'Workforce Identity Validation',
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: 12),

            Text(
              'Masukkan NIK workforce untuk validasi identitas sebelum assignment.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            const SizedBox(height: 32),

            /// =========================
            /// NIK INPUT
            /// =========================
            TextField(
              controller: nikController,

              keyboardType: TextInputType.number,

              decoration: const InputDecoration(
                labelText: 'National ID (NIK)',

                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            /// =========================
            /// CHECK BUTTON
            /// =========================
            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: isLoading ? null : checkWorkforce,

                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,

                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Check Workforce'),
              ),
            ),

            const SizedBox(height: 24),

            /// =========================
            /// INFO MESSAGE
            /// =========================
            if (infoMessage != null)
              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),

                  borderRadius: BorderRadius.circular(16),
                ),

                child: Text(
                  infoMessage!,

                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),

            /// =========================
            /// REGISTER WORKFORCE
            /// =========================
            if (infoMessage == 'Workforce belum terdaftar')
              Padding(
                padding: const EdgeInsets.only(top: 16),

                child: SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    onPressed: () {
                      context.push(
                        '/headcrew/register-workforce',

                        extra: {
                          'nationalId': nikController.text.trim(),

                          'role': widget.role,
                        },
                      );
                    },

                    child: const Text('Register Workforce'),
                  ),
                ),
              ),

            /// =========================
            /// WORKFORCE DATA
            /// =========================
            if (workforceData != null)
              Padding(
                padding: const EdgeInsets.only(top: 24),

                child: Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),

                    border: Border.all(color: Colors.green),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        'Workforce Validated',

                        style: Theme.of(context).textTheme.headlineSmall,
                      ),

                      const SizedBox(height: 24),

                      /// FULL NAME
                      Text(
                        'Full Name: '
                        '${workforceData!['full_name'] ?? '-'}',
                      ),

                      const SizedBox(height: 12),

                      /// EMPLOYEE ID
                      Text(
                        'Employee ID: '
                        '${workforceData!['employee_id'] ?? '-'}',
                      ),

                      const SizedBox(height: 12),

                      /// ROLE
                      Text(
                        'Role: '
                        '${workforceData!['role'] ?? '-'}',
                      ),

                      const SizedBox(height: 12),

                      /// EMPLOYMENT STATUS
                      Text(
                        'Employment Status: '
                        '${workforceData!['employment_status'] ?? '-'}',
                      ),

                      const SizedBox(height: 32),

                      /// ASSIGN BUTTON
                      SizedBox(
                        width: double.infinity,

                        child: ElevatedButton(
                          onPressed: isLoading ? null : assignWorkforce,

                          child: const Text('Assign Workforce'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
