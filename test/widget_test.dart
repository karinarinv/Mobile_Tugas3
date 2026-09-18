// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:klinik_bidan/app_shell.dart';
import 'package:klinik_bidan/core/auth_provider.dart';
import 'package:klinik_bidan/main.dart';

void main() {
  testWidgets('app shows login screen when no user is logged in', (WidgetTester tester) async {
    final auth = AuthProvider()
      ..checking = false
      ..token = null
      ..username = null;

    await tester.pumpWidget(
      ChangeNotifierProvider<AuthProvider>.value(
        value: auth,
        child: const KlinikBidanApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Klinik Bidan Sehati'), findsOneWidget);
    expect(find.text('Masuk Aplikasi'), findsOneWidget);
  });

  testWidgets('named home route is available after login', (WidgetTester tester) async {
    final auth = AuthProvider()
      ..checking = false
      ..token = 'demo-token'
      ..username = 'bidan_asti';

    await tester.pumpWidget(
      ChangeNotifierProvider<AuthProvider>.value(
        value: auth,
        child: const KlinikBidanApp(),
      ),
    );

    await tester.pumpAndSettle();

    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.pushNamed('/home');
    await tester.pumpAndSettle();

    expect(find.byType(AppShell), findsOneWidget);
    expect(find.text('Utama'), findsOneWidget);
  });
}
