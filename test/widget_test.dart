import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:users/screens/signup_screen.dart';

void main() {
  group('SignupScreen', () {
    testWidgets('Validate Name Field', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SignupScreen()));

      final nameField = find.byKey(const Key('name_text_field'));
      final signupButton = find.byKey(const Key('signup_button'));

      await tester.enterText(nameField, '');
      await tester.tap(signupButton);
      await tester.pump();

      expect(find.text('Name should be at least 4 characters'), findsOneWidget);
    });

    testWidgets('Validate Email Field', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SignupScreen()));

      final emailField = find.byKey(const Key('email_text_field'));
      final signupButton = find.byKey(const Key('signup_button'));

      await tester.enterText(emailField, 'invalidemail');
      await tester.tap(signupButton);
      await tester.pump();

      expect(find.text('Email address is not valid'), findsOneWidget);
    });

    // Add more tests for other fields and functionalities

    testWidgets('Register New User', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SignupScreen()));

      final nameField = find.byKey(const Key('name_text_field'));
      final emailField = find.byKey(const Key('email_text_field'));
      final phoneField = find.byKey(const Key('phone_text_field'));
      final passwordField = find.byKey(const Key('password_text_field'));
      final addressField = find.byKey(const Key('address_text_field'));
      final signupButton = find.byKey(const Key('signup_button'));

      // Enter valid data into all fields
      await tester.enterText(nameField, 'John Doe');
      await tester.enterText(emailField, 'johndoe@example.com');
      await tester.enterText(phoneField, '+1234567890');
      await tester.enterText(passwordField, 'password123');
      await tester.enterText(addressField, '123 Street, City');

      // Tap signup button
      await tester.tap(signupButton);
      await tester.pumpAndSettle();

      // Verify success message
      expect(find.text('Your Account has been created'), findsOneWidget);
    });
  });
}
