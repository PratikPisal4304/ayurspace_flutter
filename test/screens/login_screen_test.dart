import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ayurspace_flutter/screens/auth/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ayurspace_flutter/providers/auth_provider.dart';

// Mock auth notifier for testing
class MockAuthNotifier extends StateNotifier<AuthState> with Mock
    implements AuthNotifier {
  MockAuthNotifier() : super(const AuthState());

  @override
  Future<void> signIn({required String email, required String password}) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 100));
    state = state.copyWith(isLoading: false);
  }

  @override
  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 100));
    state = state.copyWith(isLoading: false);
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {}

  @override
  Future<void> signOut() async {}

  @override
  Future<void> sendPasswordReset(String email) async {}
}

// Simple mock trait
mixin Mock {}

void main() {
  group('LoginScreen Widget Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          authProvider.overrideWith((ref) => MockAuthNotifier()),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    Widget buildTestWidget() {
      return UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(
            body: LoginScreen(),
          ),
        ),
      );
    }

    testWidgets('renders app branding elements', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Check for app branding
      expect(find.text('AyurSpace'), findsOneWidget);
      expect(find.text('Your Digital Ayurveda Companion'), findsOneWidget);
      expect(find.byIcon(Icons.spa), findsOneWidget);
    });

    testWidgets('renders welcome text', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Sign in to continue your wellness journey'), findsOneWidget);
    });

    testWidgets('renders form input fields', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('renders forgot password link', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Forgot Password?'), findsOneWidget);
    });

    testWidgets('password visibility toggle works', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Initially password should be obscured (visibility_off icon shown)
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsNothing);

      // Tap to toggle visibility
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();

      // Now password should be visible (visibility icon shown)
      expect(find.byIcon(Icons.visibility), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsNothing);
    });

    testWidgets('email validation shows error for empty email',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Find all TextFormFields and enter text only in password
      final passwordField = find.byType(TextFormField).at(1);
      await tester.enterText(passwordField, 'password123');

      // Scroll to Sign In button and tap it
      await tester.ensureVisible(find.text('Sign In'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sign In'), warnIfMissed: false);
      await tester.pump();

      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('email validation shows error for invalid email format',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Enter invalid email
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'invalid-email');

      // Enter password
      final passwordField = find.byType(TextFormField).at(1);
      await tester.enterText(passwordField, 'password123');

      // Scroll to Sign In button and tap it
      await tester.ensureVisible(find.text('Sign In'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sign In'), warnIfMissed: false);
      await tester.pump();

      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('password validation shows error for empty password',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Enter valid email but no password
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'test@example.com');

      // Scroll to Sign In button and tap it
      await tester.ensureVisible(find.text('Sign In'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sign In'), warnIfMissed: false);
      await tester.pump();

      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('forgot password dialog opens on tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Tap forgot password
      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();

      // Dialog should appear
      expect(find.text('Reset Password'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Send Link'), findsOneWidget);
    });

    testWidgets('has email and lock icons for form fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });
  });
}
