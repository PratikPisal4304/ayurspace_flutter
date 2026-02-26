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
  String get navDiscover => 'Discover';

  @override
  String get navRemedies => 'Remedies';

  @override
  String get navScan => 'Scan';

  @override
  String get navWellness => 'Wellness';

  @override
  String get navProfile => 'Profile';

  @override
  String get navChat => 'Chat';

  @override
  String get greetingMorning => 'Good Morning';

  @override
  String get greetingAfternoon => 'Good Afternoon';

  @override
  String get greetingEvening => 'Good Evening';

  @override
  String get dailyTip => 'Daily Tip';

  @override
  String get dailyTipContent =>
      'Start your day with warm water and a teaspoon of honey to boost digestion and energy.';

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
  String get achievementsPlantScans => 'Plant Explorer';

  @override
  String get achievementsRemedies => 'Remedy Master';

  @override
  String get achievementsWellness => 'Wellness Guru';

  @override
  String get achievementsStreak => 'Week Streak';

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

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get signInToContWith => 'Sign in to continue your wellness journey';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get signIn => 'Sign In';

  @override
  String get or => 'OR';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get noAccountYet => 'Don\'t have an account?';

  @override
  String get signUp => 'Sign Up';

  @override
  String get continueAsGuest => 'Continue as Guest';

  @override
  String get createAccount => 'Create Account';

  @override
  String get startWellnessJourney => 'Start your Ayurvedic wellness journey';

  @override
  String get fullName => 'Full Name';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get sessionComplete => 'Session Complete!';

  @override
  String get meditationGreatJob => 'Great job on your meditation practice.';

  @override
  String get done => 'Done';

  @override
  String get howAreYouFeeling => 'How are you feeling?';

  @override
  String get quickMeditation => 'Quick Meditation';

  @override
  String get sleepSounds => 'Sleep Sounds';

  @override
  String nowPlaying(String sound) {
    return 'Now playing: $sound';
  }

  @override
  String dayStreakTitle(int count) {
    return '$count Day Streak!';
  }

  @override
  String get startWellnessToday => 'Start your wellness journey today';

  @override
  String get keepItUp => 'Keep it up! You\'re doing great.';

  @override
  String get minsMediated => 'Mins Meditated';

  @override
  String get thisWeek => 'This Week';

  @override
  String get dayStreak => 'Day Streak';

  @override
  String get morning => 'Morning';

  @override
  String get evening => 'Evening';

  @override
  String get morningRoutine => 'Morning Routine';

  @override
  String get eveningRoutine => 'Evening Routine';

  @override
  String get stop => 'Stop';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Resume';

  @override
  String get helpAndSupport => 'Help & Support';

  @override
  String get helpEmail => 'Email: support@ayurspace.app';

  @override
  String get helpWebsite => 'Website: www.ayurspace.app';

  @override
  String get faqs => 'FAQs';

  @override
  String get faqScanner => 'How do I use the plant scanner?';

  @override
  String get faqDosha => 'What is my dosha?';

  @override
  String get faqRemedies => 'Are remedies safe to use?';

  @override
  String get close => 'Close';

  @override
  String get aboutVersion => 'Version 1.0.0';

  @override
  String get aboutDescription =>
      'Your complete Ayurveda companion. Discover traditional herbs, personalized remedies, and wellness practices based on ancient wisdom.';

  @override
  String get aboutCopyright => '© 2024 AyurSpace. All rights reserved.';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get resetPasswordDesc =>
      'Enter your email address and we\'ll send you a link to reset your password.';

  @override
  String get cancel => 'Cancel';

  @override
  String get sendLink => 'Send Link';

  @override
  String get validEmailRequired => 'Please enter a valid email';

  @override
  String passwordResetSent(String email) {
    return 'Password reset link sent to $email';
  }

  @override
  String get plantAbout => 'About';

  @override
  String get plantBenefits => 'Health Benefits';

  @override
  String get plantDoshas => 'Balances Doshas';

  @override
  String get plantSeasons => 'Best Seasons';

  @override
  String get plantCompounds => 'Active Compounds';

  @override
  String get plantUses => 'Traditional Uses';

  @override
  String get plantDosage => 'Recommended Dosage';

  @override
  String get plantPrecautions => 'Precautions';

  @override
  String get plantContraindications => 'Contraindications';

  @override
  String get plantDifficulty => 'Growing Difficulty';

  @override
  String get plantTips => 'Growing Tips';

  @override
  String get plantHarvest => 'Harvest Time';

  @override
  String get plantDetails => 'Plant Details';

  @override
  String get plantCategory => 'Category';

  @override
  String get plantPartUsed => 'Part Used';

  @override
  String get plantOrigin => 'Origin';

  @override
  String get plantDoshaBalance => 'Dosha Balance';

  @override
  String get plantTaste => 'Taste Profile (Rasa)';

  @override
  String get plantNames => 'Names';

  @override
  String get nameEnglish => 'English';

  @override
  String get nameHindi => 'Hindi';

  @override
  String get nameScientific => 'Scientific';

  @override
  String get nameSanskrit => 'Sanskrit';

  @override
  String get ayurvedicProps => 'Ayurvedic Properties';

  @override
  String get propBalances => 'Balances';

  @override
  String get propPotency => 'Potency (Virya)';

  @override
  String get propPostDigestive => 'Post-Digestive (Vipaka)';

  @override
  String get actionFindRemedies => 'Find Remedies';

  @override
  String get actionSave => 'Save';

  @override
  String get actionSaved => 'Saved';

  @override
  String get actionShare => 'Share';

  @override
  String get tabOverview => 'Overview';

  @override
  String get tabUses => 'Uses';

  @override
  String get tabGrowing => 'Growing';

  @override
  String get tabAyurveda => 'Ayurveda';

  @override
  String get scannerTitle => 'Plant Scanner';

  @override
  String get scannerSubtitle => 'Identify any Ayurvedic plant';

  @override
  String get pointToIdentify => 'Point at a plant to identify';

  @override
  String get clearPhotoHint =>
      'Take a clear photo of leaves or the whole plant';

  @override
  String get analyzing => 'Analyzing plant...';

  @override
  String get aiPowered => 'Using Plant.id + Gemini AI';

  @override
  String get identificationFailed => 'Identification Failed';

  @override
  String get scanAgain => 'Scan Again';

  @override
  String get viewDetails => 'View Details';

  @override
  String get fullInfo => 'Full Info';

  @override
  String get recentScans => 'Recent Scans';

  @override
  String get gallery => 'Gallery';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get ayurvedicInfo => 'Ayurvedic Information';

  @override
  String get aiDisclaimer =>
      'This information is AI-generated. Please verify with an Ayurvedic practitioner.';

  @override
  String get ayurvedicDatabase => 'Ayurvedic Database';

  @override
  String get aiGeneratedInfo => 'AI Generated Info';

  @override
  String confidenceMatch(int percent) {
    return '$percent% match';
  }

  @override
  String get moreDailyTips => 'More daily tips coming soon!';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsPushNotifications => 'Push Notifications';

  @override
  String get settingsPushSubtitle => 'Receive daily tips and reminders';

  @override
  String get settingsDailyTips => 'Daily Wellness Tips';

  @override
  String get settingsDailyTipsSubtitle => 'Get Ayurvedic tips each morning';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsDarkMode => 'Dark Mode';

  @override
  String get settingsDarkModeSubtitle => 'Switch to dark theme';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSubtitle => 'Choose your preferred language';

  @override
  String get settingsData => 'Data & Storage';

  @override
  String get settingsAutoBackup => 'Auto Backup';

  @override
  String get settingsAutoBackupSubtitle => 'Backup data to cloud';

  @override
  String get settingsClearCache => 'Clear Cache';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsDeleteAccount => 'Delete Account';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsAppVersion => 'App Version';

  @override
  String get settingsSignOut => 'Sign Out';

  @override
  String get settingsSignOutConfirm => 'Are you sure you want to sign out?';

  @override
  String get settingsClearCacheConfirm =>
      'This will clear all cached data. Downloaded content may need to be re-downloaded.';

  @override
  String get settingsCacheCleared => 'Cache cleared successfully';

  @override
  String get settingsDarkModeComingSoon => 'Dark mode coming soon! 🌙';

  @override
  String get settingsDeleteAccountTitle => 'Delete Account';

  @override
  String get settingsDeleteAccountMsg =>
      'Are you sure you want to delete your account? This action cannot be undone and you will lose all your saved data, including Dosha profile, bookmarks, and streaks.';

  @override
  String get settingsDeleteAccountRequested =>
      'Account deletion requested. Support will contact you shortly.';

  @override
  String get settingsSelectLanguage => 'Select Language';

  @override
  String settingsLanguageComingSoon(String lang) {
    return '$lang language coming soon!';
  }

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get editProfileSaveChanges => 'Save Changes';

  @override
  String get editProfileNameShort => 'Name must be at least 2 characters';

  @override
  String get editProfileInvalidEmail => 'Please enter a valid email';

  @override
  String get editProfileUpdated => 'Profile updated successfully!';

  @override
  String get editProfileSelectAvatar => 'Select Avatar';

  @override
  String get editProfileName => 'Name';

  @override
  String get editProfileEmail => 'Email';

  @override
  String get doshaProfileTitle => 'Your Dosha Profile';

  @override
  String get doshaProfileNoAssessment => 'Your Dosha';

  @override
  String get doshaDiscoverTitle => 'Discover Your Dosha';

  @override
  String get doshaDiscoverSubtitle =>
      'Take the Ayurvedic assessment to reveal your unique mind-body constitution and unlock personalized wellness advice.';

  @override
  String doshaYouAre(String dosha) {
    return 'You are $dosha';
  }

  @override
  String get doshaBreakdown => 'Dosha Breakdown';

  @override
  String doshaAbout(String dosha) {
    return 'About $dosha';
  }

  @override
  String get doshaBalancingDiet => 'Balancing Diet (Ahara)';

  @override
  String get doshaFavor => '✅ Favor';

  @override
  String get doshaAvoid => '❌ Avoid';

  @override
  String get doshaSeasonImpact => 'Current Season Impact';

  @override
  String doshaSeasonOf(String dosha) {
    return 'Season of $dosha';
  }

  @override
  String get doshaSeasonWarning =>
      'Pay extra attention! This season naturally increases your dominant dosha. Stick strictly to your balancing routines.';

  @override
  String doshaSeasonNeutral(String dosha) {
    return 'This season may help balance your dominant dosha, but remain mindful of $dosha aggravation.';
  }

  @override
  String get doshaRetakeQuiz => 'Retake Quiz';

  @override
  String get chatAyurBot => 'AyurBot';

  @override
  String get chatExpert => 'Ayurveda Expert';

  @override
  String get chatThinking => 'Thinking...';

  @override
  String get chatNewChat => 'New Chat';

  @override
  String get chatHistory => 'Chat History';

  @override
  String get chatStartNew => 'Start New Chat';

  @override
  String get chatStartNewConfirm => 'Start New Chat?';

  @override
  String get chatStartNewMsg => 'This will clear the current conversation.';

  @override
  String get chatRecentConversations => 'Recent Conversations';

  @override
  String get chatNoConversations => 'No conversations yet';

  @override
  String get chatClearAll => 'Clear All History';

  @override
  String get chatClearAllMsg =>
      'This will delete all your chat conversations. This action cannot be undone.';

  @override
  String get chatDeleteAll => 'Delete All';

  @override
  String get chatSwipeHint => 'Swipe left on a chat to delete it';

  @override
  String get chatStartConversation => 'Start a conversation';

  @override
  String get chatDismiss => 'Dismiss';

  @override
  String get chatTypeMessage => 'Ask about Ayurveda...';

  @override
  String memberSince(String date) {
    return 'Member since $date';
  }

  @override
  String get wellnessHub => 'Wellness Hub';

  @override
  String get dailyRoutine => 'Daily Routine (Dinacharya)';

  @override
  String get balanceDosha => 'Balance Your Dosha';

  @override
  String get seasonalWisdom => 'Seasonal Wisdom (Ritucharya)';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get share => 'Share';
}
