import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'config/theme.dart';
import 'config/router.dart';
import 'providers/firebase_provider.dart';
import 'services/auth_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ayurspace_flutter/l10n/app_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/maintenance/maintenance_screen.dart';

import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Create container to set initial provider state
  final container = ProviderContainer();

  // Try to initialize Firebase, but don't crash if it fails
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Pass all uncaught 'fatal' errors from the framework to Crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    container.read(firebaseInitializedProvider.notifier).state = true;
    debugPrint('✅ Firebase initialized successfully');

    // Attempt Silent Google Sign-In (Professional "Instant Login" flow)
    try {
      final authService = container.read(authServiceProvider);
      await authService.signInSilently();
    } catch (e) {
      debugPrint('Silent sign-in skipped: $e');
    }
  } catch (e) {
    debugPrint('⚠️ Firebase initialization failed: $e');
    debugPrint('App will run in offline mode');
    container.read(firebaseInitializedProvider.notifier).state = false;
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const AyurSpaceApp(),
    ),
  );
}

/// Custom scroll behavior that prevents automatic interactive scrollbars on web
/// This fixes "ScrollController attached to multiple positions" errors
class NoThumbScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
      };

  @override
  Widget buildScrollbar(
      BuildContext context, Widget child, ScrollableDetails details) {
    // Return child without wrapping in Scrollbar to prevent multiple position attachments
    return child;
  }
}

class AyurSpaceApp extends ConsumerWidget {
  const AyurSpaceApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFirebaseInitialized = ref.watch(firebaseInitializedProvider);
    final router = ref.watch(routerProvider);

    if (!isFirebaseInitialized) {
      return const MaintenanceScreen(
        error:
            'Firebase initialization failed. Check your internet connection.',
      );
    }

    return MaterialApp.router(
      title: 'AyurSpace',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
      scrollBehavior: NoThumbScrollBehavior(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('mr'),
      ],
    );
  }
}
