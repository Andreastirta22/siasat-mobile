import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:crewsync_mobile/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const CrewSyncApp());

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
