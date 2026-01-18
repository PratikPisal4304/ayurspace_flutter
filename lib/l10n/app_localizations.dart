import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'AyurSpace'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navDiscover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get navDiscover;

  /// No description provided for @navRemedies.
  ///
  /// In en, this message translates to:
  /// **'Remedies'**
  String get navRemedies;

  /// No description provided for @navScan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get navScan;

  /// No description provided for @navWellness.
  ///
  /// In en, this message translates to:
  /// **'Wellness'**
  String get navWellness;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get greetingEvening;

  /// No description provided for @dailyTip.
  ///
  /// In en, this message translates to:
  /// **'Daily Tip'**
  String get dailyTip;

  /// No description provided for @dailyTipContent.
  ///
  /// In en, this message translates to:
  /// **'Start your day with warm water and a teaspoon of honey to boost digestion and energy.'**
  String get dailyTipContent;

  /// No description provided for @featuredRemedies.
  ///
  /// In en, this message translates to:
  /// **'Featured Remedies'**
  String get featuredRemedies;

  /// No description provided for @featuredPlants.
  ///
  /// In en, this message translates to:
  /// **'Featured Plants'**
  String get featuredPlants;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search remedies, plants...'**
  String get searchHint;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @doshaQuiz.
  ///
  /// In en, this message translates to:
  /// **'Dosha Quiz'**
  String get doshaQuiz;

  /// No description provided for @plantScan.
  ///
  /// In en, this message translates to:
  /// **'Plant Scan'**
  String get plantScan;

  /// No description provided for @consultAi.
  ///
  /// In en, this message translates to:
  /// **'Consult AI'**
  String get consultAi;

  /// No description provided for @myHealth.
  ///
  /// In en, this message translates to:
  /// **'My Health'**
  String get myHealth;

  /// No description provided for @wellnessScoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Wellness Score'**
  String get wellnessScoreTitle;

  /// No description provided for @wellnessKeepUp.
  ///
  /// In en, this message translates to:
  /// **'Keep up the great work! 🌿'**
  String get wellnessKeepUp;

  /// No description provided for @remediesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Traditional Ayurvedic solutions'**
  String get remediesSubtitle;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFilters;

  /// No description provided for @remediesFound.
  ///
  /// In en, this message translates to:
  /// **'{count} remedies found'**
  String remediesFound(int count);

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorGeneric;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @noRemediesFound.
  ///
  /// In en, this message translates to:
  /// **'No remedies found'**
  String get noRemediesFound;

  /// No description provided for @profileBookmarks.
  ///
  /// In en, this message translates to:
  /// **'Bookmarked Plants'**
  String get profileBookmarks;

  /// No description provided for @profileFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorite Remedies'**
  String get profileFavorites;

  /// No description provided for @profileDoshaQuiz.
  ///
  /// In en, this message translates to:
  /// **'Take Dosha Quiz'**
  String get profileDoshaQuiz;

  /// No description provided for @profileHelp.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get profileHelp;

  /// No description provided for @profileAbout.
  ///
  /// In en, this message translates to:
  /// **'About AyurSpace'**
  String get profileAbout;

  /// No description provided for @statsPlants.
  ///
  /// In en, this message translates to:
  /// **'Plants\nScanned'**
  String get statsPlants;

  /// No description provided for @statsRemedies.
  ///
  /// In en, this message translates to:
  /// **'Remedies\nTried'**
  String get statsRemedies;

  /// No description provided for @statsWellness.
  ///
  /// In en, this message translates to:
  /// **'Wellness\nScore'**
  String get statsWellness;

  /// No description provided for @achievementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievementsTitle;

  /// No description provided for @doshaResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Dosha: {dosha}'**
  String doshaResultTitle(String dosha);

  /// No description provided for @doshaDiscover.
  ///
  /// In en, this message translates to:
  /// **'Discover Your Dosha'**
  String get doshaDiscover;

  /// No description provided for @doshaViewDetails.
  ///
  /// In en, this message translates to:
  /// **'Tap to view details'**
  String get doshaViewDetails;

  /// No description provided for @doshaTakeQuiz.
  ///
  /// In en, this message translates to:
  /// **'Take the quiz to find out'**
  String get doshaTakeQuiz;

  /// No description provided for @streakDays.
  ///
  /// In en, this message translates to:
  /// **'{count} day streak'**
  String streakDays(int count);

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signInToContWith.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue your wellness journey'**
  String get signInToContWith;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @noAccountYet.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccountYet;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @startWellnessJourney.
  ///
  /// In en, this message translates to:
  /// **'Start your Ayurvedic wellness journey'**
  String get startWellnessJourney;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @sessionComplete.
  ///
  /// In en, this message translates to:
  /// **'Session Complete!'**
  String get sessionComplete;

  /// No description provided for @meditationGreatJob.
  ///
  /// In en, this message translates to:
  /// **'Great job on your meditation practice.'**
  String get meditationGreatJob;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @howAreYouFeeling.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling?'**
  String get howAreYouFeeling;

  /// No description provided for @quickMeditation.
  ///
  /// In en, this message translates to:
  /// **'Quick Meditation'**
  String get quickMeditation;

  /// No description provided for @sleepSounds.
  ///
  /// In en, this message translates to:
  /// **'Sleep Sounds'**
  String get sleepSounds;

  /// No description provided for @nowPlaying.
  ///
  /// In en, this message translates to:
  /// **'Now playing: {sound}'**
  String nowPlaying(String sound);

  /// No description provided for @dayStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'{count} Day Streak!'**
  String dayStreakTitle(int count);

  /// No description provided for @startWellnessToday.
  ///
  /// In en, this message translates to:
  /// **'Start your wellness journey today'**
  String get startWellnessToday;

  /// No description provided for @keepItUp.
  ///
  /// In en, this message translates to:
  /// **'Keep it up! You\'re doing great.'**
  String get keepItUp;

  /// No description provided for @minsMediated.
  ///
  /// In en, this message translates to:
  /// **'Mins Meditated'**
  String get minsMediated;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @dayStreak.
  ///
  /// In en, this message translates to:
  /// **'Day Streak'**
  String get dayStreak;

  /// No description provided for @morning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get morning;

  /// No description provided for @evening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get evening;

  /// No description provided for @morningRoutine.
  ///
  /// In en, this message translates to:
  /// **'Morning Routine'**
  String get morningRoutine;

  /// No description provided for @eveningRoutine.
  ///
  /// In en, this message translates to:
  /// **'Evening Routine'**
  String get eveningRoutine;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpAndSupport;

  /// No description provided for @helpEmail.
  ///
  /// In en, this message translates to:
  /// **'Email: support@ayurspace.app'**
  String get helpEmail;

  /// No description provided for @helpWebsite.
  ///
  /// In en, this message translates to:
  /// **'Website: www.ayurspace.app'**
  String get helpWebsite;

  /// No description provided for @faqs.
  ///
  /// In en, this message translates to:
  /// **'FAQs'**
  String get faqs;

  /// No description provided for @faqScanner.
  ///
  /// In en, this message translates to:
  /// **'How do I use the plant scanner?'**
  String get faqScanner;

  /// No description provided for @faqDosha.
  ///
  /// In en, this message translates to:
  /// **'What is my dosha?'**
  String get faqDosha;

  /// No description provided for @faqRemedies.
  ///
  /// In en, this message translates to:
  /// **'Are remedies safe to use?'**
  String get faqRemedies;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @aboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get aboutVersion;

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'Your complete Ayurveda companion. Discover traditional herbs, personalized remedies, and wellness practices based on ancient wisdom.'**
  String get aboutDescription;

  /// No description provided for @aboutCopyright.
  ///
  /// In en, this message translates to:
  /// **'© 2024 AyurSpace. All rights reserved.'**
  String get aboutCopyright;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @resetPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a link to reset your password.'**
  String get resetPasswordDesc;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @sendLink.
  ///
  /// In en, this message translates to:
  /// **'Send Link'**
  String get sendLink;

  /// No description provided for @validEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get validEmailRequired;

  /// No description provided for @passwordResetSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent to {email}'**
  String passwordResetSent(String email);

  /// No description provided for @plantAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get plantAbout;

  /// No description provided for @plantBenefits.
  ///
  /// In en, this message translates to:
  /// **'Health Benefits'**
  String get plantBenefits;

  /// No description provided for @plantDoshas.
  ///
  /// In en, this message translates to:
  /// **'Balances Doshas'**
  String get plantDoshas;

  /// No description provided for @plantSeasons.
  ///
  /// In en, this message translates to:
  /// **'Best Seasons'**
  String get plantSeasons;

  /// No description provided for @plantCompounds.
  ///
  /// In en, this message translates to:
  /// **'Active Compounds'**
  String get plantCompounds;

  /// No description provided for @plantUses.
  ///
  /// In en, this message translates to:
  /// **'Traditional Uses'**
  String get plantUses;

  /// No description provided for @plantDosage.
  ///
  /// In en, this message translates to:
  /// **'Recommended Dosage'**
  String get plantDosage;

  /// No description provided for @plantPrecautions.
  ///
  /// In en, this message translates to:
  /// **'Precautions'**
  String get plantPrecautions;

  /// No description provided for @plantContraindications.
  ///
  /// In en, this message translates to:
  /// **'Contraindications'**
  String get plantContraindications;

  /// No description provided for @plantDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Growing Difficulty'**
  String get plantDifficulty;

  /// No description provided for @plantTips.
  ///
  /// In en, this message translates to:
  /// **'Growing Tips'**
  String get plantTips;

  /// No description provided for @plantHarvest.
  ///
  /// In en, this message translates to:
  /// **'Harvest Time'**
  String get plantHarvest;

  /// No description provided for @plantDetails.
  ///
  /// In en, this message translates to:
  /// **'Plant Details'**
  String get plantDetails;

  /// No description provided for @plantCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get plantCategory;

  /// No description provided for @plantPartUsed.
  ///
  /// In en, this message translates to:
  /// **'Part Used'**
  String get plantPartUsed;

  /// No description provided for @plantOrigin.
  ///
  /// In en, this message translates to:
  /// **'Origin'**
  String get plantOrigin;

  /// No description provided for @plantDoshaBalance.
  ///
  /// In en, this message translates to:
  /// **'Dosha Balance'**
  String get plantDoshaBalance;

  /// No description provided for @plantTaste.
  ///
  /// In en, this message translates to:
  /// **'Taste Profile (Rasa)'**
  String get plantTaste;

  /// No description provided for @plantNames.
  ///
  /// In en, this message translates to:
  /// **'Names'**
  String get plantNames;

  /// No description provided for @nameEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get nameEnglish;

  /// No description provided for @nameHindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get nameHindi;

  /// No description provided for @nameScientific.
  ///
  /// In en, this message translates to:
  /// **'Scientific'**
  String get nameScientific;

  /// No description provided for @nameSanskrit.
  ///
  /// In en, this message translates to:
  /// **'Sanskrit'**
  String get nameSanskrit;

  /// No description provided for @ayurvedicProps.
  ///
  /// In en, this message translates to:
  /// **'Ayurvedic Properties'**
  String get ayurvedicProps;

  /// No description provided for @propBalances.
  ///
  /// In en, this message translates to:
  /// **'Balances'**
  String get propBalances;

  /// No description provided for @propPotency.
  ///
  /// In en, this message translates to:
  /// **'Potency (Virya)'**
  String get propPotency;

  /// No description provided for @propPostDigestive.
  ///
  /// In en, this message translates to:
  /// **'Post-Digestive (Vipaka)'**
  String get propPostDigestive;

  /// No description provided for @actionFindRemedies.
  ///
  /// In en, this message translates to:
  /// **'Find Remedies'**
  String get actionFindRemedies;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get actionSaved;

  /// No description provided for @actionShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get actionShare;

  /// No description provided for @tabOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get tabOverview;

  /// No description provided for @tabUses.
  ///
  /// In en, this message translates to:
  /// **'Uses'**
  String get tabUses;

  /// No description provided for @tabGrowing.
  ///
  /// In en, this message translates to:
  /// **'Growing'**
  String get tabGrowing;

  /// No description provided for @tabAyurveda.
  ///
  /// In en, this message translates to:
  /// **'Ayurveda'**
  String get tabAyurveda;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
