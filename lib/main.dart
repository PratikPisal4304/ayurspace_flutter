import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'config/theme.dart';
import 'config/router.dart';
import 'providers/firebase_provider.dart';

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

class AyurSpaceApp extends StatelessWidget {
  const AyurSpaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AyurSpace',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
