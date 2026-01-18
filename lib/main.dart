import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'config/theme.dart';
import 'config/router.dart';
import 'providers/firebase_provider.dart';
import 'services/auth_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ayurspace_flutter/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create container to set initial provider state
  final container = ProviderContainer();
  
  // Try to initialize Firebase, but don't crash if it fails
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
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


class AyurSpaceApp extends ConsumerWidget {
  const AyurSpaceApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'AyurSpace',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
      ],
    );
  }
}
