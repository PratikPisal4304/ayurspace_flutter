import 'package:go_router/go_router.dart';
import '../screens/home/home_screen.dart';
import '../screens/discover/discover_screen.dart';
import '../screens/camera/camera_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/remedies/remedies_screen.dart';
import '../screens/wellness/wellness_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/plant_detail/plant_detail_screen.dart';
import '../screens/dosha_quiz/dosha_quiz_screen.dart';
import '../screens/dosha_profile/dosha_profile_screen.dart';
import '../screens/remedy_detail/remedy_detail_screen.dart';
import '../widgets/common/main_scaffold.dart';

/// App router configuration
final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
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
    // Detail screens (outside of shell route)
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
  ],
);
