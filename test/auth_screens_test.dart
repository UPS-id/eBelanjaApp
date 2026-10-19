import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysample/pages/login_screen.dart';
import 'package:mysample/pages/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('admin can log in with the default credentials', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const LoginPage(),
        routes: {'/home': (_) => const Scaffold(body: Text('Home screen'))},
      ),
    );

    await tester.tap(find.byKey(const Key('loginButton')));
    await tester.pumpAndSettle();

    expect(find.text('Home screen'), findsOneWidget);
  });

  testWidgets('registration saves credentials for login', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const RegisterPage(),
        routes: {'/login': (_) => const Scaffold(body: Text('Login screen'))},
      ),
    );

    await tester.enterText(find.byKey(const Key('fullNameField')), 'Ayu Putri');
    await tester.enterText(
      find.byKey(const Key('emailField')),
      'ayu@example.com',
    );
    await tester.enterText(find.byKey(const Key('usernameField')), 'ayu');
    await tester.enterText(
      find.byKey(const Key('passwordField')),
      'rahasia123',
    );
    await tester.enterText(
      find.byKey(const Key('confirmPasswordField')),
      'rahasia123',
    );
    await tester.ensureVisible(find.byType(FilledButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('registeredUsername'), 'ayu');
    expect(prefs.getString('registeredPassword'), 'rahasia123');
    expect(find.text('Login screen'), findsOneWidget);
  });
}
