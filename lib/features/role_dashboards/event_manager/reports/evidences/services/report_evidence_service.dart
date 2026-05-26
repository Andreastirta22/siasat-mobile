// evidences/services/report_evidence_service.dart

import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class ReportEvidenceService {
  final supabase = Supabase.instance.client;

  Future<String> uploadEvidence({
    required File file,
    required String eventId,
    required String venueId,
    required String reportDate,
    required String fileName,
  }) async {
    final path = 'reports/$eventId/$venueId/$reportDate/$fileName';

    await supabase.storage.from('report-evidences').upload(path, file);

    final publicUrl = supabase.storage
        .from('report-evidences')
        .getPublicUrl(path);

    return publicUrl;
  }
}
