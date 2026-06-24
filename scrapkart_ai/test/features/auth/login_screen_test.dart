import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrapkart_ai/features/auth/login_screen.dart';

void main() {
  testWidgets('LoginScreen renders basic layout', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    // Assuming the screen has a Scaffold, we can verify it renders without crashing.
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
