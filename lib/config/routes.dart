/// Centralized route path constants to avoid magic strings
/// and enable type-safe navigation throughout the app.
class AppRoutes {
  AppRoutes._(); // Private constructor to prevent instantiation

  // Main navigation routes (ShellRoute)
  static const String home = '/home';
  static const String discover = '/discover';
  static const String camera = '/camera';
  static const String remedies = '/remedies';
  static const String wellness = '/wellness';
  static const String profile = '/profile';

  // Detail screens
  static const String chat = '/chat';
  static const String plant = '/plant/:id';
  static const String doshaQuiz = '/dosha-quiz';
  static const String doshaProfile = '/dosha-profile';
  static const String remedy = '/remedy/:id';
  static const String scanResult = '/scan-result';
  static const String bookmarks = '/bookmarks';
  static const String favorites = '/favorites';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';

  // Auth routes
  static const String login = '/login';
  static const String signup = '/signup';

  // Helper methods for parameterized routes
  static String plantDetail(String id) => '/plant/$id';
  static String remedyDetail(String id) => '/remedy/$id';

  /// List of routes that require authentication
  static const List<String> protectedRoutes = [
    profile,
    settings,
    bookmarks,
    favorites,
    editProfile,
    doshaProfile,
  ];
}
