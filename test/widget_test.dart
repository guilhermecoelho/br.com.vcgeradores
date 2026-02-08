// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vc_geradores/src/views/budget/listBudget.dart';

void main() {
  testWidgets('Budget app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(ListBudget());

    // Verify that the app bar is present
    expect(find.text('Orçamentos'), findsOneWidget);

    // Verify that the FAB (floating action button) is present
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
