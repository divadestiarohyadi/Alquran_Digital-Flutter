// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:apps_kurir/main.dart';

void main() {
  testWidgets('Al-Qur\'an app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const QuranApp());

    // Verify that our app contains expected text
    expect(find.text('Al-Qur\'an Digital'), findsOneWidget);
    expect(find.text('بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ'), findsOneWidget);

    // Verify that navigation bar exists
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });
}
