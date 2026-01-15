// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'AyurSpace';

  @override
  String get navHome => 'Home';

  @override
  String get navRemedies => 'Remedies';

  @override
  String get navScan => 'Scan';

  @override
  String get navWellness => 'Wellness';

  @override
  String get navProfile => 'Profile';

  @override
  String get greetingMorning => 'Good Morning';

  @override
  String get greetingAfternoon => 'Good Afternoon';

  @override
  String get greetingEvening => 'Good Evening';

  @override
  String get dailyTip => 'Daily Tip';

  @override
  String get featuredRemedies => 'Featured Remedies';

  @override
  String get featuredPlants => 'Featured Plants';

  @override
  String get viewAll => 'View All';

  @override
  String get searchHint => 'Search remedies, plants...';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get doshaQuiz => 'Dosha Quiz';

  @override
  String get plantScan => 'Plant Scan';

  @override
  String get consultAi => 'Consult AI';

  @override
  String get myHealth => 'My Health';

  @override
  String get wellnessScoreTitle => 'Your Wellness Score';

  @override
  String get wellnessKeepUp => 'Keep up the great work! 🌿';

  @override
  String get remediesSubtitle => 'Traditional Ayurvedic solutions';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String remediesFound(int count) {
    return '$count remedies found';
  }

  @override
  String get errorGeneric => 'Something went wrong';

  @override
  String get tryAgain => 'Try again';

  @override
  String get noRemediesFound => 'No remedies found';

  @override
  String get profileBookmarks => 'Bookmarked Plants';

  @override
  String get profileFavorites => 'Favorite Remedies';

  @override
  String get profileDoshaQuiz => 'Take Dosha Quiz';

  @override
  String get profileHelp => 'Help & Support';

  @override
  String get profileAbout => 'About AyurSpace';

  @override
  String get statsPlants => 'Plants\nScanned';

  @override
  String get statsRemedies => 'Remedies\nTried';

  @override
  String get statsWellness => 'Wellness\nScore';

  @override
  String get achievementsTitle => 'Achievements';

  @override
  String doshaResultTitle(String dosha) {
    return 'Your Dosha: $dosha';
  }

  @override
  String get doshaDiscover => 'Discover Your Dosha';

  @override
  String get doshaViewDetails => 'Tap to view details';

  @override
  String get doshaTakeQuiz => 'Take the quiz to find out';

  @override
  String streakDays(int count) {
    return '$count day streak';
  }
}
