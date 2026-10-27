import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:campus_connect/main.dart';

void main() {
  testWidgets('Unconfigured Firebase shows a recoverable setup screen',
      (tester) async {
    await tester.pumpWidget(const CampusApp());
    await tester.pumpAndSettle();
    expect(find.text('Let’s connect your campus'), findsOneWidget);
    expect(
        find.textContaining('Firebase is not configured yet'), findsOneWidget);
    expect(
        find.widgetWithText(FilledButton, 'Retry connection'), findsOneWidget);
  });
}
