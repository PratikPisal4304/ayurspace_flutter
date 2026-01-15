import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';
import '../screens/home/home_screen.dart';
import '../screens/discover/discover_screen.dart';
import '../screens/camera/camera_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/remedies/remedies_screen.dart';
import '../screens/wellness/wellness_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/plant_detail/plant_detail_screen.dart';
import '../screens/dosha_quiz/dosha_quiz_screen.dart';
import '../screens/dosha_profile/dosha_profile_screen.dart';
import '../screens/remedy_detail/remedy_detail_screen.dart';
import '../screens/bookmarks/bookmarks_screen.dart';
import '../screens/favorites/favorites_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/admin/data_seeder_screen.dart';
import '../widgets/common/main_scaffold.dart';


/// Router provider with auth guards
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/home',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isLoggingIn = state.uri.path == '/login' || state.uri.path == '/signup';

      // Protected routes
      final protectedRoutes = [
        '/profile',
        '/settings',
        '/bookmarks',
        '/favorites',
        '/edit-profile',
        '/dosha-profile'
      ];
      
      final isProtectedRoute = protectedRoutes.any((r) => state.uri.path.startsWith(r));

      if (!isLoggedIn && isProtectedRoute) {
        return '/login';
      }

      if (isLoggedIn && isLoggingIn) {
        return '/home';
      }

      // Redirect root to home
      if (state.uri.path == '/') {
        return '/home';
      }

      return null;
    },
    routes: [
      // Main shell with bottom navigation
      ShellRoute(
        builder: (context, state, child) {
          return MainScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/discover',
            name: 'discover',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DiscoverScreen(),
            ),
          ),
          GoRoute(
            path: '/camera',
            name: 'camera',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: CameraScreen(),
            ),
          ),
          GoRoute(
            path: '/chat',
            name: 'chat',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ChatScreen(),
            ),
          ),
          GoRoute(
            path: '/remedies',
            name: 'remedies',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: RemediesScreen(),
            ),
          ),
          GoRoute(
            path: '/wellness',
            name: 'wellness',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: WellnessScreen(),
            ),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
        ],
      ),
      // Detail screens
      GoRoute(
        path: '/plant/:id',
        name: 'plantDetail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return PlantDetailScreen(plantId: id);
        },
      ),
      GoRoute(
        path: '/dosha-quiz',
        name: 'doshaQuiz',
        builder: (context, state) => const DoshaQuizScreen(),
      ),
      GoRoute(
        path: '/dosha-profile',
        name: 'doshaProfile',
        builder: (context, state) => const DoshaProfileScreen(),
      ),
      GoRoute(
        path: '/remedy/:id',
        name: 'remedyDetail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return RemedyDetailScreen(remedyId: id);
        },
      ),
      GoRoute(
        path: '/bookmarks',
        name: 'bookmarks',
        builder: (context, state) => const BookmarksScreen(),
      ),
      GoRoute(
        path: '/favorites',
        name: 'favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: '/edit-profile',
        name: 'editProfile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/seed',
        name: 'seed',
        builder: (context, state) => const DataSeederScreen(),
      ),
    ],
  );
});
