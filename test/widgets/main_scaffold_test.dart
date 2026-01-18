import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:ayurspace_flutter/widgets/common/main_scaffold.dart';
import 'package:ayurspace_flutter/l10n/app_localizations.dart';

void main() {
  group('MainScaffold Widget Tests', () {
    Widget buildTestWidget({String initialLocation = '/home'}) {
      final router = GoRouter(
        initialLocation: initialLocation,
        routes: [
          ShellRoute(
            builder: (context, state, child) => MainScaffold(child: child),
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) =>
                    const Center(child: Text('Home Content')),
              ),
              GoRoute(
                path: '/discover',
                builder: (context, state) =>
                    const Center(child: Text('Discover Content')),
              ),
              GoRoute(
                path: '/camera',
                builder: (context, state) =>
                    const Center(child: Text('Camera Content')),
              ),
              GoRoute(
                path: '/remedies',
                builder: (context, state) =>
                    const Center(child: Text('Remedies Content')),
              ),
              GoRoute(
                path: '/profile',
                builder: (context, state) =>
                    const Center(child: Text('Profile Content')),
              ),
            ],
          ),
        ],
      );

      return MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
      );
    }

    testWidgets('renders 5 navigation items', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Should have 5 nav items
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Discover'), findsOneWidget);
      expect(find.text('Scan'), findsOneWidget);
      expect(find.text('Remedies'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('has correct icons for each nav item',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Check for nav icons (either outlined or filled based on selection)
      expect(find.byIcon(Icons.home), findsOneWidget); // Active
      expect(find.byIcon(Icons.local_florist_outlined), findsOneWidget);
      expect(find.byIcon(Icons.camera_alt_outlined), findsOneWidget);
      expect(find.byIcon(Icons.medical_services_outlined), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });

    testWidgets('displays child content', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Home Content'), findsOneWidget);
    });

    testWidgets('navigation to Discover works', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Tap on Discover
      await tester.tap(find.text('Discover'));
      await tester.pumpAndSettle();

      expect(find.text('Discover Content'), findsOneWidget);
    });

    testWidgets('navigation to Remedies works', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Tap on Remedies
      await tester.tap(find.text('Remedies'));
      await tester.pumpAndSettle();

      expect(find.text('Remedies Content'), findsOneWidget);
    });

    testWidgets('navigation to Profile works', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Tap on Profile
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      expect(find.text('Profile Content'), findsOneWidget);
    });

    testWidgets('active nav item shows filled icon',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Home should be active (filled icon)
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.home_outlined), findsNothing);

      // Navigate to Discover
      await tester.tap(find.text('Discover'));
      await tester.pumpAndSettle();

      // Discover should now be active (filled icon)
      expect(find.byIcon(Icons.local_florist), findsOneWidget);
      expect(find.byIcon(Icons.local_florist_outlined), findsNothing);
    });

    testWidgets('inactive nav items show outlined icons',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Home is active, others should be outlined
      expect(find.byIcon(Icons.local_florist_outlined), findsOneWidget);
      expect(find.byIcon(Icons.camera_alt_outlined), findsOneWidget);
      expect(find.byIcon(Icons.medical_services_outlined), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });
  });
}
